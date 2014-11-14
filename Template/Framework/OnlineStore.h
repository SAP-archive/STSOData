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
#import "ODataStore.h"

@interface OnlineStore : SODataOnlineStore <ODataStore, SODataStore, SODataStoreSync, SODataStoreAsync>


@end
