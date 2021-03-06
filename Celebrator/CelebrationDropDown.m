//
//  CelebrationDropDown.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-29.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CelebrationDropDown.h"

@interface CelebrationDropDown () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *celebrationButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) UITextField *textField;

- (IBAction)dropDownAction:(UIButton *)sender;

@end

@implementation CelebrationDropDown

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButtonForEdit:) name:@"updateButtonForEdit" object:nil];
    
    self.data = [[NSArray alloc] initWithObjects:@"Birthday", @"Appreciation", @"Anniversary", @"Bridal Shower", @"Engagement", @"Baby Shower", @"Farewell/moving", @"Christmas", @"Valentine's Day", @"Mother's Day", @"Father's Day", @"Graduation", @"Get well soon", @"Sympathy", @"Promotion", @"Other", nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dropTableIdentifier = @"CelebrationTableCell";
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dropDownClicked" object:self userInfo:nil];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if([cell.textLabel.text isEqualToString:@"Other"])
    {
        [self appearTextField];
    }
    else
    {
        [self.celebrationButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tableView.hidden = YES;
        
        NSDictionary *celebration = @{@"celebration": cell.textLabel.text};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"celebrationSet" object:self userInfo:celebration];
    }
}

- (void)appearTextField
{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 360, 30)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"Enter celebration";
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    self.textField.leftView = paddingView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self.view insertSubview:self.textField aboveSubview:self.view];
    self.textField.delegate = self;
    self.celebrationButton.hidden = YES;
    self.tableView.hidden = YES;
}

- (IBAction)dropDownAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dropDownClicked" object:self userInfo:nil];
    
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
    NSDictionary *celebration = @{@"celebration": textField.text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"celebrationSet" object:self userInfo:celebration];
    
    [textField resignFirstResponder];
    self.textField.hidden = YES;
    self.celebrationButton.hidden = NO;
    [self.celebrationButton setTitle:self.textField.text forState:UIControlStateNormal];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSDictionary *celebration = @{@"celebration": textField.text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"celebrationSet" object:self userInfo:celebration];
    
    [textField resignFirstResponder];
    self.textField.hidden = YES;
    self.celebrationButton.hidden = NO;
    [self.celebrationButton setTitle:self.textField.text forState:UIControlStateNormal];
    return YES;
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

- (void)updateButtonForEdit:(NSNotification *)notification
{
    NSString *occasion = [notification.userInfo valueForKey:@"occasion"];
    [self.celebrationButton setTitle:occasion forState:UIControlStateNormal];
}



@end
