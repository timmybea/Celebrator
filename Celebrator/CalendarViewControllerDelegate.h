//
//  CalendarViewControllerDelegate.h
//  Celebrator
//
//  Created by Tim Beals on 2016-11-28.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CelebrationRealm.h"

@protocol CalendarViewControllerDelegate <NSObject>

- (void)passCelebration:(CelebrationRealm *)celebration;

@end
