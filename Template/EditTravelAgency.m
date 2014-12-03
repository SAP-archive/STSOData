//
//  EditTravelAgency.m
//  Template
//
//  Created by Stadelman, Stan on 12/2/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "EditTravelAgency.h"

#import "DataController+CUDRequests.h"

#import "SODataEntityDefault.h"
#import "SODataPropertyDefault.h"

@interface EditTravelAgency ()

@property (nonatomic, strong) NSArray *headerTitles;

@end

@implementation EditTravelAgency

- (void)viewDidLoad
{
    self.headerTitles = @[@{@"header" : @"Travel agency name",
                            @"rows" : @[@"Name", @"Agency ID"],
                            @"properties" : @[@"NAME", @"agencynum"]},
                          
                          @{@"header" : @"Phone",
                            @"rows" : @[@"Tel."],
                            @"properties" : @[@"TELEPHONE"]},
                          
                          @{@"header" : @"Address",
                            @"rows" : @[@"PO Box", @"Street", @"City", @"Region", @"Country", @"Postal Code"],
                            @"properties" : @[@"POSTBOX", @"STREET", @"CITY", @"REGION", @"COUNTRY", @"POSTCODE"]},
                          
                          @{@"header" : @"Web",
                            @"rows" : @[@"Travel agency URL"],
                            @"properties" : @[@"URL"]}];
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEntity)];
}

- (void)saveEntity
{
    SODataEntityDefault *booking = [[SODataEntityDefault alloc] initWithType:@"RMTSAMPLEFLIGHT.Travelagency"];
    
    NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
    
    properties[@"carrid"] = @"AA";

    
    __block void (^setProperties)(SODataEntityDefault *, NSMutableDictionary *) = ^void (SODataEntityDefault *entity, NSMutableDictionary *properties){
        
        [[properties allKeys] enumerateObjectsUsingBlock:^(NSString *keyName, NSUInteger idx, BOOL *stop) {
            SODataPropertyDefault *prop = [[SODataPropertyDefault alloc] initWithName:keyName];
            prop.value = properties[keyName];
            [entity.properties setObject:prop forKey:keyName];
        }];
    };
    
    setProperties(booking, properties);
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [(NSArray *)self.headerTitles[section][@"rows"] count];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EditTravelAgencyCell"];
    
    NSDictionary *sectionInfo = self.headerTitles[indexPath.section];
    NSString *key = sectionInfo[@"properties"][indexPath.row];
    
    cell.textLabel.text = [self.agency valueForKey:key];
    cell.detailTextLabel.text = sectionInfo[@"rows"][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
