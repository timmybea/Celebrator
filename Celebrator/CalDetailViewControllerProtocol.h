//
//  CalDetailViewControllerProtocol.h
//  Gifter
//
//  Created by Tim Beals on 2016-12-03.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CelebrationRealm.h"

@protocol CalDetailViewControllerProtocol <NSObject>

- (void)updateCelebrationForEdit:(CelebrationRealm *)celebrationRealm;

@end
