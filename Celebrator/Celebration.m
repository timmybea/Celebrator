//
//  Celebration.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-26.
//  Copyright © 2016 Tim Beals. All rights reserved.
//
// !!A temporary class to figure out how to add events to the calendar view!!

#import "Celebration.h"

@interface Celebration ()



@end


@implementation Celebration

- (instancetype)initWithOccassion:(NSString *)occassion andDate:(NSDate *)date
{
    self = [super init];
    if(self)
    {
        _occassion = occassion;
        _date = date;
    }
    return self;
}

@end
