//
//  TempRecipient.m
//  Celebrator
//
//  Created by Tim Beals on 2016-12-11.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "TempRecipient.h"

@implementation TempRecipient

- (instancetype)initWithFirstName:(NSString *)firstName andDateOfBirth:(NSDate *)dob
{
    self = [super init];
    if(self)
    {
        _firstName = firstName;
        _dateOfBirth = dob;
    }
    return self;
}

@end
