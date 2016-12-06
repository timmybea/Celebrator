//
//  ListViewCell.m
//  Celebrator
//
//  Created by Justine Herman on 11/29/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "ListViewCell.h"
#import "CelebrationRealm.h"

@interface ListViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *recipientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recipientOccasionLabel;

@end

@implementation ListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithRecipient:(Recipient *)recipient
{
    self.recipientNameLabel.text = recipient.firstName;
    self.recipientOccasionLabel.text = recipient.celebrations;
}

@end
