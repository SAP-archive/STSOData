//
//  DataController+ConfigureModelsSample.h
//  Template
//
//  Created by Stadelman, Stan on 9/23/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "DataController.h"

@class BookingSample;
@class FlightSample;
@class FlightDetailsSample;
@class TravelAgencySample;


@interface DataController (ConfigureModelsSample)

+(void)configureBookingSampleModel:(BookingSample *)model withDictionary:(NSDictionary *)dictionary;

+(void)configureFlightSampleModel:(FlightSample *)model withDictionary:(NSDictionary *)dictionary;

+(void)configureFlightDetailsSampleModel:(FlightDetailsSample *)model withDictionary:(NSDictionary *)dictionary;

/*
 The TravelAgencySample object is CREATE/UPDATE/DELETE-enabled, so it is convenient to store the underlying <SODataEntity> entity.
 */
+(void)configureTravelAgencySampleModel:(TravelAgencySample *)model withEntity:(id<SODataEntity>)entity;

@end
