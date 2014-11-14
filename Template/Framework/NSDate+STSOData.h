//
//  NSDate+STSOData.h
//  SMP3ODataAPI
//
//  Created by Stadelman, Stan on 8/12/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SODataDuration.h"

@interface NSDate (STSOData)

-(NSString *)dateToODataStringWithFormat:(NSString *)dateFormat;

+(NSDate *)dateFromODataString:(NSString *)oDataString dateFormat:(NSString *)dateFormat;

+(NSDate *)dateFromODataDurationComponents:(SODataDuration *)durationComponents inTimeZone:(NSTimeZone *)timeZone;


@end
