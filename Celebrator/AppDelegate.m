//
//  AppDelegate.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-26.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "AppDelegate.h"
@import UserNotifications;

@interface AppDelegate ()

@property(weak, nonatomic) id<UNUserNotificationCenterDelegate> delegate;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!error) {
                                  NSLog(@"request authorization succeeded!");
                                  //[self showAlert];
                              }
                          }];
    application.applicationIconBadgeNumber = 0;
    return YES;
}

//- (void)showAlert {
//    UIAlertController *objAlertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"show the alert" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK"
//                                                           style:UIAlertActionStyleCancel
//                                                         handler:^(UIAlertAction *action) {
//                                                        NSLog(@"Ok clicked!");
//                                   }];
//    [objAlertController addAction:cancelAction];
//    
//    
//    [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController] presentViewController:objAlertController animated:YES completion:^{
//        
//    }];
//    
//}

//Called when a notification is delivered to a foreground app.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}





@end
