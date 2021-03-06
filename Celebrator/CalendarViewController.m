//
//  CalendarViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-26.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarTableViewCell.h"
#import "CalDetailViewController.h"
#import "CelebrationRealm.h"
#import <Realm/Realm.h>
#import "ModelProtocols.h"
#import "ColorManager.h"

@interface CalendarViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CelebrationRealm *currentCelebration;
@property (strong, nonatomic) NSMutableDictionary *celebrationsByDate;
@property (strong, nonatomic) NSDate *dateSelected;
@property (strong, nonatomic) NSLayoutConstraint *detailButtonHeight;
@property (strong, nonatomic) NSArray *celebrationsForDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) ColorManager *colorManager;

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

    self.tableView.hidden = YES;
    [self.view layoutIfNeeded];
    self.colorManager = [[ColorManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self queryCelebrations];
    [self.calendarManager reload];
}


#pragma - query celebrations and update calendar view

- (void)queryCelebrations {
    self.celebrationsByDate = [[NSMutableDictionary alloc] init];
    RLMResults<CelebrationRealm *> *allCelebrations =[CelebrationRealm allObjects];
    for(CelebrationRealm *celebrationRealm in allCelebrations)
    {
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:celebrationRealm.date];
        if(!self.celebrationsByDate[key])
        {
            self.celebrationsByDate[key] = [NSMutableArray new];
        }
        
        // Check if celebrationRealm is already in the array for date
        BOOL isCelebrationInArray = NO;
        for(CelebrationRealm *celebration in (NSMutableArray *)self.celebrationsByDate[key])
        {
            if([celebrationRealm.primaryKey isEqualToString: celebration.primaryKey])
            {
                isCelebrationInArray = YES;
                break;
            }
        }
        
        if(!isCelebrationInArray)
        {
            [(NSMutableArray *)self.celebrationsByDate[key] addObject:celebrationRealm];
        }
    }
    [self.calendarManager reload];
}

#pragma - calendar setup methods

//customize calendar view
- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:14];
    return view;
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    //*** LOOK INTO THIS
    dayView.hidden = NO;
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    if([self.calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = self.colorManager.brightCoral;
        dayView.textLabel.textColor = [UIColor whiteColor];
    } else {
        dayView.dotView.hidden = YES;
        dayView.circleView.hidden = YES;
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    //method to test if a date has an event
    if([self haveCelebrationForDay:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = self.colorManager.golden;
        dayView.textLabel.textColor = [UIColor blackColor];
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
        float animationHeight = self.celebrationsForDate.count * 40;
        [UIView animateWithDuration:0.4 animations:^(){
        self.tableViewHeight.constant = animationHeight;
        [self.tableView reloadData];
        }];
    }
}

#pragma - make test data source methods

// Used to have a key celebrationsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        //dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
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
    CelebrationRealm *celebration = [self.celebrationsForDate objectAtIndex:indexPath.row];
    NSString *message = [NSString stringWithFormat:@"%@ %@ - %@ \n", celebration.recipient.firstName, celebration.recipient.lastName, celebration.occasion];
    cell.label.text = message;
    cell.label.textColor = UIColor.whiteColor;
    return cell;
}

//Segue to calendar detail
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentCelebration = [self.celebrationsForDate objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"celebrationCalDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CalDetailViewController *destination = segue.destinationViewController;
    self.delegate = destination;
    [self.delegate passCelebration:self.currentCelebration];
}

@end
