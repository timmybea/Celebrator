//
//  RecipientTableViewCell.h
//  Celebrator
//
//  Created by Justine Herman on 12/1/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebrationRealm.h"

@interface RecipientTableViewCell : UITableViewCell

- (void)displayData:(CelebrationRealm *)celebration;

@end
