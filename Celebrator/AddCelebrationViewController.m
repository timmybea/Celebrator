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
#import "Recipient.h"
#import "CalDetailViewController.h"

@interface AddCelebrationViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *celebrationWarning;
@property (weak, nonatomic) IBOutlet UILabel *celebrationDateWarning;
@property (weak, nonatomic) IBOutlet UIView *centreForm;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) BOOL isDropDownBehind;

@property (weak, nonatomic) IBOutlet UITextField *celebMonthTF;
@property (weak, nonatomic) IBOutlet UITextField *celebDayTF;
@property (weak, nonatomic) IBOutlet UITextField *celebYearTF;
@property (weak, nonatomic) IBOutlet UISwitch *giveGiftSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *giveCardSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *makeCallSwitch;
@property (weak, nonatomic) IBOutlet UITextField *celebReminderMonthTF;
@property (weak, nonatomic) IBOutlet UITextField *celebReminderDayTF;
@property (weak, nonatomic) IBOutlet UITextField *celebReminderYearTF;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSString *stringOccasion;
@property (strong, nonatomic) Recipient *recipient;
@property (nonatomic) BOOL isEditMode;

- (IBAction)saveButton:(UIButton *)sender;
@end

@implementation AddCelebrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
    
    if(self.isEditMode)
    {
        [self setupEditView];
    }
    else
    {
        self.celebForNameLabel.text = [[NSString stringWithFormat:@"CELEBRATION FOR %@", self.recipientName] uppercaseString];
    }
    
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

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MM-dd-yyyy";
    }

    return dateFormatter;
}

- (IBAction)saveButton:(UIButton *)sender
{
    if([self.celebMonthTF hasText] && [self.celebDayTF hasText] && [self.celebYearTF hasText] && self.stringOccasion)
    {
//        RLMRealm *realm = [RLMRealm defaultRealm];
        CelebrationRealm *celebrationRealm = [[CelebrationRealm alloc] init];
        celebrationRealm.recipient = self.recipient;
        celebrationRealm.occasion = self.stringOccasion;
        NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", self.celebMonthTF.text, self.celebDayTF.text, self.celebYearTF.text];
        celebrationRealm.date = [self.dateFormatter dateFromString:dateString];
        celebrationRealm.giveCard = self.giveCardSwitch.on;
        celebrationRealm.giveGift = self.giveGiftSwitch.on;
        celebrationRealm.makeCall = self.makeCallSwitch.on;
        
        NSDate *pickerDate = [self.datePicker date];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = pickerDate;
     
        celebrationRealm.occasion = self.stringOccasion;
        localNotification.alertAction = @"Show item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        [self dismissViewControllerAnimated:YES completion:nil];
        
//        NSString *reminderDateString = [NSString stringWithFormat:@"%@-%@-%@", self.celebReminderMonthTF.text, self.celebReminderDayTF.text, self.celebReminderYearTF.text];
//        celebrationRealm.reminderDate = [self.dateFormatter dateFromString:reminderDateString];
        [self.delegate passCelebrationToRecipient:celebrationRealm];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        self.celebrationWarning.hidden = NO;
        self.celebrationDateWarning.hidden = NO;
    }
}

//receive the drop down selection as a string
- (void)updateCelebration:(NSNotification *)notification
{
    self.stringOccasion = [notification.userInfo valueForKey:@"celebration"];
}


#pragma - edit mode methods

//CalDetail delegation method for edit
-(void)updateCelebrationForEdit:(CelebrationRealm *)celebrationRealm
{
    self.isEditMode = YES;
    self.celebrationRealm = celebrationRealm;
}

-(void)setupEditView
{
    self.celebForNameLabel.text = [[NSString stringWithFormat:@"CELEBRATION FOR %@", self.celebrationRealm.recipient.firstName] uppercaseString];
    self.giveGiftSwitch.on = self.celebrationRealm.giveGift;
    self.giveCardSwitch.on = self.celebrationRealm.giveCard;
    self.makeCallSwitch.on = self.celebrationRealm.makeCall;
    self.saveButton.titleLabel.text = @"EDIT";
    //BEGIN HERE
    
}


@end
