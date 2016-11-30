//
//  AddCelebrationViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-29.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "AddCelebrationViewController.h"

@interface AddCelebrationViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *centreForm;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) BOOL isDropDownBehind;

@end

@implementation AddCelebrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.containerView belowSubview:self.centreForm];
    self.isDropDownBehind = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewHierarchy:) name:@"dropDownClicked" object:nil];
    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

//- (void) textFieldDidEndEditing:(UITextField *)textField {
//    [textField resignFirstResponder];
//}
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)changeViewHierarchy:(NSNotification *)notification
{
    if(self.isDropDownBehind)
    {
        [self.view insertSubview:self.centreForm belowSubview:self.containerView];
        self.isDropDownBehind = NO;
    }
    else
    {
        [self.view insertSubview:self.containerView belowSubview:self.centreForm];
        self.isDropDownBehind = YES;
    }
    
    
    
    
}


@end
