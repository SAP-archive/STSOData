//
//  OnlineStore.h
//  Template
//
//  Created by Stadelman, Stan on 8/4/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "SODataOnlineStore.h"
#import "SODataStore.h"
#import "SODataStoreSync.h"
#import "SODataStoreAsync.h"
#import "SODataRequestDelegate.h"

@interface OnlineStore : SODataOnlineStore <SODataStore, SODataStoreSync, SODataStoreAsync, SODataRequestDelegate>

- (void) openStoreWithCompletion:(void(^)(id openStore))completion;

- (void) scheduleRequest:(id<SODataRequestParam>)request completionHandler:(void(^)(id<SODataEntitySet>entities, id<SODataRequestExecution>requestExecution, NSError *error))completion;

@end
