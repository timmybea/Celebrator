//
//  Recipient.h
//  Celebrator
//
//  Created by Justine Herman on 11/28/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "ModelProtocols.h"

@interface Recipient : RLMObject

@property NSString *firstName;
@property NSString *lastName;
@property NSDate *birthdate;
@property RLMArray<CelebrationRealm> *celebrations;
@property NSString *group;

@end

//RLM_ARRAY_TYPE(Recipient)
