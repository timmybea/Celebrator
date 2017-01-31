//
//  RecipientTableViewController.h
//  Celebrator
//
//  Created by Justine Herman on 11/29/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipientTableViewControllerProtocol.h"

@interface RecipientTableViewController : UITableViewController

@property (nonatomic, assign) id <RecipientTableViewControllerProtocol> delegate;

@end
