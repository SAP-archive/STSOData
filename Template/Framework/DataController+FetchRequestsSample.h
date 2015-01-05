//
//  DataController+FetchRequestsSample.h
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 8/11/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "DataController.h"

@interface DataController (FetchRequestsSample)

-(void)fetchBookingsWithExpandSample;

-(void)fetchTravelAgenciesSample;

-(void)fetchTravelAgenciesSampleWithCompletion:(void(^)(NSArray *entities))completion;

-(void)fetchAvailableFlightsSampleWithParameters:(NSDictionary *)parameters WithCompletion:(void(^)(NSArray *entities))completion;


@end
