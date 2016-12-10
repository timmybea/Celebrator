//
//  NotificationManager.m
//  Celebrator
//
//  Created by Justine Herman on 12/9/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "NotificationManager.h"
#import <UserNotifications/UserNotifications.h>

@implementation NotificationManager

- (void)scheduleNotification:(NSDate *)scheduleDate
{
    
//    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
//    content.title = [NSString localizedUserNotificationStringForKey:@"Reminder" arguments:nil];
//    content.body = [NSString localizedUserNotificationStringForKey:@"Reminder message"
//                                                         arguments:nil];
//    content.badge = @1;
//    content.sound = [UNNotificationSound defaultSound];
    
//    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//   // NSDate *date = [NSDate dateWithTimeIntervalSinceNow:3600];
//    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
//                                     components:NSCalendarUnitYear +
//                                     NSCalendarUnitMonth + NSCalendarUnitDay +
//                                     NSCalendarUnitHour + NSCalendarUnitMinute +
//                                     NSCalendarUnitSecond fromDate:date];
//    
    
//    UNNotificationAction *snoozeAction = [UNNotificationAction actionWithIdentifier:@"Snooze"
//                                                                              title:@"Snooze" options:UNNotificationActionOptionNone];
//    UNNotificationAction *deleteAction = [UNNotificationAction actionWithIdentifier:@"Delete"
//                                                                              title:@"Delete" options:UNNotificationActionOptionDestructive];
//    
//    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"ReminderCategory"
//                                                                              actions:@[snoozeAction,deleteAction] intentIdentifiers:@[]
//                                                                              options:UNNotificationCategoryOptionNone];
  
   // [center setNotificationCategories:[NSSet setWithObjects:category, nil]];
  
    
}



@end
