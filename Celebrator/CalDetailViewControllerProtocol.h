//
//  CalDetailViewControllerProtocol.h
//  Celebrator
//
//  Created by Justine Herman on 12/6/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CelebrationRealm.h"

@protocol CalDetailViewControllerProtocol <NSObject>

- (void)updateCelebrationForEdit:(CelebrationRealm *)celebrationRealm;

@end

