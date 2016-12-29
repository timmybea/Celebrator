//
//  ColorManager.m
//  Celebrator
//
//  Created by Justine Herman on 12/6/16.
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
        _golden = [UIColor colorWithRed:(238/255.0) green:(198/255.0) blue:(67/255.0) alpha:1];
        _brightCoral = [UIColor colorWithRed:(235/255.0) green:(81/255.0) blue:(96/255.0) alpha:1];
        _aquaMarine = [UIColor colorWithRed:(2/255.0) green:(200/255.0) blue:(167/255.0) alpha:1];
    }
    return self;
}

@end
