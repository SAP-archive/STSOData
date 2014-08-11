//
//  OnlineStore.m
//  Template
//
//  Created by Stadelman, Stan on 8/4/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "OnlineStore.h"

#import "SODataResponse.h"
#import "SODataRequestExecution.h"
#import "SODataResponseSingle.h"
#import "SODataPayload.h"
#import "SODataRequestParamSingleDefault.h"
#import "SODataRequestDelegate.h"


@interface OnlineStore () <SODataOnlineStoreDelegate>

@property (nonatomic, assign) BOOL isOpen;

@end

@implementation OnlineStore

#pragma mark Block Interface for openStore()

- (void) openStoreWithCompletion:(void(^)(id openStore))completion
{

    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.isOpen) {
    
        completion(self);
        
    } else {
        
        NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:openStoreFinished object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            
            completion(note.object);
        }];
        
        NSError *error;
        
        [self setOnlineStoreDelegate:self];
        
        [self openStoreWithError:&error];
        
        if (error) {
            NSLog(@"error = %@", error);
        }

    }
}

#pragma mark - OnlineStoreOpenDelegate

- (void) onlineStoreOpenFinished:(SODataOnlineStore *)store
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.isOpen = YES;
    NSString *openStoreFinished = [NSString stringWithFormat:@"%@.%@", kStoreOpenDelegateFinished, [self description]];
    
    // send notification for that openStore is finished
    [[NSNotificationCenter defaultCenter] postNotificationName:openStoreFinished object:self];
}

- (void) onlineStoreOpenFailed:(SODataOnlineStore *)store error:(NSError *)error
{
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, error);
}

#pragma mark Block Interface for scheduleRequest()

- (void) scheduleRequest:(id<SODataRequestParam>)request completionHandler:(void(^)(id<SODataEntitySet>entities, id<SODataRequestExecution>requestExecution, NSError *error))completion
{

    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSString *finishedSubscription = [NSString stringWithFormat:@"%@.%@", kRequestDelegateFinished, request];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:finishedSubscription object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
    
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        // this code will handle the <requestExecution> response, and call the completion block.
        id<SODataRequestExecution>requestExecution = note.object;
        
        id<SODataResponse> response = requestExecution.response;
        
        if (response.isBatch)
        {
            // not yet implemented
        }
        else // not a batch response, only one response to handle
        {
            id<SODataResponseSingle> respSingle = (id<SODataResponseSingle>) response;
            // extract the payload
            id<SODataPayload> p = respSingle.payload;
            
            // response is an entity set, return EntitiesSet
            if ([respSingle payloadType] == SODataTypeEntitySet)
            {
                // copy and cast the entities from the response payload
                id<SODataEntitySet> entities = (id<SODataEntitySet>)p;
                
                // call completion block, with entities, requestExecution, and no error
                completion(entities, requestExecution, nil);
            }
            
            // if payload is an error, return Error
            else if ([respSingle payloadType] == SODataTypeError)
            {
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:@"Error querying data" forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"myDomain" code:100 userInfo:errorDetail];
                
                // call the completion block with error and requestExecution
                completion(nil, requestExecution, error);
            }
            
            // if payload is unhandled type, construct error
            else
            {
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:@"Unexpected payload type" forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"myDomain" code:100 userInfo:errorDetail];
                
                // call the completion block with error and requestExecution
                completion(nil, requestExecution, error);
                return;
            }
        }
        
        
    }];
    // then, the original SODataAsynch API is called
    
    [self scheduleRequest:request delegate:self];
    
    NSLog(@"Schedule request executed");
    
}

#pragma mark - SODataRequestDelegate methods

- (void) requestFailed:(id<SODataRequestExecution>)requestExecution error:(NSError *)error
{
    NSLog(@"%s\n%@", __PRETTY_FUNCTION__, error);
}

- (void) requestServerResponse:(id<SODataRequestExecution>)requestExecution
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    /*
    You may handle the server response from this callback, or the requestFinished
    callback.  The same content should be available in both, when requesting over
    network.
    
    At such time as it is possible to read from cache, as well as from network, then 
    this callback will only reflect content from over the network, while requestFinished
    will reflect the finished response of both cache and server
    */
}

- (void) requestStarted:(id<SODataRequestExecution>)requestExecution
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) requestCacheResponse:(id<SODataRequestExecution>)requestExecution
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void) requestFinished:(id<SODataRequestExecution>)requestExecution
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // build notification tag for this request
    NSString *finishedSubscription = [NSString stringWithFormat:@"%@.%@", kRequestDelegateFinished, requestExecution.request];

    // send notification for the finished request
    [[NSNotificationCenter defaultCenter] postNotificationName:finishedSubscription object:requestExecution];
}


@end
