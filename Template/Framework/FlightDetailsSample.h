//
//  FlightDetailsSample.h
//  Template
//
//  Created by Stadelman, Stan on 9/16/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

@class SODataDuration;

@interface FlightDetailsSample : NSObject

@property (nonatomic, strong) NSString *countryFrom;
@property (nonatomic, strong) NSString *cityFrom;
@property (nonatomic, strong) NSString *airportFrom;
@property (nonatomic, strong) NSString *countryTo;
@property (nonatomic, strong) NSString *airportTo;
@property (nonatomic, assign) NSNumber *flightTime;
@property (nonatomic, strong) SODataDuration *departureTime;
@property (nonatomic, strong) SODataDuration *arrivalTime;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *distanceUnit;
@property (nonatomic, strong) NSNumber *flightType;
@property (nonatomic, strong) NSNumber *period;

@end
