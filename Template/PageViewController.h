//
//  PageViewController.h
//  Template
//
//  Created by Stadelman, Stan on 9/16/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (strong, nonatomic) NSArray *pageTitles;
@property (nonatomic, assign) NSUInteger index;
@end
