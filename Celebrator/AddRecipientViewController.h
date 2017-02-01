//
//  AddRecipientViewController.h
//  Celebrator
//
//  Created by Justine Herman on 11/26/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebrationViewControllerDelegate.h"
#import "RecipientTableViewControllerProtocol.h"
#import "CalDetailViewControllerProtocol.h"

@interface AddRecipientViewController : UIViewController <CelebrationViewControllerDelegate, RecipientTableViewControllerProtocol>

@property (nonatomic, assign) id <CalDetailViewControllerProtocol> delegate;

@end
