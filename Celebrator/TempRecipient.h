//
//  TempRecipient.h
//  Celebrator
//
//  Created by Tim Beals on 2016-12-11.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempRecipient : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSDate *dateOfBirth;

- (instancetype)initWithFirstName:(NSString *)firstName andDateOfBirth:(NSDate *)dob;

@end
