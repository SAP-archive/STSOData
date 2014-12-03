//
//  TravelAgencyCell.h
//  Template
//
//  Created by Stadelman, Stan on 12/2/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelAgencyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *agencyName;
@property (weak, nonatomic) IBOutlet UILabel *agencyPhone;
@property (weak, nonatomic) IBOutlet UILabel *agencyStreetCityState;
@property (weak, nonatomic) IBOutlet UILabel *agencyCountryPostcode;
@property (weak, nonatomic) IBOutlet UILabel *agencyURL;

@end
