//
//  AddCelebrationViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-29.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "AddCelebrationViewController.h"

@interface AddCelebrationViewController ()

@property (weak, nonatomic) IBOutlet UIView *centreForm;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation AddCelebrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.containerView belowSubview:self.centreForm];
}



@end
