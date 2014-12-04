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

@interface EditTravelAgency () <UITextViewDelegate>

@property (nonatomic, strong) NSArray *headerTitles;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, weak) UITableViewCell *activeCell;

@end

@implementation EditTravelAgency

- (void)viewDidLoad
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEntity)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.editing = NO;
    
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
}

- (void)saveEntity
{
    id<SODataEntity>newValuesEntity = [self.agency modifiedEntity];
    
    [[DataController shared] updateEntity:newValuesEntity withCompletion:^(BOOL success) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Agency"
                                                        message:[NSString stringWithFormat:@"%@", success ? @"Success!" : @"Sorry, there was an error"]
                                                           delegate:[self parentViewController]
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    [(UINavigationController *)self.parentViewController popViewControllerAnimated:YES];
    
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
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (![self.activeCell isEqual:cell]) {
        
        if (self.editing) {
            
            RemoveTextView(self.activeCell);
            
            self.editing = NO;
        }

        self.activeCell = cell;
        self.editing = YES;
        
        UITextView *textView = EditingTextView(cell.textLabel);
        textView.delegate = self;
        
        [cell.contentView addSubview:textView];
        cell.textLabel.hidden = YES;
    }
}

#pragma mark TextViewDelegate methods

- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    self.activeCell.textLabel.text = textView.text;
    
    NSString *key = SelectedPropertyName(self.tableView, self.headerTitles);
    
    [self.agency setValue:textView.text forKey:key];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    RemoveTextView(self.activeCell);
}

#pragma mark Helper functions

NSString* (^SelectedPropertyName)(UITableView*, NSArray*) = ^NSString* (UITableView *tableView, NSArray *array ) {
    
    NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
    NSDictionary *sectionInfo = array[indexPath.section];

    return sectionInfo[@"properties"][indexPath.row];
};

UITextView* (^EditingTextView)(UILabel *) = ^UITextView* (UILabel *label) {
    
    CGRect wideFrame = CGRectMake(16, 5, 280, 20.5);
    UIFont *labelFont = label.font;
    UITextView *textView = [[UITextView alloc] initWithFrame:wideFrame];
    
    textView.tag = 111;
    textView.textContainerInset = UIEdgeInsetsZero;
    
    textView.font = labelFont;
    textView.textColor = [UIColor darkGrayColor];
    textView.text = label.text;
    
    return textView;
};

void (^RemoveTextView)(UITableViewCell *) = ^void(UITableViewCell *cell) {
    
    UITextView *textView = (UITextView *)[cell.contentView viewWithTag:111];
    [textView removeFromSuperview];
    
    cell.textLabel.hidden = NO;
};


@end
