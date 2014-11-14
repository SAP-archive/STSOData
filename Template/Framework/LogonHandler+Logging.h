//
//  LogonHandler+Logging.h
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 8/12/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "LogonHandler.h"
#import "SAPClientLogManager.h"

@interface LogonHandler (Logging)


- (void) setupLogging;
- (void) uploadLogs;

@end
