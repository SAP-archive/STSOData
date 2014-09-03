//
//  OfflineStore.h
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 8/11/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "SODataOfflineStore.h"
#import "SODataStore.h"
#import "SODataStoreSync.h"
#import "SODataStoreAsync.h"
#import "ODataStore.h"

@interface OfflineStore : SODataOfflineStore <ODataStore, SODataStore, SODataStoreSync, SODataStoreAsync>


@end
