//
//  ReminderDetail.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/21/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderDetail : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *txtDesc;
@property (strong, nonatomic) IBOutlet UITextView *txtLocation;
@property (strong, nonatomic) IBOutlet UITextView *txtStartTime;
@property (strong, nonatomic) IBOutlet UITextView *txtDuration;
@property (strong, nonatomic) IBOutlet UITextView *txtNextTime;
@property (strong, nonatomic) IBOutlet UIImageView *icon;

@property (strong, nonatomic) id remind;
@property (strong, nonatomic) NSString *notification;

@end
