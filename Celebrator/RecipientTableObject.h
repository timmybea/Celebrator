//
//  RecipientTableObject.h
//  Celebrator
//
//  Created by Tim Beals on 2017-01-30.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipientTableObject : NSObject

@property (nonatomic, strong) NSString *group;
@property (nonatomic, strong) NSMutableArray *recipients;

@end
