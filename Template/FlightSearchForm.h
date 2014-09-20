//
//  FlightSearchForm.h
//  Template
//
//  Created by Stadelman, Stan on 9/19/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlightSample;

@interface FlightSearchForm : UITableViewController

@property (nonatomic, strong) NSDate *departureDate;
@property (nonatomic, strong) NSDate *returnDate;

@property (nonatomic, strong) NSString *departureAirportCity;
@property (nonatomic, strong) NSString *returnAirportCity;

@property (nonatomic, strong) NSNumber *numPassengers;
@property (nonatomic, strong) NSString *classPreference;

@property (nonatomic, strong) NSNumber *minPrice;
@property (nonatomic, strong) NSNumber *maxPrice;

@property (nonatomic, strong) FlightSample *selectedDepartureFlight;
@property (nonatomic, strong) FlightSample *selectedReturnFlight;

@end
