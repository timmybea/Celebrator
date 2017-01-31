//
//  DateManager.m
//  Celebrator
//
//  Created by Tim Beals on 2016-12-07.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "DateManager.h"

@implementation DateManager

+ (NSString *)separateYearFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:date];
}

+ (NSString *)separateMonthFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    return [formatter stringFromDate:date];
}


+ (NSString *)separateDayFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    return [formatter stringFromDate:date];
}

+ (NSDate *)nextBirthdayFromDOB:(NSDate *)dob
{
    // Break dob into components and change to current year
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *currentComps = [cal components:NSCalendarUnitYear fromDate:now];
    NSDateComponents *birthdayComps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:dob];
    birthdayComps.year = currentComps.year;
    
    // Create date from modified components
    NSDate *birthdayDate = [cal dateFromComponents:birthdayComps];
    
    // Check to see if birthday has passed this year and if so, add one year
    if ([now compare:birthdayDate] == NSOrderedDescending)
    {
        NSDateComponents *thisYear = [NSDateComponents new];
        thisYear.year = 1;
        birthdayDate = [cal dateByAddingComponents:thisYear toDate:birthdayDate options:0];
    }
    
    return birthdayDate;
}

+ (NSDate *)getHolidayDate:(NSString *)holiday
{
    //Future goal: users select country and important dates are accessed via API
    //Create holiday dates
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    NSString *valentinesDayString = @"14-02-2017";
    NSDate *valentinesDay = [dateFormatter dateFromString:valentinesDayString];
    NSString *mothersDayString = @"14-05-2017";
    NSDate *mothersDay = [dateFormatter dateFromString:mothersDayString];
    NSString *fathersDayString = @"18-06-2017";
    NSDate *fathersDay = [dateFormatter dateFromString:fathersDayString];
    NSString *christmasString = @"25-12-2016";
    NSDate *christmas = [dateFormatter dateFromString:christmasString];
    
    NSDictionary *holidays = @{
                               @"Valentine's Day": valentinesDay,
                               @"Mother's Day": mothersDay,
                               @"Father's Day": fathersDay,
                               @"Christmas": christmas
                               };
    
    return [holidays objectForKey:holiday];
}

@end
