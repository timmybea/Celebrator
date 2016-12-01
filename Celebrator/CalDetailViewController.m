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

@interface CalDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) Celebration *celebration;
@property (weak, nonatomic) IBOutlet UILabel *celebDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindDateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation CalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
}

- (void)passCelebration:(Celebration *)celebration;
{
    self.celebration = celebration;
    self.label.text = celebration.occassion;
    NSLog(@"%@", celebration.occassion);
}

#pragma - tableview delegate methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3; //between zero and three
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalDetailCell"];
    cell.label.text = @"HELLO";
    return cell;
}




@end
