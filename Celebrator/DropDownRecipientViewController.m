//
//  DropDownRecipientViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-29.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "DropDownRecipientViewController.h"

@interface DropDownRecipientViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *groupButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) UITextField *textField;

- (IBAction)dropDownAction:(UIButton *)sender;

@end

@implementation DropDownRecipientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.data = [[NSArray alloc] initWithObjects:@"Family", @"Friends", @"School", @"Work", @"Other", nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetGroupButton:) name:@"resetGroupButton" object:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dropTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dropTableIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dropTableIdentifier];
    }
    
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"groupDropDown" object:self userInfo:nil];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.textLabel.text isEqualToString:@"Other"])
    {
        [self appearTextField];
    }
    else
    {
        NSDictionary *group = @{@"group": cell.textLabel.text};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupSet" object:self userInfo:group];
        [self.groupButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tableView.hidden = YES;
    }
}

- (void)appearTextField
{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 373, 30)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"Enter group";
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.textField.leftView = paddingView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self.view insertSubview:self.textField aboveSubview:self.view];
    self.textField.delegate = self;
    self.groupButton.hidden = YES;
    self.tableView.hidden = YES;
}

- (IBAction)dropDownAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"groupDropDown" object:self userInfo:nil];
    
    if(self.tableView.hidden == YES)
    {
        self.tableView.hidden = NO;
    }
    else
    {
        self.tableView.hidden = YES;
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    NSDictionary *group = @{@"group": self.textField.text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"groupSet" object:self userInfo:group];
    
    [textField resignFirstResponder];
    self.textField.hidden = YES;
    self.groupButton.hidden = NO;
    [self.groupButton setTitle:self.textField.text forState:UIControlStateNormal];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSDictionary *group = @{@"group": self.textField.text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"groupSet" object:self userInfo:group];
    
    [textField resignFirstResponder];
    self.textField.hidden = YES;
    self.groupButton.hidden = NO;
    [self.groupButton setTitle:self.textField.text forState:UIControlStateNormal];
    return YES;
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (void)resetGroupButton:(NSNotification *)notification
{
    [self.groupButton setTitle:@"ADD GROUP" forState:UIControlStateNormal];
}


@end
