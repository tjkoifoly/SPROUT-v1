//
//  UploadToSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadToSproutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *listSprout;
@property (strong, nonatomic) IBOutlet UITableView *table;
-(IBAction)goToHome:(id)sender;

@end
