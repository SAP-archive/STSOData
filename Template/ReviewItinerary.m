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

#import "BookingSample.h"

#import "TravelDetailsCell.h"
#import "TotalPriceCell.h"
#import "FlightDetailsCell.h"
#import "MilesExplanationCell.h"

#import "DataController+CUDRequests.h"
#import "DataController+ConfigureModelsSample.h"

#import "SODataEntityDefault.h"
#import "SODataPropertyDefault.h"

#import <stdlib.h>


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
    
    NSString *fromTimeZone = [flight.flightDetails.cityFrom isEqualToString:@"new york"] ? @"America/New_York" : @"Europe/Berlin";
    NSString *toTimeZone = [flight.flightDetails.cityFrom isEqualToString:@"new york"] ? @"Europe/Berlin" : @"America/New_York";
    
    NSDateFormatter *fromDateFormatter = [self dateFormatter:fromTimeZone];
    NSDateFormatter *toDateFormatter = [self dateFormatter:toTimeZone];
    
    NSDateFormatter *fromTimeFormatter = [self timeFormatter:fromTimeZone];
    NSDateFormatter *toTimeFormatter = [self timeFormatter:toTimeZone];
//    
//    NSInteger flightDuration = [flight.flightDetails.flightTime integerValue];
//
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    
//    NSDate *departDate = self.searchForm.selectedDepartureFlight.fldate;
//    NSDate *departTime = [NSDate dateFromODataDurationComponents:flight.flightDetails.departureTime inTimeZone:[NSTimeZone timeZoneWithName:fromTimeZone]];
//    
//    NSDateComponents *departDateComponents = [[NSDateComponents alloc] init];
//    departDateComponents = [cal componentsInTimeZone:[NSTimeZone timeZoneWithName:fromTimeZone] fromDate:departDate];
//    
//    NSDateComponents *departTimeComponents = [[NSDateComponents alloc] init];
//    departTimeComponents = [cal componentsInTimeZone:[NSTimeZone timeZoneWithName:fromTimeZone] fromDate:departTime];
//    
    NSDate *fullDepartDate = [flight timeZoneAccurateDepartureDate];
    NSDate *fullArrivalDate = [flight timeZoneVariableArrivalDate];

    cell.departureTimeLabel.text = [[fromTimeFormatter stringFromDate:fullDepartDate] lowercaseString];
    cell.arrivalTimeLabel.text = [[toTimeFormatter stringFromDate:fullArrivalDate] lowercaseString];
    
    cell.departureDateLabel.text = [fromDateFormatter stringFromDate:fullDepartDate];
    cell.arrivalDateLabel.text = [toDateFormatter stringFromDate:fullArrivalDate];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 6 && indexPath.row == 0) {
    
        int generatedCustomerNumber = arc4random_uniform(3900); // need to increment customer number below, should resolve vast majority of conflicts
        // post create booking
        
        SODataEntityDefault *booking = [[SODataEntityDefault alloc] initWithType:@"RMTSAMPLEFLIGHT.Booking"];
        
        NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];

        properties[@"carrid"] = @"AA";
        properties[@"connid"] = @"0017";
        properties[@"fldate"] = [NSDate dateFromODataString:@"2014-11-15T00:00:00"];
        properties[@"CUSTOMID"] = [NSString stringWithFormat:@"%08d", generatedCustomerNumber];
        properties[@"CUSTTYPE"] = @"P";
        properties[@"WUNIT"] = @"KGM";
        properties[@"LUGGWEIGHT"] = [NSDecimalNumber numberWithDouble:17.4];
        properties[@"FORCURAM"] = [NSDecimalNumber numberWithDouble:921.18];
        properties[@"FORCURKEY"] = @"EUR";
        properties[@"LOCCURAM"] = [NSDecimalNumber numberWithDouble:1298.38];
        properties[@"LOCCURKEY"] = @"USD";
        properties[@"ORDER_DATE"] = [NSDate dateFromODataString:@"2014-11-22T00:00:00"];
        properties[@"COUNTER"] = @"00000000";
        properties[@"AGENCYNUM"] = @"00000114";
        properties[@"PASSNAME"] = @"Will The-Thrill Clark";
        properties[@"PASSBIRTH"] = [NSDate dateFromODataString:@"1988-02-08T00:00:00"];
        
        __block void (^setProperties)(SODataEntityDefault *, NSMutableDictionary *) = ^void (SODataEntityDefault *entity, NSMutableDictionary *properties){
            
            [[properties allKeys] enumerateObjectsUsingBlock:^(NSString *keyName, NSUInteger idx, BOOL *stop) {
                SODataPropertyDefault *prop = [[SODataPropertyDefault alloc] initWithName:keyName];
                prop.value = properties[keyName];
                [entity.properties setObject:prop forKey:keyName];
            }];
            
            return;
        };
        
        setProperties(booking, properties);


        [[DataController shared] createEntity:booking inCollection:@"BookingCollection" withCompletion:^(BOOL success, SODataEntityDefault *newEntity) {
            if (success) {
            
                BookingSample *newBooking = [BookingSample new];
                
                [DataController configureBookingSampleModel:newBooking withDictionary:newEntity.properties];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Booking Success"
                                                                message:[NSString stringWithFormat:@"Thank you for booking, \n%@\nPresident, Fist-Bumps\n& CEO of Good Times", newBooking.PASSNAME]
                                                                delegate:self.searchForm
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popToViewController:self.searchForm animated:YES];

            };
        }];

        
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
