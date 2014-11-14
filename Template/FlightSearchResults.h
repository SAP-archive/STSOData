//
//  FlightSearchResults.h
//  Template
//
//  Created by Stadelman, Stan on 9/19/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlightSearchForm;

typedef NS_ENUM(NSInteger, FlightDirection) {
    Departing,
    Returning
};

@interface FlightSearchResults : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) FlightSearchForm *searchForm;

@property (nonatomic, assign) FlightDirection direction;

@property (nonatomic, strong) NSMutableDictionary *searchResults;

- (void)searchAvailableFlights:(NSDictionary *)searchParameters;

@end
