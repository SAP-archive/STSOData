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

-(NSString *)dateToODataString;

+(NSDate *)dateFromODataString:(NSString *)oDataString;

+(NSDate *)dateFromODataDurationComponents:(SODataDuration *)durationComponents;

@end
