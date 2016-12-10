//
//  ColorManager.m
//  Gifter
//
//  Created by Tim Beals on 2016-12-03.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _sky = [UIColor colorWithRed:(124/255.0) green:(216/255.0) blue:(213/255.0) alpha:1];
        _golden = [UIColor colorWithRed:(249/255.0) green:(190/255.0) blue:(2/255.0) alpha:1];
        _brightCoral = [UIColor colorWithRed:(245/255.0) green:(50/255.0) blue:(64/255.0) alpha:1];
        _aquaMarine = [UIColor colorWithRed:(2/255.0) green:(200/255.0) blue:(167/255.0) alpha:1];
    }
    return self;
}

@end
