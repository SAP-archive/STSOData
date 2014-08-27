//
//  DataController.m
//  Usage Prototype
//
//  Created by Stadelman, Stan on 3/7/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//


/*
 *
 *
 *  THIS CODE SHOULD BE BOILERPLATE
 *
 *
 *  MAKE ADDITIONS TO REQUEST INTERFACE THROUGH CATEGORIES
 *
 *
 *
 */


#import "DataController+FetchRequests.h"

#import "OnlineStore.h"
#import "OfflineStore.h"
#import "LogonHandler.h"

#import "SODataRequestDelegate.h"
#import "SODataRequestExecution.h"
#import "SODataResponseSingle.h"
#import "SODataPayload.h"
#import "SODataEntity.h"
#import "SODataError.h"
#import "SODataRequestParamSingleDefault.h"
#import "SODataEntityDefault.h"
#import "SODataEntitySetDefault.h"
#import "SODataErrorDefault.h"

@interface DataController() <SODataRequestDelegate>


@end

@implementation DataController

#pragma mark Singleton Init
+(instancetype)shared
{
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _shared= [[DataController alloc] init];
        
    });
    
    return _shared;
}



#pragma mark Initialize with BaseURL and HttpConversationManager

-(instancetype)init
{
    if (self == [super init]) {
        
                return self;
    }
    
    return nil;
}

/* 
   NORMALLY you would not need to implement this switch, and you could setup the store in a single  action.
   But, since this example is testing, here is a functional toggle between Online & Offline modes:

    1.  First, remove all listeners on self
    2.  Check if logon is already finished, (i.e. MAFLogonRegistrationData != nil)
    3.  If logon is already finished, simply initialize and open store
    3b.  If logon is not finished, then listen for kLogonFinished, then initialize and open store
*/

-(void)setWorkingMode:(WorkingModes)workingMode
{
    if (self.workingMode != workingMode) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        _workingMode = workingMode;
        
        if ([LogonHandler shared].logonManager.logonState.isUserRegistered) {
            [self setupStore];
        } else {
            [[NSNotificationCenter defaultCenter] addObserverForName:kLogonFinished object:nil queue:nil usingBlock:^(NSNotification *note) {
                
                NSLog(@"%s", __PRETTY_FUNCTION__);
                [self setupStore];
            }];
        }
        
    } else {
        NSLog(@"no change in working mode: %@", @(workingMode));
    }
    


}

- (void)setupStore
{
    if (self.workingMode == WorkingModeOnline) {
        
        NSURL *baseURL = [[NSURL URLWithString:[LogonHandler shared].data.applicationEndpointURL] URLByAppendingPathComponent:@"/"];
        
        self.store = [[OnlineStore alloc] initWithURL:baseURL
                              httpConversationManager:[LogonHandler shared].httpConvManager];
        
    } else if (self.workingMode == WorkingModeOffline) {
    
        self.store = [[OfflineStore alloc] init];
        
    }

}




#pragma mark Block Interface for scheduleRequest()

/* 
 * The application should invoke this method, since it wraps the scheduleRequest: method to ensure that the store is open
 *
 */

-(void)scheduleRequestForResource:(NSString *)resourcePath withMode:(SODataRequestModes)mode withEntity:(id<SODataEntity>)entity withCompletion:(void(^)(NSArray *entities, id<SODataRequestExecution>requestExecution, NSError *error))completion
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    SODataRequestParamSingleDefault *myRequest = [[SODataRequestParamSingleDefault alloc] initWithMode:mode resourcePath:resourcePath];
    myRequest.payload = entity ? entity : nil;
    
    [self.store openStoreWithCompletion:^(BOOL success) {
        
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        [self scheduleRequest:myRequest completionHandler:^(NSArray *entities, id<SODataRequestExecution> requestExecution, NSError *error) {
            
            NSLog(@"%s", __PRETTY_FUNCTION__);
            
            completion(entities, requestExecution, error);
        }];
    }];
    
}

/*
 *
 *  Do NOT invoke this method directly, since it does not ensure that the store is open
 *
 */

- (void) scheduleRequest:(id<SODataRequestParam>)request completionHandler:(void(^)(NSArray *entities, id<SODataRequestExecution>requestExecution, NSError *error))completion
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
                SODataEntitySetDefault *entities = (id<SODataEntitySet>)p;
                
                // call completion block, with entities, requestExecution, and no error
                completion(entities.entities, requestExecution, nil);
            }
            
            // if payload is an error, return Error
            else if ([respSingle payloadType] == SODataTypeError)
            {
                id<SODataPayload>p = respSingle.payload;
                SODataErrorDefault *e = p;
                
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:e.message forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"myDomain" code:e.code userInfo:errorDetail];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[NSString stringWithFormat:@"Code: %ld\nMessage: %@", e.code, e.message]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                // call the completion block with error and requestExecution
                completion(nil, requestExecution, error);
            }
            
            // response type == SODataTypeNone for CUD operations
            else if ([respSingle payloadType] == SODataTypeNone) {
            
                completion(nil, requestExecution, nil);
            }
            
            else if ([respSingle payloadType] == SODataTypeEntity) {
                
                id<SODataPayload> p = respSingle.payload;
                completion(@[(id<SODataEntity>)p], requestExecution, nil);
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
    
    [self.store scheduleRequest:request delegate:self];
    
    
}

#pragma mark - SODataRequestDelegate methods

- (void) requestFailed:(id<SODataRequestExecution>)requestExecution error:(NSError *)error
{
    NSLog(@"%s\n%@", __PRETTY_FUNCTION__, error);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request failed"
                                                    message:[NSString stringWithFormat:@"Error updating entity %@", [error description]]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void) requestServerResponse:(id<SODataRequestExecution>)requestExecution
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    /*
     You may handle the server response from this callback, or the requestFinished
     callback.  The same content should be available in both, when requesting over
     network.
     */
}

- (void) requestStarted:(id<SODataRequestExecution>)requestExecution
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
