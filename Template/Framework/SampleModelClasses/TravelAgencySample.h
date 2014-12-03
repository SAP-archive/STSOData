//
//  TravelAgencySample.h
//  Template
//
//  Created by Stadelman, Stan on 12/2/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SODataEntity.h"

@interface TravelAgencySample : NSObject

@property (nonatomic, strong) NSString *agencynum;
@property (nonatomic, strong) NSString *NAME;
@property (nonatomic, strong) NSString *STREET;
@property (nonatomic, strong) NSString *POSTBOX;
@property (nonatomic, strong) NSString *POSTCODE;
@property (nonatomic, strong) NSString *CITY;
@property (nonatomic, strong) NSString *COUNTRY;
@property (nonatomic, strong) NSString *REGION;
@property (nonatomic, strong) NSString *TELEPHONE;
@property (nonatomic, strong) NSString *URL;
@property (nonatomic, strong) NSString *LANGU;
@property (nonatomic, strong) NSString *CURRENCY;
@property (nonatomic, strong) NSString *mimeType;

/*
 Since the TravelAgencies are CREATE/UPDATE/DELETE-enabled, it is most convenient to also have access to the underlying SODataEntity.  
 
 I don't bother to store the SODataEntity for the READ-only model objects.
 */
@property (nonatomic, strong) id<SODataEntity> entity;

@end
