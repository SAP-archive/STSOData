//
//  TravelDetailsCell.h
//  SMP3ODataAPI
//
//  Created by Stadelman, Stan on 6/5/14.
//  Copyright (c) 2014 SAP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *passengerCount;
@property (weak, nonatomic) IBOutlet UILabel *ticketCost;
@property (weak, nonatomic) IBOutlet UILabel *taxesCost;

@end
