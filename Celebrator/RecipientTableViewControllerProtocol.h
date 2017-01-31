//
//  RecipientTableViewControllerProtocol.h
//  Celebrator
//
//  Created by Tim Beals on 2017-01-31.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipient.h"

@protocol RecipientTableViewControllerProtocol <NSObject>

- (void)updateAddRecipientForEdit:(Recipient *)recipient;

@end
