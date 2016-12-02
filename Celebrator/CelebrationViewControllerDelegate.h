//
//  CelebrationViewControllerDelegate.h
//  Celebrator
//
//  Created by Justine Herman on 12/1/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CelebrationRealm.h"

@protocol CelebrationViewControllerDelegate <NSObject>

- (void)passCelebrationToRecipient:(CelebrationRealm *)celebration;

@end


