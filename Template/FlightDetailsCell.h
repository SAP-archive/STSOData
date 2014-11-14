//
//  FlightDetailsCell.h
//  Template
//
//  Created by Stadelman, Stan on 9/18/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *flightNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalDateLabel;

@end
