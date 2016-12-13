//
//  ListViewCell.m
//  Celebrator
//
//  Created by Justine Herman on 11/29/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "ListViewCell.h"
#import "Recipient.h"

@interface ListViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *allCelebrationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateOfCelebrationLabel;
@property (nonatomic) Recipient *recipient;


@end

@implementation ListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        //dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"dd/MM/yy";
    }
    
    return dateFormatter;
}

- (void)configureCellWithCelebration:(CelebrationRealm *)celebration
{
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", celebration.recipient.firstName, celebration.recipient.lastName];
    self.allCelebrationsLabel.text = [NSString stringWithFormat:@"%@ - %@", fullName, celebration.occasion];
    self.dateOfCelebrationLabel.text = [[self dateFormatter] stringFromDate:celebration.date];
}

@end
