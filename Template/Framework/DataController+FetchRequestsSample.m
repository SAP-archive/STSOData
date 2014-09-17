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
#import "SODataEntity.h"

#import "FlightSample.h"

@implementation DataController (FetchRequests)



/*
Option #1:  set the response values to the Model singleton

This allows multiple observers of the Model to update according to their rules, when the fetch:
response is received.  

This approach also supports a response UI for fetches over the network:  as the application end
user navigates across screens, the screens populate from the last good values, stored as property
values on the Model singleton.
*/
- (void)fetchTravelAgenciesSample {
    
    NSString *resourcePath = @"TravelagencyCollection";

    [self scheduleRequestForResource:resourcePath withMode:SODataRequestModeRead withEntity:nil withCompletion:^(NSArray *entities, id<SODataRequestExecution> requestExecution, NSError *error) {
        
        if (entities) {
            
            [[DataController shared] setTravelAgenciesSample:entities];
            
        } else {
            
            NSLog(@"did not get any entities, with error: %@", error);
        }
    }];
}

/*
Option #2:  Use a completion block to pass the response directly.  

This can be really useful in two contexts:

1.  When you know that you're reading directly from the database 100% of the time for a query, 
    you could opt to skip creating a property on the Model class for the result set:  the db is 
    already the model.  So, you can use a completion block on your fetch: method to keep things 
    nicely asynchronous, and just do a new read when the view appears or end-user refreshes, 
    instead of using KVO.  You lose the observation aspect, but the code is somewhat shorter.
 
2.  Using completion blocks on the response makes writing XCTests much easier.
*/

-(void)fetchTravelAgenciesSampleWithCompletion:(void(^)(NSArray *entities))completion {
    
    NSString *resourcePath = @"TravelagencyCollection";
    
    [self scheduleRequestForResource:resourcePath withMode:SODataRequestModeRead withEntity:nil withCompletion:^(NSArray *entities, id<SODataRequestExecution> requestExecution, NSError *error) {
        
        if (entities) {
            
            completion(entities);
            
        } else {
            
            NSLog(@"did not get any entities, with error: %@", error);
        }
    }];
}

/*
Example of Option #1, with $expand in the resource path
*/
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
            [[DataController shared] setBookingsWithExpandSample:entities];
            
        } else {
            
            NSLog(@"did not get any entities, with error: %@", error);
        }
    }];
    
}

/*
Example of Option #2, using a model implementation for the SODataEntity, using STSODataEntity and STSODataComplex subclasses
*/
-(void)fetchAvailableFlightsSampleWithParameters:(NSDictionary *)parameters WithCompletion:(void(^)(NSArray *entities))completion {
    
    // use mock data for the example; use parameters dictionary in practice
    NSString *mockMinDate = @"2013-04-18T00:00";
    NSString *mockMaxDate = @"2014-12-18T00:00";
    NSString *mockDepartCity = @"new york";
    NSString *mockDestinationCity = @"frankfurt";
    
    NSString *findFlights = [NSString stringWithFormat:@"FlightCollection?$filter=fldate gt datetime'2013-09-16T00:00'"];
    
    [self scheduleRequestForResource:findFlights withMode:SODataRequestModeRead withEntity:nil withCompletion:^(NSArray *entities, id<SODataRequestExecution> requestExecution, NSError *error) {
        
        if (entities) {
        
            NSMutableArray *typedEntities = [[NSMutableArray alloc] init];
            
            for (id<SODataEntity>obj in entities) {
            
                FlightSample *entity = [[FlightSample alloc] initWithEntity:obj];
                
                [typedEntities addObject:entity];
            }
            
            completion(typedEntities);
            
        } else {
            
            NSLog(@"did not get any entities, with error: %@", error);
            
            completion(nil);
        }
    }];
    
}

@end
