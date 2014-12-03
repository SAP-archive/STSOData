//
//  HomeScreen.m
//  Template
//
//  Created by Stadelman, Stan on 9/19/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "HomeScreen.h"
#import "FlightSearchForm.h"
#import "TravelAgenciesList.h"

@implementation HomeScreen

-(void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)myAccounts:(id)sender {
    NSLog(@"myAccounts");
}
- (IBAction)bookFlights:(id)sender {
    NSLog(@"bookFlights");
    FlightSearchForm *vc = [[FlightSearchForm alloc] initWithStyle:UITableViewStyleGrouped];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)manageAgencies:(id)sender {
    NSLog(@"manageAgencies");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    TravelAgenciesList *vc = [storyboard instantiateViewControllerWithIdentifier:@"TravelAgenciesList"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
