//
//  CalDetailViewController.m
//  Celebrator
//
//  Created by Tim Beals on 2016-11-28.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CalDetailViewController.h"
#import "CalendarViewControllerDelegate.h"
#import "Celebration.h"

@interface CalDetailViewController () <CalendarViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) Celebration *celebration;

@end

@implementation CalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gifter Name2.png"]];
    
}

- (void)passCelebration:(Celebration *)celebration;
{
    self.celebration = [[Celebration alloc] init];
    self.celebration = celebration;
    self.label.text = celebration.occassion;
}

@end
