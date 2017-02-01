//
//  AddRecipientViewController.m
//  Celebrator
//
//  Created by Justine Herman on 11/26/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "AddRecipientViewController.h"
#import "AddCelebrationViewController.h"
#import "CalendarViewController.h"
#import <Realm/Realm.h>
#import "ModelProtocols.h"
#import "Recipient.h"
#import "TempRecipient.h"
#import "RecipientTableViewCell.h"
#import "DateManager.h"


@interface AddRecipientViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *firstNameWarning;
@property (weak, nonatomic) IBOutlet UILabel *lastNameWarning;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addCelebButtonView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *dropDownView;

@property (weak, nonatomic) IBOutlet UITextField *birthdateDayTextField;

@property (weak, nonatomic) IBOutlet UITextField *birthdateMonthTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdateYearTextField;

@property (nonatomic) BOOL isEditMode;
@property (nonatomic) BOOL isDropDownBehind;
@property (nonatomic) BOOL segueToEditCelebration;
@property (nonatomic) CelebrationRealm *celebrationEdit;
@property (nonatomic) Recipient *recipient;
@property (nonatomic) NSString *group;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSMutableArray *celebrationsArray;


- (IBAction)saveButton:(UIButton *)sender;
- (IBAction)AddCelebrationButton:(id)sender;
@end

@implementation AddRecipientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
    
    [self.view insertSubview:self.dropDownView belowSubview:self.tableView];
    self.isDropDownBehind = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewHierarchy:) name:@"groupDropDown" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGroup:) name:@"groupSet" object:nil];
    self.firstNameWarning.hidden = YES;
    self.lastNameWarning.hidden = YES;
    
    //Setup based on edit more.
    if(self.isEditMode)
    {
        [self setupEditMode];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}

- (void)changeViewHierarchy:(NSNotification *)notification
{
    if(self.isDropDownBehind)
    {
        [self.view insertSubview:self.tableView belowSubview:self.dropDownView];
        [self.view insertSubview:self.addCelebButtonView belowSubview:self.dropDownView];
        self.isDropDownBehind = NO;
    }
    else
    {
        [self.view insertSubview:self.dropDownView belowSubview:self.addCelebButtonView];
        [self.view insertSubview:self.dropDownView belowSubview:self.tableView];
        self.isDropDownBehind = YES;
    }
}


#pragma - celebrations table view

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.celebrationsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CelebrationNameID" forIndexPath:indexPath];
    CelebrationRealm *celebration = self.celebrationsArray[indexPath.row];
    [cell displayData:celebration];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //EDIT MODE FOR THAT CELEBRATION
    self.segueToEditCelebration = YES;
    self.celebrationEdit = [self.celebrationsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"addCelebration" sender:self];
    
    
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RecipientBranch" bundle:nil];
//    AddCelebrationViewController *destination = [storyboard instantiateViewControllerWithIdentifier:@"recipientViewController"];
//    [[self navigationController] pushViewController:destination animated:YES];
//    self.delegate = destination;
//    [self.delegate updateCelebrationForEdit:self.celebrationRealm];

    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[RLMRealm defaultRealm] beginWriteTransaction];
        CelebrationRealm *celebration = [self.celebrationsArray objectAtIndex:indexPath.row];
        [[RLMRealm defaultRealm]deleteObject:celebration];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        tableView.reloadData;
    }
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        //dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addCelebration"])
    {
        if (self.segueToEditCelebration) {
            
            self.segueToEditCelebration = NO;
            AddCelebrationViewController *controller = (AddCelebrationViewController* )segue.destinationViewController;
            
            CelebrationRealm *celebration = self.celebrationEdit;
            self.delegate = controller;
            [self.delegate updateCelebrationForEdit:celebration];
            
        } else {
            AddCelebrationViewController *controller = (AddCelebrationViewController* )segue.destinationViewController;
            
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", self.birthdateDayTextField.text, self.birthdateMonthTextField.text, self.birthdateYearTextField.text];
            NSDate *dob = [self.dateFormatter dateFromString:dateString];
            TempRecipient *tempRecipient = [[TempRecipient alloc] initWithFirstName:self.firstNameTextField.text andDateOfBirth:dob];
            controller.tempRecipient = tempRecipient;
            controller.delegate = self;
        }
    }
}

