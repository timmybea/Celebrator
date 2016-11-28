//
//  CalendarViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-26.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CalendarViewController.h"
#import "Celebration.h"


@interface CalendarViewController () <FSCalendarDelegate, FSCalendarDataSource>

@property (weak, nonatomic) IBOutlet UIView *whiteView;

@property (strong, nonatomic) Celebration *celebration;
@property (strong, nonatomic) NSMutableDictionary *celebrationsByDate;
@property (strong, nonatomic) NSDate *dateSelected;
@property (strong, nonatomic) UIView *detailView;
@property (strong, nonatomic) NSLayoutConstraint *detailViewHeight;
//@property (weak, nonatomic) IBOutlet UILabel *celebrationLabel;


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
    
    //white view appearance
    self.whiteView.layer.cornerRadius = 10;
    self.whiteView.layer.masksToBounds = YES;

    self.detailView = [[UILabel alloc] initWithFrame:CGRectZero];
    self.detailView.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.detailView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailView
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1
                                                                         constant:-20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1
                                                                         constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailView                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeTopMargin
                                                                          multiplier:1
                                                                            constant:390]];
    
    self.detailViewHeight = [NSLayoutConstraint constraintWithItem:self.detailView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1
                                                         constant:0];
    
    [self.view addConstraint:self.detailViewHeight];
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
    
    if(self.celebrationsByDate[key] && [self.celebrationsByDate[key] count] > 0){
        return YES;
    }
    return NO;
}

//display celebration info at touch
- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(UIView<JTCalendarDay> *)dayView
{
        NSString *key = [[self dateFormatter] stringFromDate:dayView.date];
        if(self.celebrationsByDate[key])
        {
            NSMutableString *message = [NSMutableString string];
            NSArray *celebrationsForDate = self.celebrationsByDate[key];
            for (Celebration *celebration in celebrationsForDate)
            {
                [message appendString:[NSString stringWithFormat:@"It is 'persons' %@ \n", celebration.occassion]];
            }
            self.detailViewHeight.constant = 0;
            float animationHeight = celebrationsForDate.count * 60;
            [UIView animateWithDuration:2.0 animations:^(){
                self.detailViewHeight.constant = animationHeight;
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
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}


@end
