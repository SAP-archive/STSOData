//
//  LogonHandler
// 
//
//  
//  Copyright (c) 2013 RIG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAFLogonNGPublicAPI.h"
#import "MAFLogonUIViewManager.h"
#import "MAFLogonNGDelegate.h"
#import "HttpConversationManager.h"
#import "MAFLogonRegistrationData.h"
#import "SODataOfflineStoreOptions.h"
#import "NSURL+MobilePlatform.h"

#import "SAPClientLogManager.h"

@interface LogonHandler : NSObject <MAFLogonNGDelegate>

@property (strong, nonatomic) MAFLogonUIViewManager *logonUIViewManager;
@property (strong, nonatomic) NSObject<MAFLogonNGPublicAPI> *logonManager;
@property (strong, nonatomic) HttpConversationManager* httpConvManager;

@property (strong, nonatomic) MAFLogonRegistrationData *data;

@property (strong, nonatomic) NSURL *baseURL;

- (SODataOfflineStoreOptions *)options;

@property (strong, nonatomic) id<SAPClientLogManager>logManager;

@property (nonatomic, assign) BOOL collectUsageData;

+(instancetype)shared;



@end
