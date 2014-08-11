

#import "LogonHandler.h"


@interface LogonHandler ()

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
        
        self.logonUIViewManager = [[MAFLogonUIViewManager alloc] init];
        
        // save reference to LogonManager for code readability
        self.logonManager = self.logonUIViewManager.logonManager;

        [self.logonManager setApplicationId:@"flight"];
        self.logonUIViewManager.parentViewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
        
        self.httpConvManager = [[HttpConversationManager alloc] init];
        
        // set up the logon delegate
        [self.logonManager setLogonDelegate:self];

    }
    return self;
}

#pragma mark - MAFLogonNGDelegate implementation

-(void) logonFinishedWithError:(NSError*)anError {
    
    if (!anError) {

        NSLog(@"logonFinishedSuccessfully");
        
        NSError *err;
        self.data = [self.logonManager registrationDataWithError:&err];
        if (err) {
            NSLog(@"%@ %s", err, __PRETTY_FUNCTION__);
        }
        
        [[self.logonManager logonConfigurator] configureManager:self.httpConvManager];
        
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

@end