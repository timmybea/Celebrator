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
#import "Recipient.h"
#import "DateManager.h"
#import "CalDetailViewController.h"
#import "ColorManager.h"

@interface AddCelebrationViewController () <UITextFieldDelegate, UNUserNotificationCenterDelegate>
@property (weak, nonatomic) IBOutlet UILabel *celebrationWarning;
@property (weak, nonatomic) IBOutlet UILabel *celebrationDateWarning;
@property (weak, nonatomic) IBOutlet UIView *centreForm;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *reminderButton;
@property (weak, nonatomic) IBOutlet UITextField *celebMonthTF;
@property (weak, nonatomic) IBOutlet UITextField *celebDayTF;
@property (weak, nonatomic) IBOutlet UITextField *celebYearTF;
@property (weak, nonatomic) IBOutlet UISwitch *giveGiftSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *giveCardSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *makeCallSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) NSString *stringOccasion;

@property (nonatomic) UNUserNotificationCenter *userNotification;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) ColorManager *colorManager;

@property (nonatomic) BOOL isEditMode;
@property (nonatomic) BOOL isDropDownBehind;
@property (nonatomic) BOOL getsReminder;


- (IBAction)saveButton:(UIButton *)sender;
@end

@implementation AddCelebrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userNotification.delegate = self;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
    self.celebrationWarning.hidden = YES;
    self.celebrationDateWarning.hidden = YES;
    self.getsReminder = NO;
    self.colorManager = [[ColorManager alloc] init];
    
    //Setup based on edit more.
    if(self.isEditMode)
    {
        [self setupEditView];
    }
    else
    {
        self.celebForNameLabel.text = [[NSString stringWithFormat:@"CELEBRATION FOR %@", self.tempRecipient.firstName] uppercaseString];
    }

    //Setup notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewHierarchy:) name:@"dropDownClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCelebration:) name:@"celebrationSet" object:nil];
    
    //Set up views in correct hierarchy
    self.isDropDownBehind = NO;
    [self arrangeSubviews];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)changeViewHierarchy:(NSNotification *)notification
{
    [self arrangeSubviews];
}

- (void)arrangeSubviews
{
    if(self.isDropDownBehind)
    {
        [self.view insertSubview:self.centreForm belowSubview:self.containerView];
        [self.view insertSubview:self.saveButton belowSubview:self.containerView];
        [self.view insertSubview:self.datePicker belowSubview:self.containerView];
        self.isDropDownBehind = NO;
    }
    else
    {
        [self.view insertSubview:self.centreForm aboveSubview:self.containerView];
        [self.view insertSubview:self.datePicker aboveSubview:self.containerView];
        self.isDropDownBehind = YES;
    }
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"MM-dd-yyyy";
    }

    return dateFormatter;
}

- (NSDateFormatter *)remindDateFormatter
{
    static NSDateFormatter *remindDateFormatter;
    if(!remindDateFormatter)
    {
        remindDateFormatter = [NSDateFormatter new];
        remindDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        remindDateFormatter.dateFormat = @"MMM dd, yyyy h:mm a";
    }

    return remindDateFormatter;
}

