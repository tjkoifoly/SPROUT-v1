//
//  ReminderCell.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/21/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ReminderCell.h"

@implementation ReminderCell

@synthesize icon;
@synthesize desc;
@synthesize date;
@synthesize notisOfCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