//Delegate method to return the celebration to the table view
- (void)passCelebrationToRecipient:(CelebrationRealm *)celebration;
{
    if(!self.celebrationsArray)
    {
        self.celebrationsArray = [[NSMutableArray alloc] init];
    }
    if (self.isEditMode) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addObject:celebration];
            celebration.recipient = self.recipient;
            [self.celebrationsArray addObject:celebration];
            [self.tableView reloadData];
        }];
    } else {
        [self.celebrationsArray addObject:celebration];
        [self.tableView reloadData];
    }
}

- (IBAction)saveButton:(UIButton *)sender
{
    if([self.firstNameTextField hasText] && [self.lastNameTextField hasText])
    {
        if(self.isEditMode) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            self.recipient.firstName = self.firstNameTextField.text;
            self.recipient.lastName = self.lastNameTextField.text;
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", self.birthdateDayTextField.text, self.birthdateMonthTextField.text, self.birthdateYearTextField.text];
            self.recipient.birthdate = [self.dateFormatter dateFromString:dateString];
            self.recipient.group = self.group;
            
            NSMutableArray *newCelebrations = [[NSMutableArray alloc] init];
            BOOL isCelebInRecipient = NO;
            
            for(CelebrationRealm *celebration in self.celebrationsArray)
            {
                for (CelebrationRealm *celeb in self.recipient.celebrations) {
                    if ([celebration.primaryKey isEqualToString:celeb.primaryKey]) {
                        isCelebInRecipient = YES;
                    }
                }
                if(!isCelebInRecipient) {
                    celebration.recipient = self.recipient;
                    [newCelebrations addObject:celebration];
                }
            }
            if(newCelebrations.count > 0) {
                [self.recipient.celebrations addObjects:newCelebrations];
            }
            [realm commitWriteTransaction];
        } else {
            RLMRealm *realm = [RLMRealm defaultRealm];
            Recipient *recipient = [[Recipient alloc] init];
            recipient.firstName = self.firstNameTextField.text;
            recipient.lastName = self.lastNameTextField.text;
            NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", self.birthdateDayTextField.text, self.birthdateMonthTextField.text, self.birthdateYearTextField.text];
            recipient.birthdate = [self.dateFormatter dateFromString:dateString];
            recipient.group = self.group;
            
            [recipient.celebrations addObjects:self.celebrationsArray];
            for(CelebrationRealm *celebration in self.celebrationsArray)
            {
                celebration.recipient = recipient;
            }
            [realm transactionWithBlock:^{
                [realm addObject:recipient];
            }];
        }
        
        //clear fields
        self.firstNameTextField.text = nil;
        self.lastNameTextField.text = nil;
        self.birthdateDayTextField.text = nil;
        self.birthdateMonthTextField.text = nil;
        self.birthdateYearTextField.text = nil;
        self.group = nil;
        self.celebrationsArray = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resetGroupButton" object:self userInfo:nil];
        
        if(self.isEditMode) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self.tabBarController setSelectedIndex:0];
        }
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
}

#pragma - RecipientTableViewControllerProtocol method for editing an existing recipient

-(void)updateAddRecipientForEdit:(Recipient *)recipient {
    self.isEditMode = YES;
    self.recipient = recipient;
}

-(void)setupEditMode {
    self.firstNameTextField.text = self.recipient.firstName;
    self.lastNameTextField.text = self.recipient.lastName;
    
    if (self.recipient.birthdate != nil) {
        self.birthdateMonthTextField.text = [DateManager separateMonthFromDate:self.recipient.birthdate];
        self.birthdateDayTextField.text = [DateManager separateDayFromDate:self.recipient.birthdate];
        self.birthdateYearTextField.text = [DateManager separateYearFromDate:self.recipient.birthdate];
    }
    self.group = self.recipient.group;
    NSDictionary *group = @{@"group": self.recipient.group};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetGroupButton" object:self userInfo:group];
    
    self.celebrationsArray = self.recipient.celebrations;
    [self.tableView reloadData];
    
    [self.saveButton setTitle:@"SAVE CHANGES" forState:UIControlStateNormal];
}

@end
