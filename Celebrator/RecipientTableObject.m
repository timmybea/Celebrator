//
//  RecipientTableObject.m
//  Celebrator
//
//  Created by Tim Beals on 2017-01-30.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

#import "RecipientTableObject.h"

@implementation RecipientTableObject

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _recipients = [[NSMutableArray alloc] init];
    }
    return self;
}


@end
