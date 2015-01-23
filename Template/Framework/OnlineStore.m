//
//  OnlineStore.m
//  Template
//
//  Created by Stadelman, Stan on 8/4/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "OnlineStore.h"
#import "LogonHandler.h"

#import <FXNotifications/FXNotifications.h>

@interface OnlineStore () <SODataOnlineStoreDelegate>

@end

@implementation OnlineStore

#pragma mark Block Interface for openStore()

- (void) openStoreWithCompletion:(void(^)(BOOL success))completion
{
    
    __block Timer *t = [Usage makeTimer:@"openStore"];
    
    /*
     Listen for openStoreFailed; invoke completion with false
     */
    NSString *openStoreFailed = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFailed, [self description]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self forName:openStoreFailed object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note, id observer) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:openStoreFailed object:observer];
        
        [Usage stopTimer:t info:@{@"type": @"online", @"result" : @"failed"}];
        
        completion(NO);
    }];
    
    /*
     respond immediately if already open
     */
    
    if (self.isOpen) {
    
        [Usage stopTimer:t info:@{@"type": @"online", @"case": @"none", @"result" : @"success"}];
        
        completion(YES);
        
    } else {
        
        /*
         Listen for openStoreFinished; if store is open, invoke completion() block
         */
        __block NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self forName:openStoreFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note, id observer) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:observer name:openStoreFinished object:observer];
            
            [Usage stopTimer:t info:@{@"type": @"online", @"case": @"full", @"result" : @"success"}];
            
            completion(YES);
        }];
        
        
        [self setOnlineStoreDelegate:self];
        
        __block void (^openStore)(void) = ^void() {
        
            NSError *error;
            
            [self openStoreWithError:&error];
            
            if (error) {
                /*
                 if synchronous error, invoke faiure case immediately
                 */
                completion(NO);
            }
        };
        
        
        if ([LogonHandler shared].logonManager.logonState.isUserRegistered &&
            [LogonHandler shared].logonManager.logonState.isSecureStoreOpen) {
            
            openStore();
            
        } else {
            
            [[NSNotificationCenter defaultCenter] addObserver:self forName:kOnlineStoreConfigured object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note, id observer) {
                
                [[NSNotificationCenter defaultCenter] removeObserver:observer name:kOnlineStoreConfigured object:observer];
                
                openStore();
            }];
        }
    }
}

#pragma mark - OnlineStoreOpenDelegate

- (void) onlineStoreOpenFinished:(SODataOnlineStore *)store
{
    NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];

    // send notification for that openStore is finished
    [[NSNotificationCenter defaultCenter] postNotificationName:openStoreFinished object:self];
}

- (void) onlineStoreOpenFailed:(OnlineStore *)store error:(NSError *)error
{
    NSString *openStoreFailed = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFailed, [self description]];
    
    // send notification for that openStore is finished
    [[NSNotificationCenter defaultCenter] postNotificationName:openStoreFailed object:self];
}


@end
