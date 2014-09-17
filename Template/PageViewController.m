//
//  PageViewController.m
//  Template
//
//  Created by Stadelman, Stan on 9/16/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "PageViewController.h"
#import "Page.h"

@implementation PageViewController

- (void)viewDidLoad
{
    _pageTitles = @[@"My flights", @"Book a flight"];
    
    
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    Page *startingPage = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingPage];
    
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        //
    }];
    
//    [self didMoveToParentViewController:self];
    

}

- (Page *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    Page *page = [self.storyboard instantiateViewControllerWithIdentifier:@"Page"];
//    page.backgroundImageView = [
//    page.foregroundImageView = self.pageTitles[index];
    
    return page;
}

#pragma mark Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (_index == 0 || _index == NSNotFound) {
        return nil;
    }
    
    _index--;
    return [self viewControllerAtIndex:self.index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (_index == NSNotFound) {
        return nil;
    }
    
    _index++;
    
    if (_index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:self.index];
}

@end
