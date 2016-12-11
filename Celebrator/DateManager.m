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

+ (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"MM-dd-yyyy";
    }
    
    return dateFormatter;
}


+ (NSDate *)nextBirthdayFromDOB:(NSDate *)dob
{
    //
    //NSString *birthdayString        = @"02/29/1980";
    //
    //// Convert the string to a NSDate
    //NSDateFormatter *formatter      = [NSDateFormatter new];
    //formatter.timeZone              = [NSTimeZone timeZoneWithName:@"UTC"];
    //formatter.dateFormat            = @"MM/dd/yyyy";
    //NSDate *birthday                = [formatter dateFromString:birthdayString];
    //
    
    // Break dob into components and change to current year
    NSCalendar *cal = [NSCalendar currentCalendar];
    cal.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
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

@end
