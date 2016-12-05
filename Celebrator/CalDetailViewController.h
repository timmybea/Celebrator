//
//  CalDetailViewController.h
//  Celebrator
//
//  Created by Tim Beals on 2016-11-28.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewControllerDelegate.h"
#import "CalDetailViewControllerProtocol.h"

@interface CalDetailViewController : UIViewController <CalendarViewControllerDelegate>

@property (nonatomic, assign) id <CalDetailViewControllerProtocol> delegate;

@end
