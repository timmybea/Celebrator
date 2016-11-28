//
//  CalendarViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-26.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CalendarViewController.h"
#import "Celebration.h"

@interface CalendarViewController () 

@property (strong, nonatomic) Celebration *celebration;
@property (strong, nonatomic) NSMutableDictionary *celebrationsByDate;
@property (strong, nonatomic) NSDate *dateSelected;


@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    // Generate celebration and store in dictionary
    [self createCelebrations];
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
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    //*****
    // Selected date
    else if(self.dateSelected && [self.calendarManager.dateHelper date:self.dateSelected isTheSameDayThan:dayView.date]){
        
        NSLog(@"FOO!");
        
        
        
//        dayView.circleView.hidden = NO;
//        dayView.circleView.backgroundColor = [UIColor redColor];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    // Another day of the current month
    else
    {
        
       // NSLog(@"BAR!");

//        dayView.circleView.hidden = YES;
//        dayView.dotView.backgroundColor = [UIColor redColor];
//        dayView.textLabel.textColor = [UIColor blackColor];
    }
    //*****
    
    // Your method to test if a date have an event for example
    if([self haveCelebrationForDay:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
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
    
    if(_celebrationsByDate[key] && [_celebrationsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}

- (void)createCelebrations
{
    self.celebrationsByDate = [NSMutableDictionary new];
    
    //Make date and add to celebration
    NSDate *date = [[self dateFormatter] dateFromString:@"09-12-2016"];
    Celebration *celebration = [[Celebration alloc] initWithOccassion:@"Birthday" andDate:date];
    
    // Use the date as key for eventsByDate
    NSString *key = [[self dateFormatter] stringFromDate:celebration.date];
    
    if(!self.celebrationsByDate[key])
    {
        self.celebrationsByDate[key] = [NSMutableArray new];
    }
    
    [self.celebrationsByDate[key] addObject:celebration];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}


@end
