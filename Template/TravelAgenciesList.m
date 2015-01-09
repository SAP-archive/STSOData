//
//  TravelAgenciesList.m
//  Template
//
//  Created by Stadelman, Stan on 12/2/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "TravelAgenciesList.h"

#import "DataController+FetchRequestsSample.h"

#import "TravelAgencyCell.h"

#import "TravelAgencySample.h"

#import "EditTravelAgency.h"

@interface TravelAgenciesList()

@property (nonatomic, strong) NSMutableArray *agencies;

@end

@implementation TravelAgenciesList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshStore) forControlEvents: UIControlEventValueChanged];

    [[NSNotificationCenter defaultCenter] addObserverForName:kSODataOfflineStoreFlushRefreshStateChange object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {

        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString: (NSString *)note.object];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadTravelAgencies];
}

- (void)loadTravelAgencies
{
    [[DataController shared] fetchTravelAgenciesSampleWithCompletion:^(NSArray *entities) {
        if (![_agencies isEqualToArray:entities]) {
            
            NSMutableArray *mutableEntities = [NSMutableArray arrayWithArray:entities];
            [self setAgencies:mutableEntities];
        }
    }];
}

- (void)setAgencies:(NSMutableArray *)agencies
{
    if (![self.agencies isEqualToArray:agencies]) {
        _agencies = agencies;
        
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UIRefreshControl

- (void)refreshStore
{
    [[[DataController shared] localStore] flushAndRefresh:^(BOOL success) {
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.agencies count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TravelAgencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TravelAgencyCell" forIndexPath:indexPath];
    
    TravelAgencySample *agency = self.agencies[indexPath.row];
    
    cell.agencyName.text = agency.NAME;
    cell.agencyPhone.text = agency.TELEPHONE;
    
    cell.agencyStreetCityState.text = [NSString stringWithFormat:@"%@%@, %@, %@",
                                       agency.POSTBOX.length > 0 ? [NSString stringWithFormat:@"%@ ", agency.POSTBOX] : @"", agency.STREET, agency.CITY, agency.REGION];
    
    cell.agencyCountryPostcode.text = [NSString stringWithFormat:@"%@%@%@", agency.COUNTRY, (agency.COUNTRY.length > 0 && agency.POSTCODE.length > 0) ? @", " : @"", agency.POSTCODE];
    
    cell.agencyURL.text = agency.URL;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     The segue is defined on the storyboard; -performSegueWithIdentifier is implemented below.
     
     Use the sender parameter to pass the TravelAgencySample object which will be edited.
     */
    [self performSegueWithIdentifier:@"EditTravelAgency" sender:self.agencies[indexPath.row]];
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     EditTravelAgency *edit = [segue destinationViewController];
     
     edit.agency = sender;
 }

@end
