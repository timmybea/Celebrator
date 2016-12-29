//
//  CalendarDetailTableViewCell.h
//  Celebrator
//
//  Created by Tim Beals on 2016-12-01.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorManager.h"

@interface CalendarDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) ColorManager *colorManager;

@end
