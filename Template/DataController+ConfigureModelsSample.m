//
//  DataController+ConfigureModelsSample.m
//  Template
//
//  Created by Stadelman, Stan on 9/23/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//


#import "DataController+ConfigureModelsSample.h"

#import "BookingSample.h"

#import "FlightSample.h"

#import "FlightDetailsSample.h"

#import "SODataProperty.h"

@implementation DataController (ConfigureModelsSample)


+(void)configureBookingSampleModel:(BookingSample *)model withDictionary:(NSDictionary *)dictionary
{
    model.carrid = (NSString *)[(id<SODataProperty>)dictionary[@"carrid"] value];
    model.connid = (NSString *)[(id<SODataProperty>)dictionary[@"connid"] value];
    model.fldate = (NSDate *)[(id<SODataProperty>)dictionary[@"fldate"] value];
    model.bookid = (NSString *)[(id<SODataProperty>)dictionary[@"bookid"] value];
    model.CUSTOMID = (NSString *)[(id<SODataProperty>)dictionary[@"CUSTOMID"] value];
    model.CUSTTYPE = (NSString *)[(id<SODataProperty>)dictionary[@"CUSTTYPE"] value];
    model.SMOKER = (NSString *)[(id<SODataProperty>)dictionary[@"SMOKER"] value];
    model.WUNIT = (NSString *)[(id<SODataProperty>)dictionary[@"WUNIT"] value];
    model.LUGGWEIGHT = (NSNumber *)[(id<SODataProperty>)dictionary[@"LUGGWEIGHT"] value];
    model.INVOICE = (NSString *)[(id<SODataProperty>)dictionary[@"INVOICE"] value];
    model.CLASS = (NSString *)[(id<SODataProperty>)dictionary[@"CLASS"] value];
    model.FORCURAM = (NSNumber *)[(id<SODataProperty>)dictionary[@"FORCURAM"] value];
    model.FORCURKEY = (NSString *)[(id<SODataProperty>)dictionary[@"FORCURKEY"] value];
    model.LOCCURAM = (NSNumber *)[(id<SODataProperty>)dictionary[@"LOCCURAM"] value];
    model.LOCCURKEY = (NSString *)[(id<SODataProperty>)dictionary[@"LOCCURKEY"] value];
    model.ORDER_DATE = (NSDate *)[(id<SODataProperty>)dictionary[@"ORDER_DATE"] value];
    model.COUNTER = (NSString *)[(id<SODataProperty>)dictionary[@"COUNTER"] value];
    model.AGENCYNUM = (NSString *)[(id<SODataProperty>)dictionary[@"AGENCYNUM"] value];
    model.CANCELLED = (NSString *)[(id<SODataProperty>)dictionary[@"CANCELLED"] value];
    model.RESERVED = (NSString *)[(id<SODataProperty>)dictionary[@"RESERVED"] value];
    model.PASSNAME = (NSString *)[(id<SODataProperty>)dictionary[@"PASSNAME"] value];
    model.PASSFORM = (NSString *)[(id<SODataProperty>)dictionary[@"PASSFORM"] value];
    model.PASSBIRTH = (NSDate *)[(id<SODataProperty>)dictionary[@"PASSBIRTH"] value];
    
}

+(void)configureFlightSampleModel:(FlightSample *)model withDictionary:(NSDictionary *)dictionary
{
    model.carrid = (NSString *)[(id<SODataProperty>)dictionary[@"carrid"] value];
    model.connid = (NSString *)[(id<SODataProperty>)dictionary[@"connid"] value];
    model.fldate = (NSDate *)[(id<SODataProperty>)dictionary[@"fldate"] value];

    FlightDetailsSample *detailsModel = [FlightDetailsSample new];
    NSDictionary *detailsDict = (NSDictionary *)[(id<SODataProperty>)dictionary[@"flightDetails"] value];

    [DataController configureFlightDetailsSampleModel:detailsModel withDictionary:detailsDict];

    model.flightDetails = detailsModel;
    model.PRICE = (NSNumber *)[(id<SODataProperty>)dictionary[@"PRICE"] value];
    model.CURRENCY = (NSString *)[(id<SODataProperty>)dictionary[@"CURRENCY"] value];
    model.PLANETYPE = (NSString *)[(id<SODataProperty>)dictionary[@"PLANETYPE"] value];
    model.SEATSMAX = (NSNumber *)[(id<SODataProperty>)dictionary[@"SEATSMAX"] value];
    model.SEATSOCC = (NSNumber *)[(id<SODataProperty>)dictionary[@"SEATSOCC"] value];
    model.PAYMENTSUM = (NSNumber *)[(id<SODataProperty>)dictionary[@"PAYMENTSUM"] value];
    model.SEATSMAX_B = (NSNumber *)[(id<SODataProperty>)dictionary[@"SEATSMAX_B"] value];
    model.SEATSOCC_B = (NSNumber *)[(id<SODataProperty>)dictionary[@"SEATSOCC_B"] value];
    model.SEATSMAX_F = (NSNumber *)[(id<SODataProperty>)dictionary[@"SEATSMAX_F"] value];
    model.SEATSOCC_F = (NSNumber *)[(id<SODataProperty>)dictionary[@"SEATSOCC_F"] value];
}

+(void)configureFlightDetailsSampleModel:(FlightDetailsSample *)model withDictionary:(NSDictionary *)dictionary
{
    model.countryFrom = (NSString *)[(id<SODataProperty>)dictionary[@"countryFrom"] value];
    model.cityFrom = (NSString *)[(id<SODataProperty>)dictionary[@"cityFrom"] value];
    model.airportFrom = (NSString *)[(id<SODataProperty>)dictionary[@"airportFrom"] value];
    model.countryTo = (NSString *)[(id<SODataProperty>)dictionary[@"countryTo"] value];
    model.airportTo = (NSString *)[(id<SODataProperty>)dictionary[@"airportTo"] value];
    model.flightTime = (NSNumber *)[(id<SODataProperty>)dictionary[@"flightTime"] value];
    model.departureTime = (SODataDuration *)[(id<SODataProperty>)dictionary[@"departureTime"] value];
    model.arrivalTime = (SODataDuration *)[(id<SODataProperty>)dictionary[@"arrivalTime"] value];
    model.distance = (NSNumber *)[(id<SODataProperty>)dictionary[@"distance"] value];
    model.distanceUnit = (NSNumber *)[(id<SODataProperty>)dictionary[@"distanceUnit"] value];
    model.flightType = (NSNumber *)[(id<SODataProperty>)dictionary[@"flightType"] value];
    model.period = (NSNumber *)[(id<SODataProperty>)dictionary[@"period"] value];

}

@end
