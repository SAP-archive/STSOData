//
//  BookingSample.h
//  Template
//
//  Created by Stadelman, Stan on 9/22/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

@class FlightSample;

@interface BookingSample : NSObject

@property (nonatomic, strong) NSString *carrid;
@property (nonatomic, strong) NSString *connid;
@property (nonatomic, strong) NSDate *fldate;
@property (nonatomic, strong) NSString *bookid;
@property (nonatomic, strong) NSString *CUSTOMID;
@property (nonatomic, strong) NSString *CUSTTYPE;
@property (nonatomic, strong) NSString *SMOKER;
@property (nonatomic, strong) NSString *WUNIT;
@property (nonatomic, strong) NSNumber *LUGGWEIGHT;
@property (nonatomic, strong) NSString *INVOICE;
@property (nonatomic, strong) NSString *CLASS;
@property (nonatomic, strong) NSNumber *FORCURAM;
@property (nonatomic, strong) NSString *FORCURKEY;
@property (nonatomic, strong) NSNumber *LOCCURAM;
@property (nonatomic, strong) NSString *LOCCURKEY;
@property (nonatomic, strong) NSDate *ORDER_DATE;
@property (nonatomic, strong) NSString *COUNTER;
@property (nonatomic, strong) NSString *AGENCYNUM;
@property (nonatomic, strong) NSString *CANCELLED;
@property (nonatomic, strong) NSString *RESERVED;
@property (nonatomic, strong) NSString *PASSNAME;
@property (nonatomic, strong) NSString *PASSFORM;
@property (nonatomic, strong) NSDate *PASSBIRTH;
@property (nonatomic, strong) FlightSample *bookedFlight;


@end
