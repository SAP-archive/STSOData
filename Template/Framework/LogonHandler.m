

#import "LogonHandler.h"
#import "LogonHandler+Logging.h"
#import "LogonHandler+Usage.h"
#import "MAFUIStyleParser.h"
#import "DataController.h"
#import "NSURL+MobilePlatform.h"


@interface LogonHandler ()

@property (nonatomic, strong) NSArray *definingRequests;

@end


@implementation LogonHandler

+(instancetype)shared {
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _shared= [[LogonHandler alloc] init];
        
    });
    return _shared;
}

-(id) init {

    if(self == [super init]){
        
        [MAFUIStyleParser loadSAPDefaultStyle];
        self.logonUIViewManager = [[MAFLogonUIViewManager alloc] init];
        self.logonUIViewManager.parentViewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
        
        // save reference to LogonManager for code readability
        self.logonManager = self.logonUIViewManager.logonManager;
        

        // set up the logon delegate
        [self.logonManager setLogonDelegate:self];
        
        self.collectUsageData = YES;

    }
    return self;
}

#pragma mark - MAFLogonNGDelegate implementation

-(void) logonFinishedWithError:(NSError*)anError {
    
    NSLog(@"%@ %s", anError, __PRETTY_FUNCTION__);
    
    if (!anError) {
        
        NSLog(@"cookies on Logon success = %@", [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies);
        
        NSError *err;
        self.data = [self.logonManager registrationDataWithError:&err];
        if (err) {
            NSLog(@"%@ %s", err, __PRETTY_FUNCTION__); 
        }
        
        /*
         Set a baseURL to be used throughout the application, constructed from the MAFLogonRegistrationContext
         */
        self.baseURL = [[NSURL alloc] initWithHost:self.data.serverHost port:self.data.serverPort protocol:self.data.isHttps appId:self.data.applicationId];
        
        /*
        Configure the httpConversationManager--in this application, this httpConvManager will be
        used throughout all sdk components:  Usage, Logging, Data/ODataStore, etc.  
        
        The configurations are dependent on the information in the MAFLogonRegistrationContext,
        so you should only attempt to configure the httpConvManager after 'logonFinished' is called
        without errors.
        */
        self.httpConvManager = [[HttpConversationManager alloc] init];
        
        [[self.logonManager logonConfigurator] configureManager:self.httpConvManager];
        
        [[DataController shared] loadWorkingMode]; 
        
        /*
        Setup the supporting features
        */
        if (self.collectUsageData)[self startUsageCollection];
        
        [self setupLogging];
        
        
        
        /*
        Notify the app that logon (and initialization) operations are complete
        */
        [[NSNotificationCenter defaultCenter] postNotificationName:kLogonFinished object:nil];
        
        
    } else {
    
        NSLog(@"logonFinishedWithError:%@", anError);
    }
    
}

-(void) lockSecureStoreFinishedWithError:(NSError*)anError {
    NSLog(@"lockSecureStoreFinishedWithError:%@", anError);
}

-(void) updateApplicationSettingsFinishedWithError:(NSError*)anError {
    NSLog(@"updateApplicationSettingsFinishedWithError:%@", anError);
}

-(void) uploadTraceFinishedWithError:(NSError *)anError {
    NSLog(@"uploadTraceFinishedWithError:%@", anError);
}

-(void) changeBackendPasswordFinishedWithError:(NSError*)anError {
    NSLog(@"Password change with error:%@", anError);
}

-(void) deleteUserFinishedWithError:(NSError*)anError {
    if (!anError) {
        
        //Show login
        [self.logonUIViewManager.logonManager logon];
    } else {
        NSLog(@"deleteUserFinishedWithError:%@", anError);
    }
}

-(void) changeSecureStorePasswordFinishedWithError:(NSError*)anError {
    NSLog(@"changeSecureStorePasswordFinishedWithError:%@", anError);
}

-(void) registrationInfoFinishedWithError:(NSError*)anError {
    NSLog(@"registrationInfoFinishedWithError:%@", anError);
}

-(void) startDemoMode {
    NSLog(@"startDemoMode");
}

-(void) refreshCertificateFinishedWithError:(NSError*)anError
{
    
}

- (void)setupDefiningRequests:(SODataOfflineStoreOptions *)options
{
    NSArray *definingRequests = [DataController shared].definingRequests;
    [definingRequests enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSString *identifier = [NSString stringWithFormat:@"req%i", [@(idx) intValue] + 1];
        options.definingRequests[identifier] = obj;
    }];
}


- (SODataOfflineStoreOptions *)options
{
    SODataOfflineStoreOptions *options = [[SODataOfflineStoreOptions alloc] init];
    
    options.enableHttps = self.data.isHttps;
    options.host = self.data.serverHost;
    options.port = self.data.serverPort;
    options.serviceRoot = [NSString stringWithFormat:@"/%@", self.data.applicationId];
    [self setupDefiningRequests:options];
    options.enableRepeatableRequests = NO;
    
    options.conversationManager = self.httpConvManager;
    
    return options;
}

@end