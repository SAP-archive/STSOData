//
//  FlightSample.m
//  Template
//
//  Created by Stadelman, Stan on 9/16/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "FlightSample.h"
#import "FlightDetailsSample.h"

@interface FlightSample () {
    
    NSDate *_departureDate;
}

@end

@implementation FlightSample

-(NSDate *)timeZoneAccurateDepartureDate
{
    /* 
     This method is hacky, and only works for this particular sample.  But, it could be generalized to handle the correct local time for the dates in-question.
     */
    if (!_departureDate) {

        NSString *fromTimeZone = [self.flightDetails.cityFrom isEqualToString:@"new york"] ? @"America/New_York" : @"Europe/Berlin";
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDate *departDate = self.fldate;
        NSDate *departTime = [NSDate dateFromODataDurationComponents:self.flightDetails.departureTime inTimeZone:[NSTimeZone timeZoneWithName:fromTimeZone]];
        
        NSDateComponents *departDateComponents = [[NSDateComponents alloc] init];
        departDateComponents = [cal componentsInTimeZone:[NSTimeZone timeZoneWithName:fromTimeZone] fromDate:departDate];
        
        NSDateComponents *departTimeComponents = [[NSDateComponents alloc] init];
        departTimeComponents = [cal componentsInTimeZone:[NSTimeZone timeZoneWithName:fromTimeZone] fromDate:departTime];
        
        _departureDate = combineDateAndTime(cal, departDateComponents, departTimeComponents);
        
        return _departureDate;
    }
    return _departureDate;
}

-(NSDate *)timeZoneVariableArrivalDate
{
    
    NSInteger flightDuration = [self.flightDetails.flightTime integerValue];
    
    return [NSDate dateWithTimeInterval:(flightDuration * 60) sinceDate:[self timeZoneAccurateDepartureDate]];
}

NSDate * (^combineDateAndTime)(NSCalendar *, NSDateComponents *, NSDateComponents *) = ^NSDate * (NSCalendar *cal, NSDateComponents *date, NSDateComponents *time){
    
    NSDateComponents *outputComponents = [[NSDateComponents alloc] init];
    [outputComponents setYear:date.year];
    [outputComponents setMonth:date.month];
    [outputComponents setDay:date.day];
    [outputComponents setHour:time.hour];
    [outputComponents setMinute:time.minute];
    
    return [cal dateFromComponents:outputComponents];
};

@end
