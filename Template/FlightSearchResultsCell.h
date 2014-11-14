//
//  FlightSearchResultsCell.h
//  Template
//
//  Created by Stadelman, Stan on 9/19/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightSearchResultsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
