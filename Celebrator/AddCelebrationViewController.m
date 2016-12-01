//
//  AddCelebrationViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-29.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "AddCelebrationViewController.h"
#import <Realm/Realm.h>
#import "ModelProtocols.h"
#import "CelebrationRealm.h"

@interface AddCelebrationViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *celebrationWarning;
@property (weak, nonatomic) IBOutlet UILabel *celebrationDateWarning;


@property (weak, nonatomic) IBOutlet UIView *centreForm;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) BOOL isDropDownBehind;

@property (weak, nonatomic) IBOutlet UITextField *celebMonthTF;
@property (weak, nonatomic) IBOutlet UITextField *celebDayTF;
@property (weak, nonatomic) IBOutlet UITextField *celebYearTF;

@property (strong, nonatomic) NSString *celebration;
@property (nonatomic) Recipient *recipient;

- (IBAction)saveButton:(UIButton *)sender;
@end

@implementation AddCelebrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
    
    [self.view insertSubview:self.containerView belowSubview:self.centreForm];
    self.isDropDownBehind = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewHierarchy:) name:@"dropDownClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCelebration:) name:@"celebrationSet" object:nil];
    
    self.celebrationWarning.hidden = YES;
    self.celebrationDateWarning.hidden = YES;
    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

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

- (IBAction)saveButton:(UIButton *)sender
{
    if([self.celebMonthTF hasText] && [self.celebDayTF hasText] && [self.celebYearTF hasText] && self.celebration)
    {
        RLMRealm *realm = [RLMRealm defaultRealm];
        CelebrationRealm *celebrationRealm = [[CelebrationRealm alloc] init];
        celebrationRealm.occasion = self.celebration;
        celebrationRealm.date = [NSDate date];
        celebrationRealm.recipient = self.recipientModel;
        
        [realm transactionWithBlock:^{
            [realm addObject:celebrationRealm];
        }];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
    else{
        self.celebrationWarning.hidden = NO;
        self.celebrationDateWarning.hidden = NO;
    } 
}

//receive the drop down selection as a string
- (void)updateCelebration:(NSNotification *)notification
{
    self.celebration = [notification.userInfo valueForKey:@"celebration"];
    NSLog(@"%@", self.celebration);
}

@end
