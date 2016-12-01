//
//  CalendarViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-26.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CalendarViewController.h"
#import "Celebration.h"
#import "CalDetailViewController.h"

@interface CalendarViewController ()

@property (weak, nonatomic) IBOutlet UIView *tableViewContainer;

@property (strong, nonatomic) Celebration *currentCelebration;
@property (strong, nonatomic) NSMutableDictionary *celebrationsByDate;
@property (strong, nonatomic) NSDate *dateSelected;
@property (strong, nonatomic) NSLayoutConstraint *detailButtonHeight;
@property (strong, nonatomic) NSArray *celebrationsForDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeight;



- (void)createCelebrations;

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
    
    //setTableViewDisappear
    self.tableViewContainer.hidden = YES;
    
    // Generate celebration and store in dictionary
    [self createCelebrations];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarDetail:) name:@"segueCall" object:nil];
}


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
    
    // Your method to test if a date have an event for example
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
    self.tableViewContainer.hidden = YES;
    self.containerViewHeight.constant = 0;
    [self.view layoutIfNeeded];
    
    NSString *key = [[self dateFormatter] stringFromDate:dayView.date];
    if(self.celebrationsByDate[key])
    {
        NSDictionary *events = @{@"events": self.celebrationsByDate[key]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showEvents" object:self userInfo:events];
        
        self.celebrationsForDate = self.celebrationsByDate[key];
        self.tableViewContainer.hidden = NO;
        float animationHeight = self.celebrationsForDate.count * 40 + 5;
        [UIView animateWithDuration:0.3 animations:^(){
        self.containerViewHeight.constant = animationHeight;
        [self.view layoutIfNeeded];
        }];
    }
}

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
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:event.date];
        
        if(!self.celebrationsByDate[key])
        {
            self.celebrationsByDate[key] = [NSMutableArray new];
        }
        [self.celebrationsByDate[key] addObject:event];
    }
}

// Used only to have a key for _eventsByDate
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


- (void)calendarDetail:(NSNotification *)notification
{
    self.currentCelebration = [notification.userInfo valueForKey:@"CelebrationSegue"];
    [self performSegueWithIdentifier:@"celebrationCalDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CalDetailViewController *destination = segue.destinationViewController;
    self.delegate = destination;
    [self.delegate passCelebration:self.currentCelebration];
}

@end
