//
//  AddCelebrationViewController.h
//  Celebrator
//
//  Created by Tim Beals on 2016-11-29.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebrationRealm.h"

@interface AddCelebrationViewController : UIViewController

@property (nonatomic) Recipient *recipientModel;
@property (weak, nonatomic) IBOutlet UILabel *celebForNameLabel;

@end
