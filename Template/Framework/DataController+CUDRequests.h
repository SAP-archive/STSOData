//
//  DataController+CUDRequests.h
//  TravelAgency_RKT
//
//  Created by Stadelman, Stan on 8/12/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import "DataController.h"

#import "SODataEntity.h"

@class SODataEntityDefault;

@interface DataController (CUDRequests)

-(void)updateEntity:(id<SODataEntity>) entity withCompletion:(void(^)(BOOL success))completion;
-(void)deleteEntity:(id<SODataEntity>) entity withCompletion:(void(^)(BOOL success))completion;
-(void)createEntity:(id<SODataEntity>) entity inCollection:(NSString *)collection withCompletion:(void(^)(BOOL success, SODataEntityDefault *newEntity))completion;

@end
