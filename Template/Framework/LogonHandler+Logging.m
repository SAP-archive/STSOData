//
//  LogonHandler+Logging.m
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 8/12/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "LogonHandler+Logging.h"
#import "HttpConversationManager.h"
#import "SupportabilityUploader.h"
#import "SAPSupportabilityFacade.h"


@implementation LogonHandler (Logging)


- (void) setupLogging
{
    /*
     Initialize the logging framework.  Set log level for different identifiers, and the log destination (default FILESYSTEM)
     Add SAPClientLogger.h, and SAPSupportabilityFacade.h to your *.pch file, so that the logger macros are available throughout your app.
     */
    self.logManager = [[SAPSupportabilityFacade sharedManager] getClientLogManager];
    [self.logManager setLogLevel:InfoClientLogLevel forIdentifier:LOG_ODATAREQUEST];
    [self.logManager setLogLevel:InfoClientLogLevel forIdentifier:LOG_ONLINESTORE];
    [self.logManager setLogLevel:InfoClientLogLevel forIdentifier:LOG_OFFLINESTORE];
    [self.logManager setLogLevel:InfoClientLogLevel forIdentifier:LOG_LOGUPLOAD];
    [self.logManager setLogDestination:(CONSOLE | FILESYSTEM)];
}


- (void) uploadLogs {
        
    /*
     Log upload endpoint is constant for all applications on a host:port
     */
    NSString *logUploadURL = [NSString stringWithFormat:@"%@://%@:%i/clientlogs", self.data.isHttps ? @"https" : @"http", self.data.serverHost, self.data.serverPort];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:logUploadURL]];
    
    [request setValue:self.data.applicationConnectionId forHTTPHeaderField:@"X-SMP-APPCID"];
    
    SupportabilityUploader *uploader = [[SupportabilityUploader alloc] initWithHttpConversationManager:self.httpConvManager urlRequest:request];
    
    NSArray *logData0 = [self.logManager getLogEntries:AllClientLogLevel];
    NSLog(@"Log Data \n%@", [logData0 description]);
    
    NSData *rawLogData = [self.logManager getRawLogData];
    NSString *stringFromData = [[NSString alloc]initWithData:rawLogData encoding:NSUTF8StringEncoding];
    NSLog(@"Raw Log Data\n%@", [stringFromData description]); // just to eliminate 'unused' warning in this sample
    
    
    [self.logManager uploadClientLogs:uploader completion:^(NSError *error) {
        
        if (!error) {
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Upload succeeded" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView show];
            });
        } else {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Upload failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView show];
            });
        }
    }];
    
    
}
@end