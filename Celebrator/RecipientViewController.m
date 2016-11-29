//
//  RecipientViewController.m
//  Celebrator
//
//  Created by Justine Herman on 11/26/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "RecipientViewController.h"
#import <Realm/Realm.h>
#import "ModelProtocols.h"
#import "Recipient.h"

@interface RecipientViewController ()

@property RLMResults *recipientsArray;


@end

@implementation RecipientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}


#pragma mark - UI

- (void)setupUI
{
   // self.title = @"";
    self.navigationItem.RightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(Add)];
 
}


- (void)addRecipent
{

    Recipient *recipient = [[Recipient alloc] init];
    recipient.firstName = @"David";
    recipient.lastName = @"Henderson";
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        [realm addObject:recipient];
    }];
}


//- (void)updateRecipient
//{
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm beginWriteTransaction];
//    recipient.lastName = @"Harrison";
//    [realm commitWriteTransaction];
//}

//- (void)linkToCelebration
//{
//    Recipient *recipient1 = [[Recipient alloc] init];
//    CelebrationRealm *celebration1 = [[CelebrationRealm alloc] init];
//    recipient1.firstName = @"Tim";
//    [recipient1.celebration1 addObject:celebration1];
//    
//    [realm transactionWithBlock:^{
//        [realm addObject:recipient1];
//    }];
//
//}


    
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
