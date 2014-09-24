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

@interface DataController (ConfigureModelsSample)

+(void)configureBookingSampleModel:(BookingSample *)model withDictionary:(NSDictionary *)dictionary;

+(void)configureFlightSampleModel:(FlightSample *)model withDictionary:(NSDictionary *)dictionary;

+(void)configureFlightDetailsSampleModel:(FlightDetailsSample *)model withDictionary:(NSDictionary *)dictionary;

@end
