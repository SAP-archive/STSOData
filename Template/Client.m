//
//  Client.m
//  Usage Prototype
//
//  Created by Stadelman, Stan on 3/7/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "Client.h"

#import "OnlineStore.h"
#import "LogonHandler.h"
#import "MAFLogonRegistrationData+Bullio.h"

#import "SODataRequestParamSingleDefault.h"
#import "SODataEntitySet.h"

static NSString * const kServiceRoot = @"https://sapes1.sapdevcenter.com/sap/opu/odata/IWFND/RMTSAMPLEFLIGHT/";



@interface Client()

@end

@implementation Client

#pragma mark Singleton Init
+(instancetype)sharedClient
{
    static id _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient= [[Client alloc] init];
        
    });
    
    return _sharedClient;
}



#pragma mark Initialize with BaseURL and HttpConversationManager

-(instancetype)init
{
    if (self == [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserverForName:kLogonFinished object:nil queue:nil usingBlock:^(NSNotification *note) {
        
            NSLog(@"%s", __PRETTY_FUNCTION__);
        
            self.onlineStore = [[OnlineStore alloc] initWithURL:[LogonHandler shared].data.baseURL
                                        httpConversationManager:[LogonHandler shared].httpConvManager];
            
            [self.onlineStore openStoreWithCompletion:^(id openStore) {
            
                NSLog(@"%s", __PRETTY_FUNCTION__);
            
                [[NSNotificationCenter defaultCenter] postNotificationName:kStoreOpenFinished object:nil userInfo:nil];
                
            }];
        }];
        return self;
    }
    
    return nil;
}

- (void)fetchBookingsWithExpand {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    /*
     Construct the resource path, relative to the baseURL
     Include any oData filters & query parameters
     */
    
    NSString *resourcePath = @"BookingCollection?$top=5&$expand=bookedFlight";
    
    SODataRequestParamSingleDefault *requestParam = [[SODataRequestParamSingleDefault alloc] initWithMode:SODataRequestModeRead resourcePath:resourcePath];
    
    /*
     Schedule the request on the store
     */
    [self.onlineStore scheduleRequest:requestParam completionHandler:^(id<SODataEntitySet> entities, id<SODataRequestExecution> requestExecution, NSError *error) {
        
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        if (entities) {
            
            /*
             Use setter to the model property, to ensure it is recognized by KVO
             */
            [self setBookingsWithExpand:entities];
            
        } else {
            NSLog(@"did not get any entities, with error: %@", error);
        }
    }];
    
}


#pragma mark Networking Implementation

-(void)scheduleRequestForResource:(NSString *)resourcePath withMode:(SODataRequestModes)mode withEntity:(id<SODataEntity>)entity withCompletion:(void(^)(NSArray *array))completion
{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    SODataRequestParamSingleDefault *myRequest = [[SODataRequestParamSingleDefault alloc] initWithMode:mode resourcePath:resourcePath];
    
    [self.onlineStore scheduleRequest:myRequest completionHandler:^(id<SODataEntitySet> entities, id<SODataRequestExecution> requestExecution, NSError *error) {
    
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        if (!error) {
            if ([entities entities]) {
                completion([entities entities]);
            } else {
                completion(nil);
            }
        } else {
            NSLog(@"ALERT ERROR %@", error);
        }
    }];

}



@end
