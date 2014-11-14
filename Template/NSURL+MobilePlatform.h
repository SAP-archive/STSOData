//
//  NSURL+MobilePlatform.h
//  Template
//
//  Created by Stadelman, Stan on 11/14/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (MobilePlatform)

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSString *appId;

/* 
 helper constructor for handling the output of MAFLogonRegistrationContext
 */
-(NSURL *)initWithHost:(NSString *)host port:(int)port protocol:(BOOL)isSecure appId:(NSString *)appId;

/*
 base constructor... could be changed slightly, depending on the interface of how configurations are acquired
 */
-(NSURL *)initWithBaseURLString:(NSString *)urlString appId:(NSString *)appId;

/*  
 protocol://host:port/appId/
 */
-(NSURL *)applicationURL;

/*
 protocol://host:port/clientlogs
 */
-(NSURL *)clientLogsURL;

/*
 protocol://host:port/btx
 */
-(NSURL *)btxURL;

/*
 protocol://host:port/clientusage
 */
-(NSURL *)clientUsageURL;

@end
