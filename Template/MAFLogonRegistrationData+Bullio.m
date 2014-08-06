//
//  MAFLogonRegistrationData+Bullio.m
//  Template
//
//  Created by Stadelman, Stan on 8/5/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "MAFLogonRegistrationData+Bullio.h"

@implementation MAFLogonRegistrationData (Bullio)

- (NSURL *)baseURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@:%i/%@/", self.isHttps ? @"https" : @"http", self.serverHost, self.serverPort, self.applicationId]];
}

@end
