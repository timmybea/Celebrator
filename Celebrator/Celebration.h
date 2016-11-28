//
//  Celebration.h
//  Celebrator
//
//  Created by Tim Beals on 2016-11-26.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Celebration : NSObject

@property (strong, nonatomic) NSString *occassion;
@property (strong, nonatomic) NSDate *date;

- (instancetype)initWithOccassion:(NSString *)occassion andDate:(NSDate *)date;

@end
