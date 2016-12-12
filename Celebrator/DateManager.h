//
//  DateManager.h
//  Celebrator
//
//  Created by Tim Beals on 2016-12-07.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateManager : NSObject

+ (NSString *)separateYearFromDate:(NSDate *)date;
+ (NSString *)separateMonthFromDate:(NSDate *)date;
+ (NSString *)separateDayFromDate:(NSDate *)date;
+ (NSDate *)nextBirthdayFromDOB:(NSDate *)dob;
+ (NSDate *)getHolidayDate:(NSString *)holiday;

@end
