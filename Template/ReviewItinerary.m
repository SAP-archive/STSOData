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
    return 6;
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
