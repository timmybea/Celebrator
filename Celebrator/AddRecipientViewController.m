//
//  AddRecipientViewController.m
//  Celebrator
//
//  Created by Justine Herman on 11/26/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "AddRecipientViewController.h"

@interface AddRecipientViewController () <UITextFieldDelegate>

@end

@implementation AddRecipientViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

@end
