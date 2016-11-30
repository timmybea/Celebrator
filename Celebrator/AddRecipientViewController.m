//
//  AddRecipientViewController.m
//  Celebrator
//
//  Created by Justine Herman on 11/26/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "AddRecipientViewController.h"

@interface AddRecipientViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstNameWarning;
@property (weak, nonatomic) IBOutlet UILabel *lastNameWarning;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *dropDownView;
@property (nonatomic) BOOL isDropDownBehind;
@property (nonatomic) NSString *group;

- (IBAction)saveButton:(UIButton *)sender;
- (IBAction)AddCelebrationButton:(id)sender;
@end

@implementation AddRecipientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
    
    [self.view insertSubview:self.dropDownView belowSubview:self.tableView];
    self.isDropDownBehind = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewHierarchy:) name:@"groupDropDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroup:) name:@"groupSet" object:nil];
    self.firstNameWarning.hidden = YES;
    self.lastNameWarning.hidden = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

- (void)changeViewHierarchy:(NSNotification *)notification
{
    if(self.isDropDownBehind)
    {
        [self.view insertSubview:self.tableView belowSubview:self.dropDownView];
        self.isDropDownBehind = NO;
    }
    else
    {
        [self.view insertSubview:self.dropDownView belowSubview:self.tableView];
        self.isDropDownBehind = YES;
    }
}

- (IBAction)saveButton:(UIButton *)sender
{
    if([self.firstNameTextField hasText] && [self.lastNameTextField hasText])
    {
        //INSTANTIATE RECIPIENT REALM
        //RETURN TO HOMESCREEN (CALENDAR)
    }
    else
    {
        self.firstNameWarning.hidden = NO;
        self.lastNameWarning.hidden = NO;
    }
}

- (IBAction)AddCelebrationButton:(id)sender
{
    if([self.firstNameTextField hasText] && [self.lastNameTextField hasText])
    {
        [self performSegueWithIdentifier:@"addCelebration" sender:self];
        self.firstNameWarning.hidden = YES;
        self.lastNameWarning.hidden = YES;
    }
    else{
        self.firstNameWarning.hidden = NO;
        self.lastNameWarning.hidden = NO;
    }
}

//receive the drop down selection as a string
- (void)updateGroup:(NSNotification *)notification
{
    self.group = [notification.userInfo valueForKey:@"group"];
    NSLog(@"%@", self.group);
}

@end
