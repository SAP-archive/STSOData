//
//  NSURL+MobilePlatform.m
//  Template
//
//  Created by Stadelman, Stan on 11/14/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "NSURL+MobilePlatform.h"

@implementation NSURL (MobilePlatform)

@dynamic baseURL;
@dynamic appId;

-(NSURL *)initWithHost:(NSString *)host port:(int)port protocol:(BOOL)isSecure appId:(NSString *)appId
{
    NSString *baseURLString = [NSString stringWithFormat:@"%@://%@:%i", isSecure ? @"https" : @"http", host, port];
    
    return [self initWithBaseURLString:baseURLString appId:appId];
}

-(NSURL *)initWithBaseURLString:(NSString *)urlString appId:(NSString *)appId
{
    NSAssert([appId length] > 0, @"appId should not be null");
    
    self.appId = appId;
    
    self.baseURL = [[NSURL alloc] initWithString:urlString];
    
    return [self.appId length] > 0 ? [self.baseURL URLByAppendingPathComponent:appId] : self.baseURL;
}

-(NSURL *)applicationURL
{
    NSAssert(self.baseURL != nil, @"NSURL must have been initialized with baseURL and appId to use this method");
    NSAssert(self.appId != nil, @"NSURL must have been initialized with baseURL and appId to use this method");
    
    return [self.baseURL URLByAppendingPathComponent:self.appId isDirectory:YES];
}

-(NSURL *)clientLogsURL
{
    NSAssert(self.baseURL != nil, @"NSURL must have been initialized with baseURL to use this method");
    NSAssert(self.appId != nil, @"NSURL must have been initialized with an appId to use this method");
    
    return [self.baseURL URLByAppendingPathComponent:@"clientlogs"];
}

-(NSURL *)btxURL
{
    NSAssert(self.baseURL != nil, @"NSURL must have been initialized with baseURL to use this method");
    NSAssert(self.appId != nil, @"NSURL must have been initialized with an appId to use this method");
    
    return [self.baseURL URLByAppendingPathComponent:@"btx"];
}

-(NSURL *)clientUsageURL
{
    NSAssert(self.baseURL != nil, @"NSURL must have been initialized with baseURL to use this method");
    NSAssert(self.appId != nil, @"NSURL must have been initialized with an appId to use this method");
    
    return [self.baseURL URLByAppendingPathComponent:@"clientusage"];
}

@end
