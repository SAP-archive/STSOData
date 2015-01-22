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

#import <FXNotifications/FXNotifications.h>

@interface OfflineStore() <SODataOfflineStoreDelegate, SODataOfflineStoreRequestErrorDelegate, SODataOfflineStoreRefreshDelegate, SODataOfflineStoreFlushDelegate>

@property (nonatomic, assign) SODataOfflineStoreState state;

@end

@implementation OfflineStore

#pragma mark Block Interface for openStore()

- (instancetype)init
{
    if (self == [super init]) {
        self.state = SODataOfflineStoreClosed;
        return self;
    }
    return nil;
}

- (void) openStoreWithCompletion:(void(^)(BOOL success))completion
{
    
    NSString *openStoreFailed = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFailed, [self description]];
    NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];
    
    __block Timer *t = [Usage makeTimer:@"openStore"];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:openStoreFailed object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [Usage stopTimer:t info:@{@"type": @"offline", @"result" : @"failed"}];
        
        completion(NO);
    }];
    
    
    if (self.isOpen) {
        
        [Usage stopTimer:t info:@{@"type": @"offline", @"case": @"none", @"result" : @"success"}];
        
        completion(YES);
        
    } else if (self.state < SODataOfflineStoreOpen) {
        
        /* listen for open-finished notification here */
        
        [[NSNotificationCenter defaultCenter] addObserver:self forName:openStoreFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note, id observer) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:observer name:openStoreFinished object:observer];
            
            [Usage stopTimer:t info:@{@"type": @"offline", @"case": @"partial", @"result" : @"success"}];
            
            completion(YES);
        }];
        
    } else if (self.state == SODataOfflineStoreClosed){
        
        /* listen for open-finished notification here */
                
        [[NSNotificationCenter defaultCenter] addObserver:self forName:openStoreFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note, id observer) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:observer name:openStoreFinished object:observer];
            
            [Usage stopTimer:t info:@{@"type": @"offline", @"case": @"full", @"result" : @"success"}];
            
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
        
            [[NSNotificationCenter defaultCenter] addObserver:self forName:kOfflineStoreConfigured object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note, id observer) {
                
                [[NSNotificationCenter defaultCenter] removeObserver:observer name:kOfflineStoreConfigured object:observer];
                
                openStore();
            }];
        }
    }
}

#pragma mark - OfflineStore Delegate methods

- (void) offlineStoreStateChanged:(SODataOfflineStore *)store state:(SODataOfflineStoreState)newState{
    
    self.state = newState;
    
    switch (newState)
    {
        case SODataOfflineStoreOpening:
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            NSLog(@"SODataOfflineStoreOpening: The store has started to open\n");
            break;
            
        case SODataOfflineStoreInitializing:
            NSLog(@"SODataOfflineStoreInitializing: Initializing the resources for a new store\n");
            break;
            
        case SODataOfflineStorePopulating:
            NSLog(@"SODataOfflineStorePopulating: Creating and populating the store in the mid-tier\n");
            break;
            
        case SODataOfflineStoreDownloading:
            NSLog(@"SODataOfflineStoreDownloading: Downloading the populated store\n");
            break;
            
        case SODataOfflineStoreOpen:
            NSLog(@"SODataOfflineStoreOpen: The store has opened successfully\n");
            break;
            
        case SODataOfflineStoreClosed:
            NSLog(@"SODataOfflineStoreClosed: The store has been closed by the user while still opening\n");
            break;
            
    }
}

- (void) offlineStoreOpenFailed:(SODataOfflineStore *)store error:(NSError *)error
{

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSString *openStoreFailed = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFailed, [self description]];
    
    self.state = SODataOfflineStoreClosed;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:openStoreFailed object:nil];
}

-(void)offlineStoreOpenFinished:(SODataOfflineStore *)store
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (self.isOpen) {
        NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:openStoreFinished object:nil];
    }
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self forName:refreshFinishedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note, id observer) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:refreshFinishedNotification object:observer];
    
        completion(YES);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self forName:refreshFailedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note, id observer) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:refreshFailedNotification object:observer];
    
        completion(NO);
    }];
    
    [self scheduleRefreshWithDelegate:self];
}

#pragma mark - OfflineStore Refresh Delegate methods

- (void) offlineStoreRefreshSucceeded:(SODataOfflineStore *)store {

    NSString *refreshFinishedNotification = [NSString stringWithFormat:@"%@.%@", kRefreshDelegateFinished, self.description];
    [[NSNotificationCenter defaultCenter] postNotificationName:refreshFinishedNotification object:nil];

}
- (void) offlineStoreRefreshFailed:(SODataOfflineStore *)store error:(NSError *)error{
    
     NSString *refreshFailedNotification = [NSString stringWithFormat:@"%@.%@", kRefreshDelegateFailed, self.description];
    [[NSNotificationCenter defaultCenter] postNotificationName:refreshFailedNotification object:error];
}

-(void)offlineStoreRefreshFinished:(SODataOfflineStore *)store {

    [[NSNotificationCenter defaultCenter] postNotificationName:kSODataOfflineStoreFlushRefreshStateChange object:kSODataOfflineStoreRefreshFinishedText];
    
}

-(void)offlineStoreRefreshStarted:(SODataOfflineStore *)store {

    [[NSNotificationCenter defaultCenter] postNotificationName:kSODataOfflineStoreFlushRefreshStateChange object:kSODataOfflineStoreRefreshStartedText];
}

#pragma mark - OfflineStoreFlush block wrapper

- (void) flush:(void(^)(BOOL success))completion
{
    NSString *flushFinishedNotification = [NSString stringWithFormat:@"%@.%@", kFlushDelegateFinished, self.description];
    NSString *flushFailedNotification = [NSString stringWithFormat:@"%@.%@", kFlushDelegateFailed, self.description];
    
    [[NSNotificationCenter defaultCenter] addObserver:self forName:flushFinishedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note, id observer) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:flushFinishedNotification object:observer];

        completion(YES);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self forName:flushFailedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note, id observer) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:flushFailedNotification object:observer];
        
        completion(NO);
    }];
    
    [self scheduleFlushQueuedRequestsWithDelegate:self];
}

#pragma mark - OfflineStore Flush Delegate methods
- (void) offlineStoreFlushStarted:(SODataOfflineStore*) store
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSODataOfflineStoreFlushRefreshStateChange object:kSODataOfflineStoreFlushStartedText];
}
- (void) offlineStoreFlushFinished:(SODataOfflineStore*) store
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSODataOfflineStoreFlushRefreshStateChange object:kSODataOfflineStoreFlushFinishedText];
    
}
- (void) offlineStoreFlushSucceeded:(SODataOfflineStore*) store
{
    NSString *flushFinishedNotification = [NSString stringWithFormat:@"%@.%@", kFlushDelegateFinished, self.description];
    [[NSNotificationCenter defaultCenter] postNotificationName:flushFinishedNotification object:nil];
    
}
- (void) offlineStoreFlushFailed:(SODataOfflineStore*) store error:(NSError*) error
{
    NSString *flushFailedNotification = [NSString stringWithFormat:@"%@.%@", kFlushDelegateFailed, self.description];
    [[NSNotificationCenter defaultCenter] postNotificationName:flushFailedNotification object:error];
}

@end
