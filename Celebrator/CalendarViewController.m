//
//  CalendarViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-26.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CalendarViewController.h"
#import "Celebration.h"
#import "CalendarTableViewCell.h"
#import "CalDetailViewController.h"
#import "CelebrationRealm.h"
#import <Realm/Realm.h>
#import "ModelProtocols.h"

@interface CalendarViewController () <UITableViewDelegate, UITableViewDataSource>

//tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Celebration *currentCelebration;
@property (strong, nonatomic) NSMutableDictionary *celebrationsByDate;

@property (strong, nonatomic) NSDate *dateSelected;
@property (strong, nonatomic) NSLayoutConstraint *detailButtonHeight;
@property (strong, nonatomic) NSArray *celebrationsForDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];

    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;

    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];

    self.celebrationsByDate = [[NSMutableDictionary alloc] init];
    //setTableViewDisappear
    self.tableView.hidden = YES;
    [self.view layoutIfNeeded];

    // Generate celebration and store in dictionary
    [self createCelebrations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


    [RLMRealm defaultRealm];
    RLMResults<CelebrationRealm *> *allCelebrations =[CelebrationRealm allObjects];
    for(CelebrationRealm *celebrationRealm in allCelebrations)

    {

        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:celebrationRealm.date];
        NSLog(@"COUNT: %@", key);

        if(!self.celebrationsByDate[key])
        {
            self.celebrationsByDate[key] = [NSMutableArray new];
        }
        [(NSMutableArray *)self.celebrationsByDate[key] addObject:celebrationRealm];
    }

    NSLog(@"ALL BOJECTS QUERY COUNT: %lu", allCelebrations.count);
    NSLog(@"CELEBRATION REALM COUNT:%lu", (unsigned long)self.celebrationsByDate.count);
    [self.calendarManager reload];
}

#pragma - calendar setup methods

//customize calendar view
- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
    return view;
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([self.calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }

    //method to test if a date has an event
    if([self haveCelebrationForDay:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor orangeColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

//Mark calendar with celebration
- (BOOL)haveCelebrationForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];

    if(self.celebrationsByDate[key] && [self.celebrationsByDate[key] count] > 0)
    {
        return YES;
    }
    return NO;
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(UIView<JTCalendarDay> *)dayView
{
    //reset label and view
    self.tableView.hidden = YES;
    self.tableViewHeight.constant = 0;
    [self.view layoutIfNeeded];

    NSString *key = [[self dateFormatter] stringFromDate:dayView.date];
    if(self.celebrationsByDate[key])
    {
        self.celebrationsForDate = self.celebrationsByDate[key];
        self.tableView.hidden = NO;
        float animationHeight = self.celebrationsForDate.count * 40 + 5;
        [UIView animateWithDuration:0.4 animations:^(){
        self.tableViewHeight.constant = animationHeight;
        [self.tableView reloadData];
        }];
    }
}

#pragma - make test data source methods

- (void)createCelebrations
{
    self.celebrationsByDate = [NSMutableDictionary new];

    //Make date and add to celebration
    NSDate *date = [[self dateFormatter] dateFromString:@"09-12-2016"];
    Celebration *celebration = [[Celebration alloc] initWithOccassion:@"Birthday" andDate:date];

    NSDate *date1 = [[self dateFormatter] dateFromString:@"09-12-2016"];
    Celebration *celebration1 = [[Celebration alloc] initWithOccassion:@"Wedding" andDate:date1];

    NSDate *date2 = [[self dateFormatter] dateFromString:@"08-12-2016"];
    Celebration *celebration2 = [[Celebration alloc] initWithOccassion:@"Anniversary" andDate:date2];

    NSArray *celebrations = [[NSArray alloc] initWithObjects:celebration, celebration1, celebration2, nil];

    for(Celebration *event in celebrations)
    {
        NSString *key = [[self dateFormatter] stringFromDate:event.date];

        if(!self.celebrationsByDate[key])
        {
            self.celebrationsByDate[key] = [NSMutableArray new];
        }
        [(NSMutableArray *)self.celebrationsByDate[key] addObject:event];
    }
}

// Used to have a key celebrationsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }

    return dateFormatter;
}

#pragma - table view delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.celebrationsForDate.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calCell"];
    Celebration *celebration = [self.celebrationsForDate objectAtIndex:indexPath.row];
    NSString *message = [NSString stringWithFormat:@"It is 'persons' %@ \n", celebration.occassion];
    cell.label.text = message;
    return cell;
}


//Segue to calendar detail
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentCelebration = [self.celebrationsForDate objectAtIndex:indexPath.row];
//    NSLog(@"Event: %@ SENT FROM TV", celebration);
    [self performSegueWithIdentifier:@"celebrationCalDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CalDetailViewController *destination = segue.destinationViewController;
    self.delegate = destination;
    [self.delegate passCelebration:self.currentCelebration];
}

@end
