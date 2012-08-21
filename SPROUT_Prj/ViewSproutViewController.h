//
//  ViewSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewSproutViewController : UIViewController<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *listSprout;
-(IBAction)goToHome:(id)sender;
-(NSString *)dataPathFile:(NSString *)fileName;

@end
