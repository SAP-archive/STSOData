//
//  DataController.h
//  Usage Prototype
//
//  Created by Stadelman, Stan on 3/7/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODataStore.h"
#import "SODataStore.h"
#import "SODataStoreSync.h"
#import "SODataStoreAsync.h"
#import "Framework-Constants.h"

@interface DataController : NSObject


@property (nonatomic, assign) WorkingModes workingMode;

@property (nonatomic, strong) id<ODataStore, SODataStore, SODataStoreAsync, SODataStoreSync>store;

@property (nonatomic, strong) id<ODataStore, SODataStore, SODataStoreAsync, SODataStoreSync>localStore;

@property (nonatomic, strong) id<ODataStore, SODataStore, SODataStoreAsync, SODataStoreSync>networkStore;

@property (nonatomic, strong) NSArray *definingRequests;

+ (instancetype)shared;

- (void) loadWorkingMode;

- (void) switchWorkingMode:(WorkingModes)workingMode;

- (void) scheduleRequestForResource:(NSString *)resourcePath withMode:(SODataRequestModes)mode withEntity:(id<SODataEntity>)entity withCompletion:(void(^)(NSArray *entities, id<SODataRequestExecution>requestExecution, NSError *error))completion;

/*  MODEL PROPERTIES HERE FOR THE SAMPLE ONLY--IMPLEMENT MODEL PROPERTIES IN YOUR OWN FILE  */

@property (nonatomic, strong) NSArray *bookingsWithExpandSample;

@property (nonatomic, strong) NSArray *travelAgenciesSample;

/*  MODEL PROPERTIES SHOULD BE IN MODEL FILE  */



@end
