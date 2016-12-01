//
//  CelebrationRealm.h
//  Celebrator
//
//  Created by Justine Herman on 11/28/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "ModelProtocols.h"

@interface CelebrationRealm : RLMObject

@property NSString *occasion;
@property NSDate *date;
@property Recipient *recipient;

@end

//RLM_ARRAY_TYPE(CelebrationRealm)
