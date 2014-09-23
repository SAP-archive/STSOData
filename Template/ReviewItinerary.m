//
//  ReviewItinerary.m
//  Template
//
//  Created by Stadelman, Stan on 9/19/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "ReviewItinerary.h"

#import "FlightSearchForm.h"

#import "FlightSample.h"

#import "FlightDetailsSample.h"

#import "TravelDetailsCell.h"

#import "TotalPriceCell.h"

#import "FlightDetailsCell.h"

#import "MilesExplanationCell.h"

#import "BookingSample.h"

#import "DataController+CUDRequests.h"

#import "SODataEntityDefault.h"


@implementation ReviewItinerary

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Review Itinerary";
    self.tableView.sectionFooterHeight = 0.0;
    
}



#pragma mark Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 5:
            return 2;
            break;
        case 6:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

#define kTallCellHeight 108;
#define kRegularCellHeight 44;
#define kButtonCellHeight 54

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0 && indexPath.row == 0) ||
        (indexPath.section == 2) ||
        (indexPath.section == 3) ||
        (indexPath.section == 4)) {
        
        return kTallCellHeight;
        
    } else if (indexPath.section == 6){
        
        return kButtonCellHeight;
        
    } else {
        
        return kRegularCellHeight;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return NSLocalizedString(@"Review your itinerary", @"Review your itinerary");
            break;
        case 2:
            return NSLocalizedString(@"Departing flight", @"Departing flight");
            break;
        case 3:
            return NSLocalizedString(@"Return flight", @"Return flight");
            break;
        default:
            return nil;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            {
                return [self configSectionZeroCellAtIndexPath:indexPath];
            }
            break;
        case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.textLabel.text = @"Taxes and fees";
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                return cell;
            }
            break;
        case 2:
            {
                return [self configFlightDetailsCellForFlight:self.searchForm.selectedDepartureFlight];
            }
            break;
        case 3:
            {
                return [self configFlightDetailsCellForFlight:self.searchForm.selectedReturnFlight];
            }
            break;
        case 4:
            {
                MilesExplanationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MilesExplanationCell"];
                return cell;
            }
            break;
        case 5:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.textLabel.text = indexPath.row == 0 ? @"Rules and restrictions" : @"Additional bag charges may apply";
                return cell;
            }
            break;
        case 6:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                
                UIImageView *searchButtonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchBar"] highlightedImage:[UIImage imageNamed:@"SearchBarSelected"]];
                
                indexPath.row == 0 ? (searchButtonView.image = [UIImage imageNamed:@"SearchBar"]) : (searchButtonView.image = [UIImage imageNamed:@"CancelSearchBar"]);
                
                [cell addSubview:searchButtonView];
                
                searchButtonView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                searchButtonView.layer.position = CGPointMake(cell.frame.size.width / 2,kButtonCellHeight / 2);
                
                UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                searchLabel.text = indexPath.row == 0 ? @"Confirm and continue" : @"Cancel";
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
                searchLabel.layer.position = CGPointMake(cell.frame.size.width / 2,kButtonCellHeight / 2);
                
                cell.backgroundColor = [UIColor clearColor];
                
                return cell;
            }
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
}

-(UITableViewCell *)configSectionZeroCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumberFormatter *currencyFormatter = [self currrencyFormatter];
    
    NSDecimalNumber *departureFlightCost = [NSDecimalNumber decimalNumberWithDecimal:[self.searchForm.selectedDepartureFlight.PRICE decimalValue]];
    
    NSDecimalNumber *returnFlightCost = [NSDecimalNumber decimalNumberWithDecimal:[self.searchForm.selectedReturnFlight.PRICE decimalValue]];
    
    NSDecimalNumber *sum = [departureFlightCost decimalNumberByAdding:returnFlightCost];
    
    NSDecimalNumber *taxAndFees = [sum decimalNumberByMultiplyingBy:[NSDecimalNumber numberWithFloat:0.09f]];
    
    NSDecimalNumber *sumAndTaxes = [sum decimalNumberByAdding:taxAndFees];
    
    if (indexPath.row == 0) {
        
        TravelDetailsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TravelDetailsCell"];
        
        cell.passengerCount.text = @"1 adult";
        cell.ticketCost.text = [currencyFormatter stringFromNumber:sum];
        cell.taxesCost.text = [currencyFormatter stringFromNumber:taxAndFees];
        
        return cell;
        
    } else {
        
        TotalPriceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TotalPriceCell"];
        
        cell.totalPrice.text = [currencyFormatter stringFromNumber:sumAndTaxes];
        cell.totalPrice.textColor = [UIColor colorWithRed:58/255 green:156/255 blue:83/255 alpha:1.0];
        
        return cell;
    }
}

