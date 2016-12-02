//
//  CelebrationRealm.m
//  Celebrator
//
//  Created by Justine Herman on 11/28/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CelebrationRealm.h"

@implementation CelebrationRealm

+ (NSDictionary *)defaultPropertyValues {
    return @{@"primaryKey" : [[NSUUID UUID] UUIDString]};
}

+ (NSString *)primaryKey {
    return @"primaryKey";
}

@end

