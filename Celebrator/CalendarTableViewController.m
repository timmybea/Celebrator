//
//  CalendarTableViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-30.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CalendarTableViewController.h"
#import "Celebration.h"
#import "CalendarTableViewCell.h"

@interface CalendarTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *eventsData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CalendarTableViewController
//NO LONGER USING!!! DELETE!!!!!!!!!!!!!
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEventsData:) name:@"showEvents" object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventsData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calCell"];
    Celebration *celebration = [self.eventsData objectAtIndex:indexPath.row];
    NSString *message = [NSString stringWithFormat:@"It is 'persons' %@ \n", celebration.occassion];
    cell.label.text = message;
    return cell;
}

- (void)updateEventsData:(NSNotification *)notification
{
    self.eventsData = [notification.userInfo valueForKey:@"events"];
    [self.tableView reloadData];
}


//signal parent view controller to segue to detail view controller
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *celebration = @{@"CelebrationSegue": self.eventsData[indexPath.row]};
    NSLog(@"Event: %@ SENT FROM TV", self.eventsData[indexPath.row]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"segueCall" object:self userInfo:celebration];
}

@end
