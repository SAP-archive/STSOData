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


#import "DataController+FetchRequestsSample.h"

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
        
            self.definingRequests = [[NSArray alloc] init];
            self.workingMode = WorkingModeMixed;
            return self;
    }
    
    return nil;
}

/* 

    Here is where we setup the Online and Offline stores.  
    
    By default, the DataController works in 'Mixed' mode, meaning that both an Online and Offline
    store are initialized and configured.  
    
    For the sake of slimming down the application, the developer can also set 'Online' or 'Offline'
    mode directly.

    1.  First, remove all listeners on self
    2.  Check if logon is already finished, (i.e. MAFLogonRegistrationData != nil)
    3.  If logon is already finished, simply initialize and open store
    3b.  If logon is not finished, then listen for kLogonFinished, then initialize and open store
*/


-(void)loadWorkingMode
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([LogonHandler shared].logonManager.logonState.isUserRegistered &&
        [LogonHandler shared].logonManager.logonState.isSecureStoreOpen) {
        
        [self setupStores];
        
    } else {
        [[NSNotificationCenter defaultCenter] addObserverForName:kLogonFinished object:nil queue:nil usingBlock:^(NSNotification *note) {
            
            NSLog(@"%s", __PRETTY_FUNCTION__);
            
            [self setupStores];
        }];
    }
}

/*
    This switch: method can be used in the application to toggle between the two modes.
    This isn't really a typical use case in production, but does allow an application
    to show that code is reusable in both scenarios.
*/
//-(void)switchWorkingMode:(WorkingModes)workingMode
//{
//    if (self.workingMode != workingMode) {
//        
//        _workingMode = workingMode;
//        
//        [self loadWorkingMode];
//        
//    } else {
//        NSLog(@"no change in working mode: %@", @(workingMode));
//    }
//
//}

- (void)setupStores
{
    __block BOOL onlineStoreConfig = NO;
    __block BOOL offlineStoreConfig = NO;
    
    __block void (^setupNetworkStore)(void) = ^void() {
        
        NSURL *baseURL = [[NSURL URLWithString:[LogonHandler shared].data.applicationEndpointURL] URLByAppendingPathComponent:@"/"];
        
        self.networkStore = [[OnlineStore alloc] initWithURL:baseURL
                              httpConversationManager:[LogonHandler shared].httpConvManager];
        
        onlineStoreConfig = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kOnlineStoreConfigured object:nil];
    };
    
    __block void (^setupLocalStore)(void) = ^void() {
        
        self.localStore = [[OfflineStore alloc] init];
        
        offlineStoreConfig = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kOfflineStoreConfigured object:nil];
    };
    
    switch (self.workingMode) {
    
        case WorkingModeMixed:
            setupLocalStore();
            setupNetworkStore();
            break;
            
        case WorkingModeOnline:
            setupNetworkStore();
            break;
            
        case WorkingModeOffline:
            setupLocalStore();
            
        default:
            break;
    }
    
    NSAssert(onlineStoreConfig == YES && offlineStoreConfig == YES, @"both stores configured");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kStoreConfigured object:nil];
}

-(id<ODataStore>)storeForRequestToResourcePath:(NSString *)resourcePath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    /*
    First, test if mode is online- or offline-only anyway.
    */
    if (self.workingMode == WorkingModeOnline) {
    
        NSLog(@"Store %@ picked for resourcePath:  %@", [self.networkStore description], resourcePath);
        return self.networkStore;
        
    } else if (self.workingMode == WorkingModeOffline) {
    
        NSLog(@"Store %@ picked for resourcePath:  %@", [self.localStore description], resourcePath);
        return self.localStore;
    }
    
    /*
    And if there are any defining requests to test anyway
    */
    if (self.definingRequests.count < 1) {
        NSLog(@"Store %@ picked for resourcePath:  %@", [self.networkStore description], resourcePath);
        return self.networkStore;
    }
    
    /*
    Second, do a compare to see if the collection of the request matches the collection
    of the defining requests.  The principle here is that you can offline a collection,
    or filter of a collection, and all requests will be executed against the db for that
    collection.  You should adjust the filters of your defining requests to support the
    expected scope of requests for the user.
    */
    __block NSString * (^collectionName)(NSString *) = ^NSString * (NSString *string){
    
        return [string rangeOfString:@"?"].location != NSNotFound ? [string substringToIndex:[string rangeOfString:@"?"].location] : string;
    };
    
    NSString *resourcePathCollectionName = collectionName(resourcePath);
    
    for (NSString *request in self.definingRequests) {
        
        NSString *definingRequestCollectionName = collectionName(request);
        
        if ((resourcePathCollectionName && definingRequestCollectionName) && [resourcePathCollectionName isEqualToString:definingRequestCollectionName]) {
            
            NSLog(@"Store %@ picked for resourcePath:  %@", [self.localStore description], resourcePath);

            return self.localStore;
        }
    }
    
    /*
    Last, the default will always be to fall back to the network store (online request).
    This should cover Function Imports, and any requests which are not within the scope
    of the defining request collections
    */
    
    NSLog(@"Store %@ picked for resourcePath:  %@", [self.networkStore description], resourcePath);
    return self.networkStore;
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
    
    __block void (^openStore)(id<ODataStore>) = ^void(id<ODataStore>store) {
    
        [store openStoreWithCompletion:^(BOOL success) {
            
            NSLog(@"%s", __PRETTY_FUNCTION__);
            
            [self scheduleRequest:myRequest onStore:store completionHandler:^(NSArray *entities, id<SODataRequestExecution> requestExecution, NSError *error) {
                
                NSLog(@"%s", __PRETTY_FUNCTION__);
                
                completion(entities, requestExecution, error);
            }];
        }];
    };
    
    id<ODataStore>storeForRequest = [self storeForRequestToResourcePath:resourcePath];
    
    if (storeForRequest != nil) {
    
        openStore(storeForRequest);
        
    } else {
        NSLog(@"waiting for kStoreConfigured %s", __PRETTY_FUNCTION__);
        [[NSNotificationCenter defaultCenter] addObserverForName:kStoreConfigured object:nil queue:nil usingBlock:^(NSNotification *note) {
            
            NSLog(@"%s", __PRETTY_FUNCTION__);
            
            id<ODataStore>storeForRequest = [self storeForRequestToResourcePath:resourcePath];
            openStore(storeForRequest);

        }];
    }

}

/*
 *
 *  Do NOT invoke this method directly, since it does not ensure that the store is open
 *
 */

- (void) scheduleRequest:(id<SODataRequestParam>)request onStore:(id<SODataStoreAsync>)store completionHandler:(void(^)(NSArray *entities, id<SODataRequestExecution>requestExecution, NSError *error))completion
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
                SODataErrorDefault *e = (SODataErrorDefault *)p;
                
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:e.message forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"myDomain" code:[e.code integerValue] userInfo:errorDetail];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[NSString stringWithFormat:@"Code: %@\nMessage: %@", e.code, e.message]
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
    
    [store scheduleRequest:request delegate:self];
    
    
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
