//
//  CalendarDetailTableViewCell.m
//  Celebrator
//
//  Created by Tim Beals on 2016-12-01.
//  Copyright © 2016 Tim Beals. All rights reserved.
//

#import "CalendarDetailTableViewCell.h"


@implementation CalendarDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tintColor = [UIColor whiteColor];
    self.contentView.superview.backgroundColor = self.colorManager.aquaMarine;
    self.accessoryView.backgroundColor = self.colorManager.aquaMarine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
