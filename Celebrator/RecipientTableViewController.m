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
#import "CelebrationRealm.h"
#import "RecipientListCell.h"
#import "RecipientTableObject.h"
#import "ColorManager.h"
#import "AddRecipientViewController.h"

@interface RecipientTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *recipientTableObjects;

@end

@implementation RecipientTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self fetchAllCelebrations];
    
}

- (void)fetchAllCelebrations
{
    RLMResults<Recipient*> *recipientArray = [Recipient allObjects];
    recipientArray = [recipientArray sortedResultsUsingProperty:@"lastName" ascending:YES];
    recipientArray = [recipientArray sortedResultsUsingProperty:@"group" ascending:YES];
    self.recipientTableObjects = [[NSMutableArray alloc] init];

    RecipientTableObject *newObject = [[RecipientTableObject alloc] init];
    
    for (Recipient *recipient in recipientArray) {
        NSString *group = recipient.group;
        
        if (newObject.group == nil) {
            newObject.group = group;
            [newObject.recipients addObject:recipient];
        } else if ([newObject.group isEqualToString:group]) {
            [newObject.recipients addObject:recipient];
        } else {
            [self.recipientTableObjects addObject:newObject];
            newObject = [[RecipientTableObject alloc] init];
            newObject.group = group;
            [newObject.recipients addObject:recipient];
        }
    }
    [self.recipientTableObjects addObject:newObject];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.recipientTableObjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    RecipientTableObject *object = [self.recipientTableObjects objectAtIndex:section];
    return object.recipients.count;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    ColorManager *colorManager = [[ColorManager alloc] init];
    view.backgroundColor = colorManager.aquaMarine;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    
    NSLayoutConstraint *labelLeading = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
    NSLayoutConstraint *labelTrailing = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    NSLayoutConstraint *labelheight = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    [view addConstraint:labelLeading];
    [view addConstraint:labelTrailing];
    [view addConstraint:labelheight];
    
    RecipientTableObject *object = [self.recipientTableObjects objectAtIndex:section];
    label.text = object.group;
    label.textColor = [UIColor whiteColor];
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    RecipientTableObject *object = [self.recipientTableObjects objectAtIndex:section];
    return object.group;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipientListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipientListCell" forIndexPath:indexPath];
    RecipientTableObject *object = [self.recipientTableObjects objectAtIndex:indexPath.section];
    Recipient *recipient = [object.recipients objectAtIndex:indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@ %@", recipient.firstName, recipient.lastName];
    cell.recipientLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[RLMRealm defaultRealm] beginWriteTransaction];
        RecipientTableObject *object = [self.recipientTableObjects objectAtIndex:indexPath.section];
        Recipient *recip = [object.recipients objectAtIndex:indexPath.row];
        
        
        while (recip.celebrations.count > 0){
            CelebrationRealm *celebration = recip.celebrations.firstObject;
            [recip.celebrations removeObjectAtIndex:0];
            [[RLMRealm defaultRealm]deleteObject:celebration];
        }
        
        [[RLMRealm defaultRealm]deleteObject:recip];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        [self fetchAllCelebrations];
        tableView.reloadData;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RecipientBranch" bundle:nil];
    AddRecipientViewController *destination = [storyboard instantiateViewControllerWithIdentifier:@"AddRecipientVC"];
    [[self navigationController] pushViewController:destination animated:YES];
    
    RecipientTableObject *object = [self.recipientTableObjects objectAtIndex:indexPath.section];
    Recipient *recip = [object.recipients objectAtIndex:indexPath.row];
    
    self.delegate = destination;
    [self.delegate updateAddRecipientForEdit:recip];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


@end
