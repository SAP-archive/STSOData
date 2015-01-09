//
//  OfflineStore.m
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 8/11/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "OfflineStore.h"
#import "SODataOfflineStoreDelegate.h"
#import "SODataOfflineStoreOptions.h"
#import "LogonHandler.h"
#import "DataController.h"

@interface OfflineStore() <SODataOfflineStoreDelegate, SODataOfflineStoreRequestErrorDelegate, SODataOfflineStoreRefreshDelegate, SODataOfflineStoreFlushDelegate>

@property (nonatomic, assign) SODataOfflineStoreState state;

@end

@implementation OfflineStore

#pragma mark Block Interface for openStore()

- (instancetype)init
{
    if (self == [super init]) {
        return self;
    }
    return nil;
}

- (void) openStoreWithCompletion:(void(^)(BOOL success))completion
{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.isOpen) {
        
        completion(self);
        
    } else if (self.state > 0 && self.state < SODataOfflineStoreOpen) {
        
        /* listen for open-finished notification here */
        
        NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:openStoreFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            
            NSLog(@"%s", __PRETTY_FUNCTION__);
            
            completion(YES);
        }];
        
    } else {
                
        /* listen for open-finished notification here */
        
        NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:openStoreFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            
            NSLog(@"%s", __PRETTY_FUNCTION__);
            
            completion(YES);
        }];
        
        [self setOfflineStoreDelegate:self];
        [self setRequestErrorDelegate:self];
        
        __block void (^openStore)(void) = ^void() {
            
            NSError *error;
            
            [self openStoreWithOptions:[LogonHandler shared].options error:&error];
            
            if (error) {
                NSLog(@"error = %@", error);
            }
        };
        
        if ([LogonHandler shared].logonManager.logonState.isUserRegistered &&
            [LogonHandler shared].logonManager.logonState.isSecureStoreOpen) {
            
            openStore();
        
        } else {
        
            [[NSNotificationCenter defaultCenter] addObserverForName:kOfflineStoreConfigured object:nil queue:nil usingBlock:^(NSNotification *note) {
                NSLog(@"%s", __PRETTY_FUNCTION__);
                
                openStore();
            }];
        }
    }
}

#pragma mark - OfflineStore Delegate methods

- (void) offlineStoreStateChanged:(SODataOfflineStore *)store state:(SODataOfflineStoreState)newState{
    
    self.state = newState;
    
    NSString *notificationMessage;
    
    switch (newState)
    {
        case SODataOfflineStoreOpening:
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            NSLog(@"SODataOfflineStoreOpening: The store has started to open\n");
            notificationMessage = kSODataOfflineStoreOpeningText;
            break;
            
        case SODataOfflineStoreInitializing:
            NSLog(@"SODataOfflineStoreInitializing: Initializing the resources for a new store\n");
            notificationMessage = kSODataOfflineStoreInitializingText;
            break;
            
        case SODataOfflineStorePopulating:
            NSLog(@"SODataOfflineStorePopulating: Creating and populating the store in the mid-tier\n");
            notificationMessage = kSODataOfflineStorePopulatingText;
            break;
            
        case SODataOfflineStoreDownloading:
            NSLog(@"SODataOfflineStoreDownloading: Downloading the populated store\n");
            notificationMessage = kSODataOfflineStoreDownloadingText;
            break;
            
        case SODataOfflineStoreOpen:
            NSLog(@"SODataOfflineStoreOpen: The store has opened successfully\n");
            notificationMessage = kSODataOfflineStoreOpenText;
            break;
            
        case SODataOfflineStoreClosed:
            NSLog(@"SODataOfflineStoreClosed: The store has been closed by the user while still opening\n");
            notificationMessage = kSODataOfflineStoreClosedText;
            break;
            
    }
    
    /*
     UI may subscribe to this notification to discover state changes
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:kSODataOfflineStoreStateChange object:notificationMessage];
    
}

- (void) offlineStoreOpenFailed:(SODataOfflineStore *)store error:(NSError *)error{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    SAPLOGINFO(LOG_OFFLINESTORE, [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]);
}

-(void)offlineStoreOpenFinished:(SODataOfflineStore *)store {
    
    NSLog(@"Offline Store Open Finished");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    SAPLOGINFO(LOG_OFFLINESTORE, [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]);
    
    NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:openStoreFinished object:nil];
    
}

#pragma mark - FlushAndRefresh block wrapper

- (void) flushAndRefresh:(void (^)(BOOL))completion
{
    [self flush:^(BOOL success) {
        
        if (success) {
        
            [self refresh:^(BOOL success) {
                
                if (success) {
                
                    completion(YES);
                    
                } else {
                
                    completion(NO);
                    
                }
            }];
            
        } else {
        
            completion(NO);
            
            }
    }];
}

#pragma mark - OfflineStoreRefresh block wrapper

- (void) refresh:(void(^)(BOOL success))completion
{
    NSString *refreshFinishedNotification = [NSString stringWithFormat:@"%@.%@", kRefreshDelegateFinished, self.description];
    NSString *refreshFailedNotification = [NSString stringWithFormat:@"%@.%@", kRefreshDelegateFailed, self.description];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:refreshFinishedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        completion(YES);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:refreshFailedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        completion(NO);
    }];
    
    [self scheduleRefreshWithDelegate:self];
}

#pragma mark - OfflineStore Refresh Delegate methods

- (void) offlineStoreRefreshSucceeded:(SODataOfflineStore *)store {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *refreshFinishedNotification = [NSString stringWithFormat:@"%@.%@", kRefreshDelegateFinished, self.description];
    [[NSNotificationCenter defaultCenter] postNotificationName:refreshFinishedNotification object:nil];

}
- (void) offlineStoreRefreshFailed:(SODataOfflineStore *)store error:(NSError *)error{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
     NSString *refreshFailedNotification = [NSString stringWithFormat:@"%@.%@", kRefreshDelegateFailed, self.description];
    [[NSNotificationCenter defaultCenter] postNotificationName:refreshFailedNotification object:error];
}

-(void)offlineStoreRefreshFinished:(SODataOfflineStore *)store {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}

-(void)offlineStoreRefreshStarted:(SODataOfflineStore *)store {

    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - OfflineStoreFlush block wrapper

- (void) flush:(void(^)(BOOL success))completion
{
    NSString *flushFinishedNotification = [NSString stringWithFormat:@"%@.%@", kFlushDelegateFinished, self.description];
    NSString *flushFailedNotification = [NSString stringWithFormat:@"%@.%@", kFlushDelegateFailed, self.description];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:flushFinishedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        completion(YES);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:flushFailedNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        completion(NO);
    }];
    
    [self scheduleFlushQueuedRequestsWithDelegate:self];
}

#pragma mark - OfflineStore Flush Delegate methods
- (void) offlineStoreFlushStarted:(SODataOfflineStore*) store
{
    NSLog(@"%s", __PRETTY_FUNCTION__);;
}
- (void) offlineStoreFlushFinished:(SODataOfflineStore*) store
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
}
- (void) offlineStoreFlushSucceeded:(SODataOfflineStore*) store
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *flushFinishedNotification = [NSString stringWithFormat:@"%@.%@", kFlushDelegateFinished, self.description];
    [[NSNotificationCenter defaultCenter] postNotificationName:flushFinishedNotification object:nil];
    
}
- (void) offlineStoreFlushFailed:(SODataOfflineStore*) store error:(NSError*) error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *flushFailedNotification = [NSString stringWithFormat:@"%@.%@", kFlushDelegateFailed, self.description];
    [[NSNotificationCenter defaultCenter] postNotificationName:flushFailedNotification object:error];
}

@end
