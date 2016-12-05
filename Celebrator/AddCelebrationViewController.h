//
//  AddCelebrationViewController.h
//  Celebrator
//
//  Created by Tim Beals on 2016-11-29.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebrationRealm.h"
#import "CelebrationViewControllerDelegate.h"
#import "CalDetailViewControllerProtocol.h"

@interface AddCelebrationViewController : UIViewController <CalDetailViewControllerProtocol>

@property (nonatomic, assign) id <CelebrationViewControllerDelegate> delegate;
@property (nonatomic) NSString *recipientName;
@property (weak, nonatomic) IBOutlet UILabel *celebForNameLabel;
@property (nonatomic) CelebrationRealm *celebrationRealm;

@end