-(FlightDetailsCell *)configFlightDetailsCellForFlight:(FlightSample *)flight
{
    FlightDetailsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FlightDetailsCell"];
    
    cell.flightNumberLabel.text = [NSString stringWithFormat:@"%@%@", flight.carrid, flight.connid];
    
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ (%@) to %@ (%@)", flight.flightDetails.airportFrom, flight.flightDetails.countryFrom, flight.flightDetails.airportTo, flight.flightDetails.countryTo];
    
    NSString *fromTimeZone = [flight.flightDetails.cityFrom isEqualToString:@"New York"] ? @"America/New_York" : @"Europe/Berlin";
    NSString *toTimeZone = [flight.flightDetails.cityFrom isEqualToString:@"New York"] ? @"Europe/Berlin" : @"America/New_York";
    
    NSDateFormatter *fromDateFormatter = [self dateFormatter:fromTimeZone];
    NSDateFormatter *toDateFormatter = [self dateFormatter:toTimeZone];
    
    NSDateFormatter *fromTimeFormatter = [self timeFormatter:fromTimeZone];
    NSDateFormatter *toTimeFormatter = [self timeFormatter:toTimeZone];

    NSDate *departTime = [NSDate dateFromODataDurationComponents:flight.flightDetails.departureTime];
    NSInteger flightDuration = [flight.flightDetails.flightTime integerValue];
    NSDate *arrivalTime = [departTime dateByAddingTimeInterval:(flightDuration * 60)];
    
    cell.departureTimeLabel.text = [[fromTimeFormatter stringFromDate:departTime] lowercaseString];
    cell.arrivalTimeLabel.text = [[toTimeFormatter stringFromDate:arrivalTime] lowercaseString];
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *departDate = self.searchForm.selectedDepartureFlight.fldate;
    NSDate *arrivalDate = [[cal components:NSHourCalendarUnit fromDate:departTime] hour] < [[cal components:NSHourCalendarUnit fromDate:arrivalTime] hour] ? departDate : [departDate dateByAddingTimeInterval:86400];
    
    cell.departureDateLabel.text = [fromDateFormatter stringFromDate:departDate];
    cell.arrivalDateLabel.text = [toDateFormatter stringFromDate:arrivalDate];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 6 && indexPath.row == 0) {
    
        // post create booking
        
        
        BookingSample *booking = [[BookingSample alloc] initWithEntity:[[SODataEntityDefault alloc] initWithType:@"RMTSAMPLEFLIGHT.Booking"]];
        
        booking.carrid = @"AA";
        booking.connid = @"0017";
        booking.fldate = [NSDate dateFromODataString:@"2014-11-15T00:00:00"];
        NSLog(@"flightdate = %@", booking.fldate);
        booking.CUSTOMID = @"00003983";
        booking.CUSTTYPE = @"P";
        booking.WUNIT = @"KGM";
        booking.LUGGWEIGHT = @(17);
        booking.FORCURAM = @(921);
        booking.FORCURKEY = @"EUR";
        booking.LOCCURAM = @(1298);
        booking.LOCCURKEY = @"USD";
        booking.ORDER_DATE = [NSDate dateFromODataString:@"2014-11-22T00:00:00"];
        booking.COUNTER = @"00000000";
        booking.AGENCYNUM = @"00000114";
        booking.PASSNAME = @"David Stadelman";
        booking.PASSBIRTH = [NSDate dateFromODataString:@"1984-04-20T00:00:00"];
        
        [[DataController shared] createEntity:booking inCollection:@"BookingCollection" withCompletion:^(BOOL success) {
            if (success) {
                NSLog(@"booyah");
            };
        }];
//        NSMutableArray *properties = [NSMutableArray alloc];
//        
//        id<SODataProperty> prop = [[SODataPropertyDefault alloc] initWithName:@"agencynum"];
//        prop.value = self.agencyIDInput.text;
//        [self.properties addObject:prop];
//        prop = [[SODataPropertyDefault alloc] initWithName:@"NAME"];
//        prop.value = self.nameInput.text;
//        [self.properties addObject:prop];
//        prop = [[SODataPropertyDefault alloc] initWithName:@"CITY"];
//        prop.value = self.cityInput.text;
//        [self.properties addObject:prop];
//        prop = [[SODataPropertyDefault alloc] initWithName:@"STREET"];
//        prop.value = self.streetInput.text;
//        [self.properties addObject:prop];
//        prop = [[SODataPropertyDefault alloc] initWithName:@"REGION"];
//        prop.value = self.regionInput.text;
//        [self.properties addObject:prop];
//        prop = [[SODataPropertyDefault alloc] initWithName:@"POSTCODE"];
//        prop.value = self.zipInput.text;
//        [self.properties addObject:prop];
//        prop = [[SODataPropertyDefault alloc] initWithName:@"COUNTRY"];
//        prop.value = self.countryInput.text;
//        [self.properties addObject:prop];
//        prop = [[SODataPropertyDefault alloc] initWithName:@"TELEPHONE"];
//        prop.value = self.telephoneInput.text;
//        [self.properties addObject:prop];
//        prop = [[SODataPropertyDefault alloc] initWithName:@"URL"];
//        prop.value = self.urlInput.text;
//        [self.properties addObject:prop];

        
    } else if (indexPath.section == 6 && indexPath.row == 1) {
        
        // cancel and return to search form
        [self.navigationController popToViewController:self.searchForm animated:YES];
    }
}

#pragma mark Number Formatters
-(NSNumberFormatter *)currrencyFormatter
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    return formatter;
}

-(NSDateFormatter *)dateFormatter:(NSString *)timeZone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    if (timeZone) {
        formatter.timeZone = [NSTimeZone timeZoneWithName:timeZone];
    }
    return formatter;
}

-(NSDateFormatter *)timeFormatter:(NSString *)timeZone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    if (timeZone) {
        formatter.timeZone = [NSTimeZone timeZoneWithName:timeZone];
    }
    return formatter;
}
@end
