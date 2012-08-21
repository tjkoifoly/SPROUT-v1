//
//  ReminderCell.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/21/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) UILocalNotification *notifi;

@end
