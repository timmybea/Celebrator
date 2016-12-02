//
//  CalendarViewController.h
//  Celebrator
//
//  Created by Tim Beals on 2016-11-26.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
#import "CalendarViewControllerDelegate.h"

@interface CalendarViewController : UIViewController <JTCalendarDelegate>

@property (weak, nonatomic) id<CalendarViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;

@end
