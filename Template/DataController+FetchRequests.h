//
//  DataController+FetchRequests.h
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 8/11/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "DataController.h"

@interface DataController (FetchRequests)

-(void)fetchBookingsWithExpand;

-(void)fetchTravelAgencies;

@end
