//
//  LogonHandler+Usage.m
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 7/22/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "LogonHandler+Usage.h"
#import "Usage.h"

@implementation LogonHandler (Usage)

-(void)startUsageCollection
{
    [Usage initUsageWithURL:[self.baseURL clientUsageURL] httpConversationManager:self.httpConvManager];
}

@end
