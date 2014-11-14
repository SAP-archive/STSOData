//
//  NSURL+MobilePlatform.m
//  Template
//
//  Created by Stadelman, Stan on 11/14/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "NSURL+MobilePlatform.h"
#import <objc/runtime.h> 

static const void *baseURLKey = &baseURLKey;
static const void *appIdKey = &appIdKey;

@implementation NSURL (MobilePlatform)


-(NSURL *)initWithHost:(NSString *)host port:(int)port protocol:(BOOL)isSecure appId:(NSString *)appId
{
    NSString *baseURLString = [NSString stringWithFormat:@"%@://%@:%i", isSecure ? @"https" : @"http", host, port];
    
    return [self initWithBaseURLString:baseURLString appId:appId];
}

-(NSURL *)initWithBaseURLString:(NSString *)urlString appId:(NSString *)appId
{
    NSAssert([appId length] > 0, @"appId should not be null");
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    url.appId = appId;
    
    return url;
}

-(NSURL *)applicationURL
{
    NSAssert(self.appId != nil, @"NSURL must have been initialized with baseURL and appId to use this method");
    
    return [self URLByAppendingPathComponent:self.appId isDirectory:YES];
}

-(NSURL *)clientLogsURL
{
    NSAssert(self.appId != nil, @"NSURL must have been initialized with an appId to use this method");
    
    return [self URLByAppendingPathComponent:@"clientlogs"];
}

-(NSURL *)btxURL
{
    NSAssert(self.appId != nil, @"NSURL must have been initialized with an appId to use this method");
    
    return [self URLByAppendingPathComponent:@"btx"];
}

-(NSURL *)clientUsageURL
{
    return [self URLByAppendingPathComponent:@"clientusage"];
}

/*
 Association code
 */

-(void)setAppId:(NSString *)appId
{
    objc_setAssociatedObject(self, appIdKey, appId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)appId
{
    return objc_getAssociatedObject(self, appIdKey);
}

@end
