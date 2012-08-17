//
//  ReminderViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UITextField *alertDescription;
@property (strong, nonatomic) IBOutlet UITextField *alertLocation;
@property (strong, nonatomic) IBOutlet  UISegmentedControl *alertSegmentControl;
@property (strong, nonatomic) IBOutlet  UISegmentedControl *durationSegmentControl;

@property (nonatomic, assign) NSInteger alertTime;

-(IBAction)back:(id)sender;
-(IBAction)addReminder:(id)sender;
-(IBAction)selectAlertInfo:(id)sender;
-(IBAction)addNotification:(id)sender;
-(IBAction)dissmissKeyboard:(id)sender;
-(IBAction)showListReminder:(id)sender;


@end
