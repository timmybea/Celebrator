//
//  FBAddRecipientTableView.m
//  Celebrator
//
//  Created by Justine Herman on 11/26/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "FBAddRecipientTableView.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FBAddRecipientTableView ()

@end

@implementation FBAddRecipientTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
