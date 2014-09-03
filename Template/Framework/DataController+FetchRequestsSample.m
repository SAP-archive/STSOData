//
//  DataController+FetchRequests.m
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 8/11/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "DataController+FetchRequestsSample.h"

#import "SODataRequestParamSingleDefault.h"
#import "SODataEntitySet.h"

@implementation DataController (FetchRequests)

- (void)fetchBookingsWithExpandSample {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    /*
     Construct the resource path, relative to the baseURL
     Include any oData filters & query parameters
     */
    
    NSString *resourcePath = @"BookingCollection?$top=5&$expand=bookedFlight";
    
    /*
     Schedule the request on the store
     */

    [self scheduleRequestForResource:resourcePath withMode:SODataRequestModeRead withEntity:nil withCompletion:^(NSArray *entities, id<SODataRequestExecution> requestExecution, NSError *error) {
        
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        if (entities) {
            
            /*
             Use setter to the model property, to ensure it is recognized by KVO
             */
            [self setBookingsWithExpandSample:entities];
            
        } else {
            
            NSLog(@"did not get any entities, with error: %@", error);
        }
    }];
    
}

- (void)fetchTravelAgenciesSample {
    
    NSString *resourcePath = @"TravelagencyCollection";

    [self scheduleRequestForResource:resourcePath withMode:SODataRequestModeRead withEntity:nil withCompletion:^(NSArray *entities, id<SODataRequestExecution> requestExecution, NSError *error) {
        
        if (entities) {
            
            [self setTravelAgenciesSample:entities];
            
        } else {
            
            NSLog(@"did not get any entities, with error: %@", error);
        }
    }];
}

@end
