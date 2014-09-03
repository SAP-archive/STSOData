//
//  MasterViewController.m
//  Template
//
//  Created by Stadelman, Stan on 8/4/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "DataController+FetchRequestsSample.h"

#import "SODataEntityDefault.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data"];
    self.refreshControl = refreshControl;
    [self.refreshControl addTarget:self action:@selector(flushAndRefresh:) forControlEvents:UIControlEventValueChanged];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kLogonFinished object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        
        [[DataController shared].store openStoreWithCompletion:^(BOOL success) {
            NSLog(@"%s", __PRETTY_FUNCTION__);
            [[DataController shared] fetchTravelAgenciesSample];
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[DataController shared] addObserver:self
                              forKeyPath:@"travelAgenciesSample"
                                 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
                                 context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[DataController shared] removeObserver:self
                                 forKeyPath:@"travelAgenciesSample"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!object) return;
    
    if ([keyPath isEqual:@"travelAgenciesSample"]) {
        NSLog(@"object = %@ %s", object, __PRETTY_FUNCTION__);
        [self.tableView reloadData];
    }
}

- (void)flushAndRefresh:(id)sender
{
    if ([DataController shared].workingMode == WorkingModeOnline) {
        [[DataController shared] fetchTravelAgenciesSample];
        [self.refreshControl endRefreshing];
    } else {
        [[DataController shared].store flushAndRefresh:^(BOOL success) {
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DataController shared].travelAgenciesSample.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    SODataEntityDefault *object = [DataController shared].travelAgenciesSample[indexPath.row];
    
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
