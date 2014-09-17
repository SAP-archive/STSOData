//
//  FlightSample.h
//  Template
//
//  Created by Stadelman, Stan on 9/16/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "STSODataEntity.h"

@class FlightDetailsSample;

@interface FlightSample : STSODataEntity

@property (nonatomic, strong) NSString *carrid;
@property (nonatomic, strong) NSString *connid;
@property (nonatomic, strong) NSDate *fldate;
@property (nonatomic, strong) FlightDetailsSample *flightDetails;
@property (nonatomic, strong) NSNumber *PRICE;
@property (nonatomic, strong) NSString *CURRENCY;
@property (nonatomic, strong) NSString *PLANETYPE;
@property (nonatomic, strong) NSNumber *SEATSMAX;
@property (nonatomic, strong) NSNumber *SEATSOCC;
@property (nonatomic, strong) NSNumber *PAYMENTSUM;
@property (nonatomic, strong) NSNumber *SEATSMAX_B;
@property (nonatomic, strong) NSNumber *SEATSOCC_B;
@property (nonatomic, strong) NSNumber *SEATSMAX_F;
@property (nonatomic, strong) NSNumber *SEATSOCC_F;
@property (nonatomic, strong) NSString *flightbooking;
@property (nonatomic, strong) NSString *flightBookings;
@property (nonatomic, strong) NSString *FlightCarrier;

@end
