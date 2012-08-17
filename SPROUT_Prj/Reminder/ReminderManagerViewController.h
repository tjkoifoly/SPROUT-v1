//
//  ReminderManagerViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/17/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderManagerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UIButton *editButton;


@property (strong, nonatomic) NSMutableArray *listNotifications;

-(IBAction)deleteAll:(id)sender;
-(IBAction)toggleEdit:(id)sender;
-(void) reloadTable;

@end