- (IBAction)saveButton:(UIButton *)sender
{
    if([self.celebMonthTF hasText] && [self.celebDayTF hasText] && [self.celebYearTF hasText] && self.stringOccasion)
    {
        if(self.isEditMode)
        {
            //Edit celebration
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            self.celebrationRealm.occasion = self.stringOccasion;
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", self.celebMonthTF.text, self.celebDayTF.text, self.celebYearTF.text];
            self.celebrationRealm.date = [self.dateFormatter dateFromString:dateString];
            self.celebrationRealm.giveCard = self.giveCardSwitch.on;
            self.celebrationRealm.giveGift = self.giveGiftSwitch.on;
            self. celebrationRealm.makeCall = self.makeCallSwitch.on;
            [realm commitWriteTransaction];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            //Save celebration
            CelebrationRealm *celebrationRealm = [[CelebrationRealm alloc] init];
            celebrationRealm.occasion = self.stringOccasion;
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", self.celebMonthTF.text, self.celebDayTF.text, self.celebYearTF.text];
            celebrationRealm.date = [self.dateFormatter dateFromString:dateString];
            celebrationRealm.giveCard = self.giveCardSwitch.on;
            celebrationRealm.giveGift = self.giveGiftSwitch.on;
            celebrationRealm.makeCall = self.makeCallSwitch.on;
            
            //Reminder
            self.center.delegate = self;
            if(self.getsReminder)
            {
                
                UNMutableNotificationContent *content = [UNMutableNotificationContent new];
                content.title = [NSString stringWithFormat:@"%@ - %@", self.tempRecipient.firstName, celebrationRealm.occasion];
                
                NSMutableString *bodyMessage = [[NSMutableString alloc] init];
                if(celebrationRealm.giveCard)
                {
                    [bodyMessage appendString:@"Get greeting card\n"];
                }
                if(celebrationRealm.giveGift)
                {
                    [bodyMessage appendString:@"Get gift\n"];
                }
                if(celebrationRealm.makeCall)
                {
                    [bodyMessage appendString:@"Call\n"];
                }
                
                content.body = [NSString stringWithFormat:@"%@", bodyMessage];
                content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
                content.sound = [UNNotificationSound defaultSound];
                
                NSDateComponents *dateComponents = [[NSCalendar currentCalendar]
                                                    components:NSCalendarUnitYear +
                                                    NSCalendarUnitMonth + NSCalendarUnitDay +
                                                    NSCalendarUnitHour + NSCalendarUnitMinute fromDate:self.datePicker.date];
                
                celebrationRealm.reminderDate = self.datePicker.date;
                UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger
                                                          triggerWithDateMatchingComponents:dateComponents repeats:NO];
                
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"ReminderAlert" content:content trigger:trigger];
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    if (error != nil) {
                        NSLog(@"User notification error: %@",error);
                    }
                }];
            }
            [self.delegate passCelebrationToRecipient:celebrationRealm];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else
    {
        self.celebrationWarning.hidden = NO;
        self.celebrationDateWarning.hidden = NO;
    }
}

- (IBAction)reminderDateButtonTouched:(UIButton *)sender
{
    if(self.getsReminder)
    {
        self.getsReminder = NO;
        self.reminderButton.backgroundColor = self.colorManager.aquaMarine;
        [self.reminderButton setTitle:@"NO" forState:UIControlStateNormal];
    }
    else
    {
        self.getsReminder = YES;
        self.reminderButton.backgroundColor = self.colorManager.golden;
        [self.reminderButton setTitle:@"YES" forState:UIControlStateNormal];    }
}


//receive the drop down selection as a string
- (void)updateCelebration:(NSNotification *)notification
{
    self.stringOccasion = [notification.userInfo valueForKey:@"celebration"];
    if([self.stringOccasion isEqualToString:@"Birthday"])
    {
        NSDate *nextBirthday = [DateManager nextBirthdayFromDOB:self.tempRecipient.dateOfBirth];
        self.celebDayTF.text = [DateManager separateDayFromDate: nextBirthday];
        self.celebMonthTF.text = [DateManager separateMonthFromDate: nextBirthday];
        self.celebYearTF.text = [DateManager separateYearFromDate: nextBirthday];
    }
    else
    {
        NSDate *occasionDate = [DateManager getHolidayDate:self.stringOccasion];
        self.celebDayTF.text = [DateManager separateDayFromDate: occasionDate];
        self.celebMonthTF.text = [DateManager separateMonthFromDate: occasionDate];
        self.celebYearTF.text = [DateManager separateYearFromDate: occasionDate];
    }
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
    //Set labels
    self.celebForNameLabel.text = [[NSString stringWithFormat:@"CELEBRATION FOR %@", self.celebrationRealm.recipient.firstName] uppercaseString];
    self.stringOccasion = self.celebrationRealm.occasion;

    //Set switches and buttons
    self.giveGiftSwitch.on = self.celebrationRealm.giveGift;
    self.giveCardSwitch.on = self.celebrationRealm.giveCard;
    self.makeCallSwitch.on = self.celebrationRealm.makeCall;
    [self.saveButton setTitle:@"EDIT" forState:UIControlStateNormal];

    //Set textfields
    self.celebDayTF.text = [DateManager separateDayFromDate:self.celebrationRealm.date];
    self.celebMonthTF.text = [DateManager separateMonthFromDate:self.celebrationRealm.date];
    self.celebYearTF.text = [DateManager separateYearFromDate: self.celebrationRealm.date];

    //Set reminder
    if(self.celebrationRealm.reminderDate)
    {
        self.reminderButton.backgroundColor = self.colorManager.golden;
        [self.reminderButton setTitle:@"YES" forState:UIControlStateNormal];
        self.datePicker.date = self.celebrationRealm.reminderDate;
    }

    //Set occasion button
    NSDictionary *occasion = @{@"occasion": self.celebrationRealm.occasion};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateButtonForEdit" object:self userInfo:occasion];
    
}


@end
