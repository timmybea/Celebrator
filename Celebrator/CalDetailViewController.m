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

    NSLog(@"%@", self.celebrationRealm.occasion);
    NSLog(@"%@", self.celebrationRealm.date);
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

    self.tableHeight.constant = (self.gifts.count * 40 + 3);
}

- (void)setupLabels
{
    //set date labels
    self.celebDateLabel.text = [[self dateFormatter] stringFromDate:self.celebrationRealm.date];
    if(self.celebrationRealm.reminderDate)
    {
        self.remindDateLabel.text = [[self dateFormatter] stringFromDate:self.celebrationRealm.reminderDate];
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
        dateFormatter.dateFormat = @"MM-dd-yyyy";
    }

    return dateFormatter;
}

#pragma - tableview delegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gifts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalDetailCell"];
    cell.label.text = [self.gifts objectAtIndex:indexPath.row];
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

#pragma segue method
- (IBAction)editButtonPushed:(UIButton *)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RecipientBranch" bundle:nil];
    AddCelebrationViewController *vc = [sb instantiateViewControllerWithIdentifier:@"recipientViewController"];
    [[self navigationController] pushViewController:vc animated:YES];
    vc.celebrationRealm = self.celebrationRealm;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"addCelebration"])
//    {
//        AddCelebrationViewController *controller = (AddCelebrationViewController* )segue.destinationViewController;
//        NSString *name = self.firstNameTextField.text;
//        controller.recipientName = name;
//        
//        controller.delegate = self;
//        
//    }
//}


@end
