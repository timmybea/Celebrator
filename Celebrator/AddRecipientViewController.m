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
#import "RecipientTableViewCell.h"


@interface AddRecipientViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *firstNameWarning;
@property (weak, nonatomic) IBOutlet UILabel *lastNameWarning;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *dropDownView;

@property (weak, nonatomic) IBOutlet UITextField *birthdateDayTextField;

@property (weak, nonatomic) IBOutlet UITextField *birthdateMonthTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdateYearTextField;



@property (nonatomic) BOOL isDropDownBehind;
@property (nonatomic) NSString *group;
@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) Recipient *sendRecipient;
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
    self.celebrationsArray = [[NSMutableArray alloc] init];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CelebrationNameID" forIndexPath:indexPath];
    CelebrationRealm *celebration = self.celebrationsArray[indexPath.row];
    [cell displayData:celebration];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.celebrationsArray.count;
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addCelebration"])
    {
        AddCelebrationViewController *controller = (AddCelebrationViewController* )segue.destinationViewController;
        NSString *name = self.firstNameTextField.text;
        controller.recipientName = name;
        
        controller.delegate = self;
        
    }
}

- (void)passCelebrationToRecipient:(CelebrationRealm *)celebration;
{
    [self.celebrationsArray addObject:celebration];
    [self.tableView reloadData];
}


- (IBAction)saveButton:(UIButton *)sender
{
    if([self.firstNameTextField hasText] && [self.lastNameTextField hasText])
    {
        RLMRealm *realm = [RLMRealm defaultRealm];
        Recipient *recipient = [[Recipient alloc] init];
        [recipient.celebrations addObjects:self.celebrationsArray];
        for(CelebrationRealm *celebration in self.celebrationsArray)
        {
            celebration.recipient = recipient;
        }
        recipient.firstName = self.firstNameTextField.text;
        recipient.lastName = self.lastNameTextField.text;
        NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@", self.birthdateDayTextField.text, self.birthdateMonthTextField.text, self.birthdateYearTextField.text];
        recipient.birthdate = [self.dateFormatter dateFromString:dateString];
        recipient.group = self.group;
        [realm transactionWithBlock:^{
            [realm addObject:recipient];
        }];
        self.sendRecipient = recipient;
        
        //clear fields
        self.firstNameTextField.text = nil;
        self.lastNameTextField.text = nil;
        self.birthdateDayTextField.text = nil;
        self.birthdateMonthTextField.text = nil;
        self.birthdateYearTextField.text = nil;
        self.group = nil;
        //*** reset the button text

        CalendarViewController *calendarVC = (CalendarViewController *)[self.tabBarController.viewControllers objectAtIndex:0];
        [self.tabBarController setSelectedIndex:0];
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
