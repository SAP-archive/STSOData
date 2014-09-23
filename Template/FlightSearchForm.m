//
//  FlightSearchForm.m
//  Template
//
//  Created by Stadelman, Stan on 9/19/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "FlightSearchForm.h"

#import "FlightSearchResults.h"

@interface FlightSearchForm ()

@property (nonatomic, assign) BOOL minimumSearchParameters;

@end

@implementation FlightSearchForm

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Book a flight";
    self.tableView.sectionFooterHeight = 0.0;
    
/*
    Build a great UI for collecting these values from the end user. 
    
    I would recommend checking out PDTSimpleCalendar from Jive Software team
    for the calendar control.
    
        pod 'PDTSimpleCalendar', '~> 0.7.0'
 
    Here's some sample data with good results from the sample service.
    It's a really long round-trip, but it returns enough records to be interesting.
*/
    self.departureDate = [NSDate dateWithTimeIntervalSinceNow:-47304000]; // about a year and a half ago
    self.returnDate = [NSDate dateWithTimeIntervalSinceNow:-15768000];    // about 6 months ago
    
    self.departureAirportCity = @"new york";
    self.returnAirportCity = @"frankfurt";
    
    self.numPassengers = @(1);
    self.classPreference = @"Business";
    
}

-(BOOL)minimumSearchParameters
{
    return (!!self.departureDate && !!self.returnDate && !!self.departureAirportCity && !!self.returnAirportCity);
}

- (void)searchFlights
{
    NSDictionary *searchParameters = @{@"fromdate" : [self.departureDate dateToODataString],
                                       @"todate" : [self.returnDate dateToODataString],
                                       @"cityfrom" : self.departureAirportCity,
                                       @"cityto" : self.returnAirportCity };
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    FlightSearchResults *flightSearchResults = [storyboard instantiateViewControllerWithIdentifier:@"FlightSearchResults"];
    flightSearchResults.searchForm = self;
    
    flightSearchResults.direction = Departing;
    
    flightSearchResults.title = @"Select Departure Flight";
    
    [flightSearchResults searchAvailableFlights:searchParameters];
    
    [self.navigationController pushViewController:flightSearchResults animated:YES];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section > 1 ? 3 : 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return NSLocalizedString(@"Airports", @"Airports");
            break;
        case 1:
            return NSLocalizedString(@"Dates", @"Dates");
            break;
        case 2:
            return NSLocalizedString(@"Preferences", @"Preferences");
            break;
        default:
            return @"";
            break;
    }
}

#define kSearchBarCellHeight 54

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 3 && indexPath.row == 1) ? kSearchBarCellHeight : 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch (indexPath.section) {
        case 0:
            [self configAirportsPickerCell:cell atIndexPath:indexPath];
            break;
        case 1:
            [self configDatesPickerCell:cell atIndexPath:indexPath];
            break;
        case 2:
            [self configPreferencesCell:cell atIndexPath:indexPath];
            break;
        case 3:
            [self configLastSetCell:cell atIndexPath:indexPath];
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row == 1) {
        [self searchFlights];
    }
}

#pragma mark - Cell Configuration methods

#define kIndentationWidth 8
#define kCellFont [UIFont fontWithName:@"HelveticaNeue" size:15]

-(void)configAirportsPickerCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.indentationWidth = kIndentationWidth;
    cell.textLabel.font = kCellFont;
    cell.imageView.image = [UIImage imageNamed:@"grayplane"];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = self.departureAirportCity != nil ? [NSString stringWithFormat:@"JFK - %@ ", [self.departureAirportCity capitalizedString]] : @"From";
        
    } else {
        
        cell.textLabel.text = self.returnAirportCity != nil ? [NSString stringWithFormat:@"FRA - %@", [self.returnAirportCity capitalizedString]] : @"To";
        
    }
}

-(void)configDatesPickerCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.imageView.image = [UIImage imageNamed:@"calendar"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.indentationWidth = kIndentationWidth;
    cell.textLabel.font = kCellFont;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = self.departureDate != nil ? [formatter stringFromDate:self.departureDate] : @"Depart";
        
    } else {
        
        cell.textLabel.text = self.returnDate != nil ? [formatter stringFromDate:self.returnDate] : @"Return";
    }
}

-(void)configPreferencesCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.indentationWidth = kIndentationWidth;
    cell.textLabel.font = kCellFont;
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"grayticket"];
        cell.textLabel.text = self.classPreference;
    }
    
    if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"contact"];
        NSString *passengers = @"Passenger";
        if ([self.numPassengers integerValue] > 1) {
            passengers = @"Passengers";
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.numPassengers, passengers];
    }
    if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"filter"];
        if (self.minPrice || self.maxPrice  ) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ to %@", self.minPrice, self.maxPrice];
        } else {
            cell.textLabel.text = @"Price";
        }
    }
}

-(void)configLastSetCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"Nonstop flights only";
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        [cell addSubview:mySwitch];
        mySwitch.layer.anchorPoint = CGPointMake(1.0, 0.5);
        mySwitch.layer.position = CGPointMake(312, 22);
        
        mySwitch.on = YES;
        
    }
    
    if (indexPath.row == 1) {
        
        UIImageView *searchButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchBarDisabled"] highlightedImage:[UIImage imageNamed:@"SearchBarSelected"]];
        
        searchButtonView.image = [self minimumSearchParameters] ? [UIImage imageNamed:@"SearchBar"] : [UIImage imageNamed:@"SearchBarDisabled"];
        
        [cell addSubview:searchButtonView];
        
        searchButtonView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        searchButtonView.layer.position = CGPointMake(cell.frame.size.width / 2,kSearchBarCellHeight / 2);
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        searchLabel.text = @"Search flights";
        searchLabel.font = [UIFont systemFontOfSize:16];
        searchLabel.textColor = [UIColor whiteColor];
        [cell addSubview:searchLabel];
        
        NSDictionary *attributes = @{NSFontAttributeName: searchLabel.font};
        CGSize correctSize = [searchLabel.text sizeWithAttributes:attributes];
        
        CGRect titleFrame = searchLabel.frame;
        titleFrame.size.height = correctSize.height;
        titleFrame.size.width = correctSize.width;
        searchLabel.frame = titleFrame;
        
        searchLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
        searchLabel.layer.position = CGPointMake(cell.frame.size.width / 2,kSearchBarCellHeight / 2);
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.userInteractionEnabled = [self minimumSearchParameters];
        
    }
    if (indexPath.row == 2) {
        
        cell.textLabel.text = @"Bag rules and optional services";
        cell.textLabel.font = kCellFont;
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
}
@end
