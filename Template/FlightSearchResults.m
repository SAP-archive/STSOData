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

#import "Usage.h"
#import "Timer.h"

@interface FlightSearchResults () {
    NSArray *sectionHeaders;
    Timer *t;
}

@end
@implementation FlightSearchResults

#pragma mark - Table View data source


#define kFlightSearchResultsLoaded @"FSRViewLoaded"

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[FlightSearchResultsCell class] forCellReuseIdentifier:@"FlightSearchResultsCell"];
    
    self.searchResults = [[NSMutableDictionary alloc] init];
    
    t = [Usage makeTimer:kFlightSearchResultsLoaded];
    

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
    
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    
        NSMutableDictionary *groupedRecords = [[NSMutableDictionary alloc] init];
        
        NSArray *sortedRecords = [entities sortedArrayUsingComparator:^NSComparisonResult(FlightSample *obj1, FlightSample *obj2) {
            return [obj1.fldate compare:obj2.fldate];
        }];
        
        [sortedRecords enumerateObjectsUsingBlock:^(FlightSample *obj, NSUInteger idx, BOOL *stop) {
        
            NSString *dateString = [dateFormatter stringFromDate:obj.fldate];
            
            if (!groupedRecords[dateString]) {
                NSMutableArray *recordsForDate = [[NSMutableArray alloc] initWithObjects:obj, nil];
                groupedRecords[dateString] = recordsForDate;
            } else {
                [groupedRecords[dateString] insertObject:obj atIndex:0];
            }
        }];
        
        sectionHeaders = [[groupedRecords allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        
            NSDate *d1 = [dateFormatter dateFromString:obj1];
            NSDate *d2 = [dateFormatter dateFromString:obj2];
            return [d1 compare:d2];
        }];
        
        self.searchResults = groupedRecords;
        [self.tableView reloadData];
        
        [Usage stopTimer:t];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionHeaders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = sectionHeaders[section];
    
    return [self.searchResults[key] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionHeaders[section];
}

#define kCellHeight 58;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlightSearchResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FSRC" forIndexPath:indexPath];
    
    FlightSample *flight = self.searchResults[sectionHeaders[indexPath.section]][indexPath.row];
    
    NSString *fromTimeZone = [flight.flightDetails.cityFrom isEqualToString:@"new york"] ? @"America/New_York" : @"Europe/Berlin";
    NSString *toTimeZone = [flight.flightDetails.cityFrom isEqualToString:@"new york"] ? @"Europe/Berlin" : @"America/New_York";
    
    NSDateFormatter *fromTimeFormatter = [[NSDateFormatter alloc] init];
    fromTimeFormatter.timeStyle = NSDateFormatterShortStyle;
    fromTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:fromTimeZone];
    
    NSDateFormatter *toTimeFormatter = [[NSDateFormatter alloc] init];
    toTimeFormatter.timeStyle = NSDateFormatterShortStyle;
    toTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:toTimeZone];
/*
    Use this little helper category on NSDate to handle conversions between NSDate and OData datetime formats
*/
//    NSDate *departTime = [NSDate dateFromODataDurationComponents:flight.flightDetails.departureTime inTimeZone:nil];
    
    NSInteger flightTime = [flight.flightDetails.flightTime integerValue];
    NSDate *arriveTime = [flight timeZoneVariableArrivalDate];
    
    NSInteger period = [flight.flightDetails.period integerValue];

    cell.departureTimeLabel.text = [[fromTimeFormatter stringFromDate:[flight timeZoneAccurateDepartureDate]] lowercaseString];
    cell.arrivalTimeLabel.text = period < 1 ? [[toTimeFormatter stringFromDate:arriveTime] lowercaseString] : [NSString stringWithFormat:@"%@*", [[toTimeFormatter stringFromDate:arriveTime] lowercaseString]];
    
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
    FlightSample *selectedFlight = self.searchResults[sectionHeaders[indexPath.section]][indexPath.row];
    
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
        
        Search from departure day +7.
*/
        NSDictionary *returnSearchParameters = @{@"fromdate" : [[self.searchForm.departureDate dateByAddingTimeInterval:613200] dateToODataString],
                                                 @"todate" : [self.searchForm.returnDate dateToODataString],
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
