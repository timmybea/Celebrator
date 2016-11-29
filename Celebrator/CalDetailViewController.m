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
@property (strong, nonatomic) NSArray *celebrationsArray;

@end

@implementation CalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Celebration *celebration = [self.celebrationsArray objectAtIndex:0];
    self.label.text = celebration.occassion;
}

- (void)passCelebrationsArray:(NSArray *)celebrations
{
    self.celebrationsArray = [[NSArray alloc] initWithArray:celebrations];
    
}




@end
