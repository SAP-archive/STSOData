//
//  LogonHandler+E2ETrace.m
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 7/18/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "LogonHandler+E2ETrace.h"
#import "SupportabilityUploader.h"
#import "HTTPConversationManager.h"

/*
 Required imports for E2ETrace
 */
#import "SAPSupportabilityFacade.h"
#import "SAPE2ETraceManager.h"
#import "SAPE2ETraceTransaction.h"
#import "SAPE2ETrace.h"
#import "SAPE2ETraceRequest.h"

@implementation LogonHandler (E2ETrace)

-(SupportabilityUploader *)configuredUploader {
    /*
    BTX upload endpoint is constant for all applications on a host:port
    */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self.baseURL btxURL]];
    
    /*
    Set the HttpConversationManager and request to the SupportabilityUploader
    */
SupportabilityUploader *uploader = [[SupportabilityUploader alloc] initWithHttpConversationManager:self.httpConvManager
                                                                                        urlRequest:request];
    return uploader;
}

-(void)startTrace
{
    NSError *error;
    
    MAFLogonRegistrationData *data = [self.logonManager registrationDataWithError:&error];
    
    NSString *traceName = data.applicationConnectionId ? data.applicationConnectionId : @"New Registration";

    id<SAPE2ETraceManager> e2eTraceManager = [[SAPSupportabilityFacade sharedManager] getE2ETraceManager];
    id<SAPE2ETraceTransaction> e2eTraceTransaction = [e2eTraceManager startTransaction:traceName error:&error];

    [e2eTraceTransaction startStep:&error];
    
    /*
     Start an E2ETrace for the GET transaction
     
     1.  Create the TraceManager.  This is the central reference for the E2ETrace procedure
     2.  Create the Transaction.  This effects the creation of the BTX transaction, for the xml output, e.g.:
     
     <BusinessTransaction name="MyBusinessTransaction" time="26.03.2014 10:23:45.980 UTC" id="4635000000311ED3AD9A16BDE9C208C4">
     
     3.  As requests are executed through the HTTPConversationManager,steps are automatically added to a particular trace.
         The Developer does NOT need to instrument the specifics of the request.  Just create the transaction, and start and stop on either side 
         of a request.
         
     4.  The resultant btx record will resemble the following:
     
     <?xml version="1.0" encoding="utf-8"?><BusinessTransaction name="8f7b9a0d-8330-46fe-87fd-ce5d79533702" time="22.07.2014 16:44:49.279 GMT-07:00" id="F5EAA05E1A584EE786F608706B9981F9" clientHost="DEMO-Client" xmlVersion="7.1.10" clientType="Mobile">
     <ClientInformation>ClientSDK:SMPClientSDK iOS</ClientInformation>
     <TransactionStep name="Step-0" id="F5EAA05E1A584EE786F608706B9981F9-0" time="22.07.2014 16:44:49.280 GMT-07:00" traceflags="0D9F" ucpu="330" kcpu="168" reqType="http">
     <Message dsrGuid="77291E8A4FF04E159592FBD3A5911019" id="0" name="" protocol="http">
     <duration>446</duration>
     <lastByteReceived>22.07.2014 16:44:52.648 GMT-07:00</lastByteReceived>
     <responseHeader><![CDATA[Set-Cookie:X-SMP-SESSIDSSO=A6F33F3C924879E86B1C9BD5A5FA2928; Path=/; HttpOnly, X-SMP-SESSID=02EE488D12A51C1B03F37E99BADBFB93AB4F169A0C70A09A15CCC862121B1260; Path=/; HttpOnly
     Date:Tue, 22 Jul 2014 23:44:52 GMT
     Content-Length:0
     Server:SAP]]></responseHeader>
     <lastByteSent>22.07.2014 16:44:52.202 GMT-07:00</lastByteSent>
     <firstByteReceived>22.07.2014 16:44:52.648 GMT-07:00</firstByteReceived>
     <rcvd>0</rcvd>
     <sent>2346</sent>
     <returnCode>201</returnCode>
     <requestLine><![CDATA[POST http://10.76.174.180:8080/clientlogs HTTP/1.1]]></requestLine>
     <x-timestamp>22.07.2014 16:44:52.201 GMT-07:00</x-timestamp>
     <firstByteSent>22.07.2014 16:44:52.202 GMT-07:00</firstByteSent>
     <requestHeader><![CDATA[POST http://10.76.174.180:8080/clientlogs HTTP/1.1
     X-CorrelationID:F5EAA05E1A584EE786F608706B9981F9-1-0
     Content-Type:multipart/form-data
     X-SMP-APPCID:8f7b9a0d-8330-46fe-87fd-ce5d79533702
     SAP-PASSPORT:2A54482A0301309F0D5341505F4532455F54415F506C7567496E20202020202020202020202020202000005341505F4532455F54415F5573657220202020202020202020202020202020205341505F4532455F54415F526571756573742020202020202020202020202020202020202020202000055341505F4532455F54415F506C7567496E20202020202020202020202020202037373239314538413446463034453135393539324642443341353931313031392020200007F5EAA05E1A584EE786F608706B9981F90000000000000000000000000000000000000001000200E22A54482A0100270000020003000200010400085800020002040008300002000302000B000000002A54482A010023010001000100020001030017000000000000000000000000000000002A54482A]]></requestHeader>
     </Message>
     <Message dsrGuid="7B800C93761345019C93594F485353E3" id="1" name="" protocol="http">
     <duration>0</duration>
     <rcvd>0</rcvd>
     <sent>0</sent>
     <returnCode>(OPEN)</returnCode>
     <x-timestamp>22.07.2014 16:45:01.938 GMT-07:00</x-timestamp>
     <requestHeader><![CDATA[<null>
     X-CorrelationID:F5EAA05E1A584EE786F608706B9981F9-1-1
     SAP-PASSPORT:2A54482A0301309F0D5341505F4532455F54415F506C7567496E20202020202020202020202020202000005341505F4532455F54415F5573657220202020202020202020202020202020205341505F4532455F54415F526571756573742020202020202020202020202020202020202020202000055341505F4532455F54415F506C7567496E20202020202020202020202020202037423830304339333736313334353031394339333539344634383533353345332020200007F5EAA05E1A584EE786F608706B9981F90000000000000000000000000000000000000001000200E22A54482A0100270000020003000200010400085800020002040008300002000302000B000000002A54482A010023010001000100020001030017000000000000000000000000000000002A54482A]]></requestHeader>
     </Message>
     <Message dsrGuid="3C1390C330E24BA28908B22074A99FC0" id="2" name="" protocol="http">
     <duration>0</duration>
     <rcvd>0</rcvd>
     <sent>0</sent>
     <returnCode>(OPEN)</returnCode>
     <x-timestamp>22.07.2014 16:45:05.126 GMT-07:00</x-timestamp>
     <requestHeader><![CDATA[<null>
     X-CorrelationID:F5EAA05E1A584EE786F608706B9981F9-1-2
     SAP-PASSPORT:2A54482A0301309F0D5341505F4532455F54415F506C7567496E20202020202020202020202020202000005341505F4532455F54415F5573657220202020202020202020202020202020205341505F4532455F54415F526571756573742020202020202020202020202020202020202020202000055341505F4532455F54415F506C7567496E20202020202020202020202020202033433133393043333330453234424132383930384232323037344139394643302020200007F5EAA05E1A584EE786F608706B9981F90000000000000000000000000000000000000001000200E22A54482A0100270000020003000200010400085800020002040008300002000302000B000000002A54482A010023010001000100020001030017000000000000000000000000000000002A54482A]]></requestHeader>
     </Message>
     </TransactionStep>
     </BusinessTransaction>
     
     
     5.  Ensure that the TraceRequest is finished at some point
     6.  Ensure that the Trace is stopped at some point
     
     */

}

-(void)endAndUploadTrace
{

    NSError *error;
    id<SAPE2ETraceManager> e2eTraceManager = [[SAPSupportabilityFacade sharedManager] getE2ETraceManager];

    [[e2eTraceManager getActiveTransaction] endStep:&error];

    if (error) {
        NSLog(@"end trace error = %@", error);
    } else {
        
        /*
        Commit the end of the transaction
        */
        [[e2eTraceManager getActiveTransaction] endTransaction:&error];
            
            if (error) {
                NSLog(@"end trace error = %@", error);
            } else {
    error = nil;
    NSString* btx = [e2eTraceManager getBTX:&error];
    NSLog(@"btx = \n%@", btx);

[e2eTraceManager uploadBTX:[self configuredUploader] completion:^(NSError* error) {
    if (error == nil) {
        NSLog(@"upload succeeded");
    }
    else {
        NSLog(@"upload failed: %@", [error description]);
    }
}];
            }
    }
    
}



@end
