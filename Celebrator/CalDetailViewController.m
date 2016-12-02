//
//  CalDetailViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-28.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CalDetailViewController.h"
#import "CalendarDetailTableViewCell.h"
#import "Celebration.h"
#import "AddCelebrationViewController.h"

@interface CalDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *celebDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CelebrationRealm *celebrationRealm;
@property (strong, nonatomic) NSMutableArray *gifts;

@end

@implementation CalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
}

- (void)passCelebration:(CelebrationRealm *)celebration;
{
    self.celebrationRealm = celebration;
    self.label.text = self.celebrationRealm.occasion;
    NSLog(@"%@", self.celebrationRealm.occasion);
}

-(void)viewWillAppear:(BOOL)animated
{
    //add gift options
    self.gifts = [[NSMutableArray alloc] init];
    if(self.celebrationRealm.giveGift == YES)
    {
        [self.gifts addObject:@"Gift:"];
    }
    else if(self.celebrationRealm.giveCard == YES)
    {
        [self.gifts addObject:@"Card:"];
    }
    else if(self.celebrationRealm.makeCall == YES)
    {
        [self.gifts addObject:@"Call:"];
    }
    
    //set date information
//    self
}




//self.celebDateLabel;
//self.remindDateLabel;


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
    return self.gifts.count; //between zero and three
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalDetailCell"];
    cell.label.text = [self.gifts objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)editButtonPushed:(UIButton *)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RecipientBranch" bundle:nil];
    AddCelebrationViewController *vc = [sb instantiateViewControllerWithIdentifier:@"myViewController"]; //ADD TO REUSE ID
    [self presentViewController:vc animated:YES completion:NULL];
}

//UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"myViewController"];
//vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//[self presentViewController:vc animated:YES completion:NULL];
//
//[1:56]
//if u want to push pop within the confines of the nav view controller
//
//[1:56]
//ure looking for this
//
//[1:56]
//[self.navigationController popViewControllerAnimated: NO];
//[self.navigationController pushViewController: mevc animated: YES];
//
//[1:56]
//pop meaning get rid of.. push meaning put on top of the nav stack


@end
