//
//  RecipientTableViewController.m
//  Celebrator
//
//  Created by Justine Herman on 11/29/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "RecipientTableViewController.h"
#import <Realm/Realm.h>
#import "ModelProtocols.h"
#import "Recipient.h"
#import "ListViewCell.h"


@interface RecipientTableViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property RLMResults *recipientsArray;
//@property (nonatomic, weak) UITextField *searchTextField;

//- (void)searchRecipients:(RLMResults *)recipientsArray;

@end

@implementation RecipientTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
}


#pragma mark - UI

- (void)setupUI
{
    
//     RLMResults<Recipient *> *recipientsArray = [Recipient allObjects];
   
}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    Recipient *recipientSectionHeader = self.data[group];
//    return recipientSectionHeader.title;
//
//}


//- (void)searchRecipients:(RLMResults *)recipientsArray
//{
//
//}


- (void)showAllCelebrations
{
    RLMResults<Recipient> *recipientsArray = [Recipient sortedResultsUsingProperty:@"firstName" ascending:YES];
    NSLog(@"%lu", recipientsArray.count);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recipientsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListViewCell" forIndexPath:indexPath];
    Recipient *recipient = [self.recipientsArray objectAtIndexPath:indexPath.row];
    [cell configureCellWithRecipient:recipient];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self performSegueWithIdentifier:@"showRecipientDetailView" sender:self];
}


#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showRecipientDetailView"])
//    {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        Recipient *recipient = [self.recipientsArray objectAtIndex:indexPath];
//        RecipientListDetailViewController *controller = (RecipientListDetailViewController)segue.destinationViewController;
//
//        [controller setDetailItem:recipient];
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
//        controller.delegate = self;
//    }
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


@end
