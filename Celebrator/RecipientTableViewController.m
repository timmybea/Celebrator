//
//  RecipientTableViewController.m
//  Celebrator
//
//  Created by Justine Herman on 11/29/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "RecipientTableViewController.h"
#import "RecipientListDetailViewController.h"
#import "AddRecipientViewController.h"
#import <Realm/Realm.h>
#import "ModelProtocols.h"
#import "Recipient.h"


@interface RecipientTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) RecipientListDetailViewController *listDetailVC;
@property (nonatomic) AddRecipientViewController *addRecipientVC;
@property (nonatomic, weak) UITableView *tableView;
@property RLMResults *recipientsArray;
//@property (nonatomic, weak) UITextField *searchTextField;

//- (void)searchRecipients:(RLMResults *)recipientsArray;

@end

@implementation RecipientTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    
}


#pragma mark - UI

- (void)setupUI
{
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToAddRecipientView:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.addRecipientVC = (AddRecipientViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
     RLMResults<Recipient *> *recipientsArray = [Recipient allObjects];
   
}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//}


//- (void)searchRecipients:(RLMResults *)recipientsArray
//{
//
//}

//- (void)goToAddRecipientView: (id)sender {
//    if (!self.recipientsArray)
//    {
//        self.recipientsArray = [RLMResults<Recipient *> *recipientsArray];
//    }
//    [self performSegueWithIdentifier:@"addRecipientViewController" sender:self];
//}

//- (IBAction)add:(id)sender {
//    [self addRecipent];
//}

//- (void)addRecipent
//{
//
//    Recipient *recipient1 = [[Recipient alloc] init];
//    recipient1.firstName = @"David";
//    recipient1.lastName = @"Henderson";
//    recipient1.group = @"Friends";
//
//    RLMRealm *realm = [RLMRealm defaultRealm];
//
//    [realm transactionWithBlock:^{
//        [realm addObject:recipient1];
//    }];
//}


//- (IBAction)update:(id)sender
//{
//    [self updateRecipient];
//}

//- (void)updateRecipient
//{
//    dispatch_async(dispatch_queue_create("background", 0), ^{
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        RLMResults<Recipient *> *recipientsArray = [Recipient objectsWhere:@"lastName == Henderson"];
//        Recipient *recipient1 = [recipientsArray firstObject];
//        [realm transactionWithBlock:^{
//            recipient1.lastName = @"Harrison";
//            [realm addObject:recipient1];
//        }];
//    });
//                                                   
//}

//- (IBAction)query:(id)sender
//{
//     [self queryRecipient];
//}
//
//- (void)queryRecipient
//{
//    RLMResults<Recipient *> *queriedRecipients = [Recipient objectsWhere:@"lastName == Henderson"];
//    NSLog(@"%lu", queriedRecipients.count);
//}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recipientsArray.count;
    
//    switch (section)
//    {
//        case 0: return "@Family"; break;
//        case 1: return "@Friends"; break;
//        case 2: return "@School"; break;
//        case 3: return "@Work"; break;
//        case 4: return "@Other"; break;
//    }
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListViewCell" forIndexPath:indexPath];
//    Recipient *recipientCell = self.recipientsArray[indexPath.row];
//    
//    return cell;
//}
//
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


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
//    }
//    else if ([[segue identifier] isEqualToString:@"addRecipientViewController"])
//    {
//        AddRecipientViewController *controller = (AddRecipientViewController *)[segue destinationViewController];
//        controller.delegate = self;
//    }
//
//}

@end
