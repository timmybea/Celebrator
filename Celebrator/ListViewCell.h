//
//  ListViewCell.h
//  Celebrator
//
//  Created by Justine Herman on 11/29/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebrationRealm.h"

@interface ListViewCell : UITableViewCell

- (void)configureCellWithCelebration:(CelebrationRealm *)celebration;

@end
