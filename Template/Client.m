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

        self.onlineStore = [[OnlineStore alloc] initWithURL:[LogonHandler shared].data.baseURL
                                    httpConversationManager:[LogonHandler shared].httpConvManager];
    }
    
    return nil;
}


#pragma mark Networking Implementation

-(void)scheduleRequestForResource:(NSString *)resourcePath withMode:(SODataRequestModes)mode withEntity:(id<SODataEntity>)entity withCompletion:(void(^)(NSArray *array))completion
{
    
    /// Do this to make sure that the store is open
    [self.onlineStore openStoreWithCompletion:^(id openStore) {
        
        SODataRequestParamSingleDefault *myRequest = [[SODataRequestParamSingleDefault alloc] initWithMode:mode resourcePath:resourcePath];
        
        [self.onlineStore scheduleRequest:myRequest completionHandler:^(id<SODataEntitySet> entities, id<SODataRequestExecution> requestExecution, NSError *error) {
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
    }];

}



@end
