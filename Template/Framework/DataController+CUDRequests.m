//
//  DataController+CUDRequests.m
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 8/12/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "DataController+CUDRequests.h"
#import "DataController+FetchRequestsSample.h"

#import "LogonHandler+E2ETrace.h"

#import "SODataEntityDefault.h"



@implementation DataController (CUDRequests)

#pragma mark - Update

-(void)updateEntity:(id<SODataEntity>) entity withCompletion:(void(^)(BOOL success))completion {

    [self scheduleRequestForResource:[entity editResourcePath]
                            withMode:SODataRequestModeUpdate
                          withEntity:entity
                      withCompletion:^(NSArray *entities, id<SODataRequestExecution> requestExecution, NSError *error) {
                          
                          NSLog(@"%s", __PRETTY_FUNCTION__);
                          
                          if (error) {
                              NSLog(@"error = %@", error);
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Updating"
                                                                              message:[NSString stringWithFormat:@"Error updating entity %@", [entity description]]
                                                                              delegate:self
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil, nil];
                              [alert show];
                              completion(NO);
                          } else {
                              completion(YES);
                          }
                          
                      }];
    
}

-(void)deleteEntity:(id<SODataEntity>) entity withCompletion:(void(^)(BOOL success))completion
{
    
    [self scheduleRequestForResource:[entity editResourcePath]
                            withMode:SODataRequestModeDelete
                          withEntity:entity
                      withCompletion:^(NSArray *entities, id<SODataRequestExecution> requestExecution, NSError *error) {
                          
                          NSLog(@"%s", __PRETTY_FUNCTION__);
                          
                          if (error) {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Deleting Entity"
                                                                              message:[NSString stringWithFormat:@"Error deleting entity %@", [entity description]]
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil, nil];
                              [alert show];
                              completion(NO);
                          } else {
                              completion(YES);
                          }
                          
    }];
}

-(void)createEntity:(id<SODataEntity>) entity inCollection:(NSString *)collection withCompletion:(void(^)(BOOL success, SODataEntityDefault *newEntity))completion
{
    
    [self scheduleRequestForResource:collection
                            withMode:SODataRequestModeCreate
                          withEntity:entity
                      withCompletion:^(NSArray *entities, id<SODataRequestExecution> requestExecution, NSError *error) {
                          
                          NSLog(@"%s", __PRETTY_FUNCTION__);
                          if (error) {
                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Creating Entity"
                                                                              message:[NSString stringWithFormat:@"Error creating entity %@", [entity description]]
                                                                             delegate:self
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil, nil];
                              [alert show];
                              completion(NO, nil);
                          } else {
                              completion(YES, entities[0]);
                          }
                          
                      }];
}

@end
