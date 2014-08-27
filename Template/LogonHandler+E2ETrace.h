//
//  LogonHandler+E2ETrace.h
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 7/18/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "LogonHandler.h"
#import "SAPE2ETraceManager.h"

@class SupportabilityUploader;

@interface LogonHandler (E2ETrace)

-(SupportabilityUploader *)configuredUploader;
-(void)startTrace;
-(void)endAndUploadTrace;

@end
