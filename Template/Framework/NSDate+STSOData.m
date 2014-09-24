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

+(NSDate *)dateFromODataDurationComponents:(SODataDuration *)durationComponents inTimeZone:(NSTimeZone *)timeZone
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setLocale:[NSLocale currentLocale]];
    cal.timeZone = !!timeZone ? timeZone : [NSTimeZone localTimeZone];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.year = 1990; // garbage year, avoids the 7 min 2 second issue documented here:  http://stackoverflow.com/questions/13596358/setting-nsdatecomponents-results-in-incorrect-nsdate
    
    components.day = !!durationComponents.days ? [durationComponents.days integerValue] : 0;
    components.hour = !!durationComponents.hours ? [durationComponents.hours integerValue] : 0;
    components.minute = !!durationComponents.minutes ? [durationComponents.minutes integerValue] : 0;
    components.second = !!durationComponents.seconds ? [durationComponents.seconds integerValue] : 0;

    NSDate *output = [cal dateFromComponents:components];

    return output;
}


@end
