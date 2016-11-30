//
//  RecipientViewController.m
//  Celebrator
//
//  Created by Justine Herman on 11/26/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "RecipientViewController.h"
#import "AddRecipientViewController.h"
#import <Realm/Realm.h>
#import "ModelProtocols.h"
#import "Recipient.h"

@interface RecipientViewController ()

@property RLMResults *recipientsArray;


@end

@implementation RecipientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupUI];
}


#pragma mark - UI

//- (void)setupUI
//{
//   // self.title = @"";
//
////    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToAddRecipientView:)];
////    self.navigationItem.rightBarButtonItem = addButton;
////    self.addRecipientViewController = (AddRecipientViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
// 
//}


//- (void)addRecipent
//{
//
//    Recipient *recipient = [[Recipient alloc] init];
//    recipient.firstName = @"David";
//    recipient.lastName = @"Henderson";
//    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    
//    [realm transactionWithBlock:^{
//        [realm addObject:recipient];
//    }];
//}

//- (void)goToAddRecipientView: (id)sender {
//    if (!self.recipientsArray) {
//        self.recipientsArray = [[NSMutableArray alloc] init];
//    }
//    [self performSegueWithIdentifier:@"addRecipientViewController" sender:self];
//}
//


//- (void)updateRecipient
//{
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm beginWriteTransaction];
//    recipient.lastName = @"Harrison";
//    [realm commitWriteTransaction];
//}

//- (void)linkToCelebration
//{
//    Recipient *recipient1 = [[Recipient alloc] init];
//    CelebrationRealm *celebration1 = [[CelebrationRealm alloc] init];
//    recipient1.firstName = @"Tim";
//    [recipient1.celebration1 addObject:celebration1];
//    
//    [realm transactionWithBlock:^{
//        [realm addObject:recipient1];
//    }];
//
//}


    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showAddRecipientView"])
//    {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        Recipient *recipient = self.recipientsArray[indexPath.row];
//        AddRecipientViewController *controller =(AddRecipientViewController *)[[segue destinationViewController] topViewController];
//        [controller setDetailItem:object];
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
//    }
//    
//}


@end
