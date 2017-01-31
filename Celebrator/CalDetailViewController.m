//
//  CalDetailViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-28.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CalDetailViewController.h"
#import "CalendarDetailTableViewCell.h"
#import "AddCelebrationViewController.h"

@interface CalDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *celebDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CelebrationRealm *celebrationRealm;
@property (strong, nonatomic) NSMutableArray *gifts;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;


@end

@implementation CalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
}

#pragma  - setup methods

- (void)passCelebration:(CelebrationRealm *)celebration;
{
    self.celebrationRealm = celebration;
    self.titleLabel.text = self.celebrationRealm.occasion;
    NSLog(@"%@", self.celebrationRealm.occasion);
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupGiftsArray];
    [self setupLabels];
    [self setupMainlabel];
}


- (void)setupMainlabel
{
    NSString *message = [NSString stringWithFormat:@"%@ for %@", self.celebrationRealm.occasion, self.celebrationRealm.recipient.firstName];
    self.titleLabel.text = [message uppercaseString];
}

- (void)setupGiftsArray
{
    //add gift options
    self.gifts = [[NSMutableArray alloc] init];
    if(self.celebrationRealm.giveGift == YES)
    {
        [self.gifts addObject:@"Gift:"];
    }

    if(self.celebrationRealm.giveCard == YES)
    {
        [self.gifts addObject:@"Card:"];
    }

    if(self.celebrationRealm.makeCall == YES)
    {
        [self.gifts addObject:@"Call:"];
    }

    self.tableHeight.constant = (self.gifts.count * 44);
}

- (void)setupLabels
{
    //set date labels
    self.celebDateLabel.text = [self.dateFormatter stringFromDate:self.celebrationRealm.date];
    if(self.celebrationRealm.reminderDate)
    {
        self.remindDateLabel.text = [self.remindDateFormatter stringFromDate:self.celebrationRealm.reminderDate];
    }
    else
    {
        self.remindDateLabel.text = @"No reminder set";
    }
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMM dd, yyyy";
    }
    return dateFormatter;
}

- (NSDateFormatter *)remindDateFormatter
{
    static NSDateFormatter *remindDateFormatter;
    if(!remindDateFormatter)
    {
        remindDateFormatter = [NSDateFormatter new];
        remindDateFormatter.dateFormat = @"MMM dd, yyyy h:mm a";
    }
    
    return remindDateFormatter;
}

#pragma - tableview delegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gifts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalDetailCell"];
    NSString *action = [self.gifts objectAtIndex:indexPath.row];
    
    if ([action isEqualToString: @"Gift:"]) {
        if (self.celebrationRealm.isGiftDone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if ([action isEqualToString:@"Card:"]) {
        if (self.celebrationRealm.isCardDone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if ([action isEqualToString:@"Call:"]) {
        if (self.celebrationRealm.isCallDone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    cell.label.text = action;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CalendarDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *action = [self.gifts objectAtIndex:indexPath.row];
    if ([action isEqualToString: @"Gift:"]) {
        if (self.celebrationRealm.isGiftDone == NO) {
            self.celebrationRealm.isGiftDone = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            self.celebrationRealm.isGiftDone = NO;
            cell.accessoryType = NO;
        }
    } else if ([action isEqualToString:@"Card:"]) {
        if (self.celebrationRealm.isCardDone == NO) {
            self.celebrationRealm.isCardDone = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            self.celebrationRealm.isCardDone = NO;
            cell.accessoryType = NO;
        }
    } else if ([action isEqualToString:@"Call:"]){
        if (self.celebrationRealm.isCallDone == NO) {
            self.celebrationRealm.isCallDone = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            self.celebrationRealm.isCallDone = NO;
            cell.accessoryType = NO;
            
        }
    }
    [realm commitWriteTransaction];
}

#pragma segue method
- (IBAction)editButtonPushed:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RecipientBranch" bundle:nil];
    AddCelebrationViewController *destination = [storyboard instantiateViewControllerWithIdentifier:@"recipientViewController"];
    [[self navigationController] pushViewController:destination animated:YES];
    self.delegate = destination;
    [self.delegate updateCelebrationForEdit:self.celebrationRealm];
}


@end
