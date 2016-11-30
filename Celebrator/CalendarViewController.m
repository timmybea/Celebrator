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
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (strong, nonatomic) Celebration *celebration;
@property (strong, nonatomic) NSMutableDictionary *celebrationsByDate;
@property (strong, nonatomic) NSDate *dateSelected;
@property (strong, nonatomic) UIButton *detailButton;
@property (strong, nonatomic) NSLayoutConstraint *detailButtonHeight;
@property (strong, nonatomic) NSArray *celebrationsForDate;

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
    
    // Generate celebration and store in dictionary
    [self createCelebrations];
    
    //white view appearance
    self.whiteView.layer.cornerRadius = 10;
    self.whiteView.layer.masksToBounds = YES;
    
    
    //[self.detailButton setExclusiveTouch:YES];
    self.detailButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.detailButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailButton.backgroundColor = [UIColor orangeColor];
    
    //detail view appearance
    [self.detailButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view insertSubview:self.detailButton belowSubview:self.detailLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailButton
                                                                        attribute:NSLayoutAttributeRight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeRight
                                                                       multiplier:1
                                                                         constant:-20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailButton
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1
                                                                         constant:20]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.detailButton                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.calendarContentView
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1
                                                                            constant:0]];
    
    self.detailButtonHeight = [NSLayoutConstraint constraintWithItem:self.detailButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1
                                                         constant:0];
    
    [self.view addConstraint:self.detailButtonHeight];
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
    //reset label and view
    self.detailLabel.text = @"";
    self.detailButtonHeight.constant = 0;
    [self.view layoutIfNeeded];
    
    NSString *key = [[self dateFormatter] stringFromDate:dayView.date];
    if(self.celebrationsByDate[key])
    {
        NSMutableString *message = [NSMutableString string];
        self.celebrationsForDate = self.celebrationsByDate[key];
        for (Celebration *celebration in self.celebrationsForDate)
            {
                [message appendString:[NSString stringWithFormat:@"It is 'persons' %@ \n", celebration.occassion]];
            }
            
        float animationHeight = self.celebrationsForDate.count * 20 + 25;
        [UIView animateWithDuration:0.3 animations:^(){
        self.detailButtonHeight.constant = animationHeight;
        [self.view layoutIfNeeded];
        }];
        [self performSelector:@selector(updateDetailLabel:) withObject:message afterDelay:0.3];
    }
}

- (void)updateDetailLabel: (NSString *)message
{
    self.detailLabel.text = message;
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

//button clicked perform segue
-(void) buttonClicked:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"celebrationCalDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CalDetailViewController *destination = segue.destinationViewController;
    self.delegate = destination;
    [self.delegate passCelebrationsArray:self.celebrationsForDate];
}



@end
