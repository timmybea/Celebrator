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

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSArray *celebrationsArray;
@property (nonatomic) int currentCelebration;

@end

@implementation CalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentCelebration = 0;
    
    [self resetCelebrationDetails];
    
    if(self.celebrationsArray.count < 2)
    {
        self.nextButton.hidden = YES;
    }
}

- (void)passCelebrationsArray:(NSArray *)celebrations
{
    self.celebrationsArray = [[NSArray alloc] initWithArray:celebrations];
    
}

- (void)resetCelebrationDetails
{
    Celebration *celebration = [self.celebrationsArray objectAtIndex:self.currentCelebration];
    self.label.text = celebration.occassion;
}


- (IBAction)nextButtonClicked:(UIButton *)sender
{
    self.currentCelebration += 1;
    [self resetCelebrationDetails];
}

@end
