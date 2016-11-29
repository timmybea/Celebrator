//
//  Recipient.m
//  Celebrator
//
//  Created by Justine Herman on 11/28/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "Recipient.h"

@implementation Recipient

- (void)createRecipient {
    Recipient *recipient1 = [[Recipient alloc] init];
    recipient1.firstName = @"John";
    recipient1.lastName = @"Smith";
//  recipient1.birthday = @4/08/1975;
    NSLog(@"First recipient: %@", recipient1.firstName);
}


+ (NSArray *)requiredProperties {
    return @[@"firstName", @"lastName"];
}


@end




