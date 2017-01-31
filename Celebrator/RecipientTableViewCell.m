//
//  RecipientTableViewCell.m
//  Celebrator
//
//  Created by Justine Herman on 12/1/16.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "RecipientTableViewCell.h"

@interface RecipientTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *CelebrationNameCellLabel;

@end

@implementation RecipientTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)displayData:(CelebrationRealm *)celebration
{
    self.CelebrationNameCellLabel.text = celebration.occasion;
}

@end
