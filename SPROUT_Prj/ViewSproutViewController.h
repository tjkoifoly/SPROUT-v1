//
//  ViewSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewSproutViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray *listSprout;
-(IBAction)goToHome:(id)sender;

@end