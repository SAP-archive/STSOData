//
//  AppDelegate.m
//  Template
//
//  Created by Stadelman, Stan on 8/4/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "AppDelegate.h"
#import "LogonHandler.h"
#import "DataController.h"
#import "SODataOfflineStore.h"

#define kDefiningRequest1 @"TravelagencyCollection"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
/*
    If application will support offline OData, you must initialize SODataOfflineStore here in
    -didFinishLaunchingWithOptions.  Also, call 'finish' method in -applicationWillTerminate:.
*/
    [SODataOfflineStore GlobalInit];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
/*
    Specify whether the DataController should operate in 'Mixed' (Online + Offline) mode, or
    specifically 'Online' or 'Offline' mode.  Defaults to 'Mixed'.
    
    'Offline' mode uses the local database, that is synchronized via Mobilink.  All requests for 
    OData resources, that are included in the scope of the "defining requests" are read & written 
    to the local database.
    
    Requests for OData resources that are outside the scope of the defining requests, when in 
    Offline mode, or all (*) requests when in Online mode, are sent over the network.
    
    See additional explanation here:  http://sstadelman.bull.io/blog/Should-I-use-Online-or-Offline-store/ 
*/
//    [DataController shared].workingMode = WorkingModeOnline;

    [DataController shared].definingRequests = @[kDefiningRequest1];
    
/*
    Set applicationId for the application. This should match the applicationId in the SMP Admin 
    console.  
*/
    [[LogonHandler shared].logonManager setApplicationId:@"sapSTSODataFlight2"];
//    [[LogonHandler shared].logonManager setApplicationId:@"sap/opu/odata/IWFND/RMTSAMPLEFLIGHT"];

/*
    Application is designed to collect information on the device, OS, and application, as well as
    developer-specified analytic information.  Requires HANA Cloud Platform, Mobile Services.

    Defaults to YES.  Set to NO, to disable usage collection.
*/
//    [LogonHandler shared].collectUsageData = NO;

/*
    Always invoke logonManager logon at application launch.  This unlocks the DataVault, executes 
    registration if necessary, obtains credentials and connection settings, etc.  When logon 
    completes, the kLogonFinished notification is emitted by LogonHandler.
*/

    [[LogonHandler shared].logonManager logon];
    
    }

- (void)applicationWillTerminate:(UIApplication *)application
{
/*
    If application is supporting offline OData, you must break-down the store, here in 
    -applicationWillTerminate:.
*/
    [SODataOfflineStore GlobalFini];
}

@end
