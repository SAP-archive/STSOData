//
//  FlightSearchResults.m
//  Template
//
//  Created by Stadelman, Stan on 9/19/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "FlightSearchResults.h"

#import "FlightSearchResultsCell.h"

#import "FlightSearchForm.h"

#import "FlightSample.h"

#import "FlightDetailsSample.h"

#import "DataController+FetchRequestsSample.h"

#import "NSDate+STSOData.h"

#import "ReviewItinerary.h"

@implementation FlightSearchResults

#pragma mark - Table View data source

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[FlightSearchResultsCell class] forCellReuseIdentifier:@"FlightSearchResultsCell"];
    
    self.searchResults = [[NSArray alloc]init];

}

- (void)searchAvailableFlights:(NSDictionary *)searchParameters
{
/*
     Real-time search results (like 'available flights', or 'price') are good candidates for
     keeping the model local to the search.  Since the results are transient, it doesn't make sense
     to maintain them in the central model, so other view controllers could observe the changes.
     
     Instead, use the completion block on the fetch: request to handle the reponse, in the context
     in which it is intended.
*/
    [[DataController shared] fetchAvailableFlightsSampleWithParameters:searchParameters WithCompletion:^(NSArray *entities) {
        self.searchResults = entities;
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}

#define kCellHeight 58;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlightSearchResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSRC" forIndexPath:indexPath];
    
    FlightSample *flight = self.searchResults[indexPath.row];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.timeStyle = NSDateFormatterShortStyle;
    
/*
    Use this little helper category on NSDate to handle conversions between NSDate and OData datetime formats
*/
    NSDate *departTime = [NSDate dateFromODataDurationComponents:flight.flightDetails.departureTime];
    NSInteger flightTime = [flight.flightDetails.flightTime integerValue];
    NSDate *arriveTime = [departTime dateByAddingTimeInterval:(flightTime * 60)];

    cell.departureTimeLabel.text = [[timeFormatter stringFromDate:departTime] lowercaseString];
    cell.arrivalTimeLabel.text = [[timeFormatter stringFromDate:arriveTime] lowercaseString];
    
    int hours = flightTime / 60;
    int minutes = flightTime - (hours * 60);
    
    NSString *description = [NSString stringWithFormat:@"Non-stop / %ih %im", hours, minutes];
    cell.descriptionLabel.text = description;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [numberFormatter setMaximumFractionDigits:0];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:flight.PRICE]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlightSample *selectedFlight = self.searchResults[indexPath.row];
    
    if (self.direction == Departing) {
        self.searchForm.selectedDepartureFlight = selectedFlight;
    } else {
        self.searchForm.selectedReturnFlight = selectedFlight;
    }
    
    if (self.direction == Departing) {
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
        FlightSearchResults *returningSearch = [storyboard instantiateViewControllerWithIdentifier:@"FlightSearchResults"];
        
        returningSearch.searchForm = self.searchForm;
        
        returningSearch.direction = Returning;
        
        returningSearch.title = @"Select Return Flight";
    
/*
        Again, cheat a little here to get a good result set from the sample service.
        
        Search from departure day +1.
*/
        NSDictionary *returnSearchParameters = @{@"fromdate" : [[self.searchForm.departureDate dateByAddingTimeInterval:87600] oDataDateTime],
                                                 @"todate" : [self.searchForm.returnDate oDataDateTime],
                                                 @"cityfrom" : self.searchForm.returnAirportCity,
                                                 @"cityto" : self.searchForm.departureAirportCity };
        
        [returningSearch searchAvailableFlights:returnSearchParameters];
        
        [self.navigationController pushViewController:returningSearch animated:YES];
        
    } else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
        ReviewItinerary *reviewItinerary = [storyboard instantiateViewControllerWithIdentifier:@"ReviewItinerary"];
        
        reviewItinerary.searchForm = self.searchForm;
        
        [self.navigationController pushViewController:reviewItinerary animated:YES];
    }
}

@end
