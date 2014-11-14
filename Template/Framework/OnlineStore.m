//
//  OnlineStore.m
//  Template
//
//  Created by Stadelman, Stan on 8/4/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "OnlineStore.h"
#import "LogonHandler.h"

@interface OnlineStore () <SODataOnlineStoreDelegate>

@property (nonatomic, assign) BOOL isOpen;

@end

@implementation OnlineStore

#pragma mark Block Interface for openStore()

- (void) openStoreWithCompletion:(void(^)(BOOL success))completion
{

    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.isOpen) {
    
        completion(YES);
        
    } else {
        
        NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:openStoreFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
            NSLog(@"%s", __PRETTY_FUNCTION__);
            
            completion(YES);
        }];
        
        [self setOnlineStoreDelegate:self];
        
        __block void (^openStore)(void) = ^void() {
        
            NSError *error;
            
            [self openStoreWithError:&error];
            
            if (error) {
                NSLog(@"error = %@", error);
            }
        };
        
        
        if ([LogonHandler shared].logonManager.logonState.isUserRegistered &&
            [LogonHandler shared].logonManager.logonState.isSecureStoreOpen) {
            
            openStore();
            
        } else {
            
            [[NSNotificationCenter defaultCenter] addObserverForName:kOnlineStoreConfigured object:nil queue:nil usingBlock:^(NSNotification *note) {
                NSLog(@"%s", __PRETTY_FUNCTION__);
                
                openStore();
            }];
        }


    }
}

#pragma mark - OnlineStoreOpenDelegate

- (void) onlineStoreOpenFinished:(SODataOnlineStore *)store
{
    NSLog(@"%s", __PRETTY_FUNCTION__);

    SAPLOGINFO(LOG_ONLINESTORE, [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]);
    
    self.isOpen = YES;
    NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];
    
    // send notification for that openStore is finished
    [[NSNotificationCenter defaultCenter] postNotificationName:openStoreFinished object:self];
}

- (void) onlineStoreOpenFailed:(OnlineStore *)store error:(NSError *)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
    SAPLOGINFO(LOG_ONLINESTORE, [NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]);
}


@end
