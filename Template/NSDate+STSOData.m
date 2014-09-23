//
//  NSDate+STSOData.m
//  SMP3ODataAPI
//
//  Created by Stadelman, Stan on 8/12/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "NSDate+STSOData.h"

@implementation NSDate (STSOData)

- (NSString *)dateToODataString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString *dateFormat = @"yyyy-MM-dd'T'hh:mm";
    dateFormatter.dateFormat = dateFormat;
    
    return [dateFormatter stringFromDate:self];
}

+(NSDate *)dateFromODataString:(NSString *)oDataString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString *dateFormat = @"yyyy-MM-dd'T'hh:mm:ss";
    dateFormatter.dateFormat = dateFormat;
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.formatterBehavior = NSDateFormatterBehaviorDefault;
    return [dateFormatter dateFromString:oDataString];
}

+(NSDate *)dateFromODataDurationComponents:(SODataDuration *)durationComponents
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    [cal setLocale:[NSLocale currentLocale]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.year = [durationComponents.years integerValue];
    components.month = [durationComponents.months integerValue];
    components.day = [durationComponents.days integerValue];
    components.hour = [durationComponents.hours integerValue];
    components.minute = [durationComponents.minutes integerValue];
    components.second = [durationComponents.seconds integerValue];

    NSDate *output = [cal dateFromComponents:components];

    return output;
}


@end
