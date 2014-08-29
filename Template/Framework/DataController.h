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

@interface DataController : NSObject

/* REALLY BAD PRACTICE (WorkingModes)
 * Since the ODataOfflineStore can function in Online Mode also,
 * there is really no case in which it would make sense to write
 * an app that toggles between OnlineStore and OfflineStore.
 * BUT, for this example, use WorkingModes for a terrible hacky workaround:
 */
@property (nonatomic, assign) WorkingModes workingMode;

@property (nonatomic, strong) id<ODataStore, SODataStore, SODataStoreAsync, SODataStoreSync>store;

/*  ONLY MAKE CHANGES BELOW HERE  */

@property (nonatomic, strong) NSArray *bookingsWithExpand;

@property (nonatomic, strong) NSArray *travelAgencies;

/*  ONLY MAKE CHANGES ABOVE HERE  */

+ (instancetype)shared;

- (void) scheduleRequestForResource:(NSString *)resourcePath withMode:(SODataRequestModes)mode withEntity:(id<SODataEntity>)entity withCompletion:(void(^)(NSArray *entities, id<SODataRequestExecution>requestExecution, NSError *error))completion;





@end
