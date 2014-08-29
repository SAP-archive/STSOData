//
//  EditableTableViewCell.h
//  Template
//
//  Created by Stadelman, Stan on 8/27/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *propertyName;
@property (weak, nonatomic) IBOutlet UITextField *propertyValue;

@end
