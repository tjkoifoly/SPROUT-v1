//
//  SaveSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragDropImageView.h"
#import "SproutScrollView.h"

@interface SaveSproutViewController : UIViewController
<SproutDelegate>

@property (strong, nonatomic) SproutScrollView *sproutScroll;
@property (strong, nonatomic) NSManagedObject *sprout;
@property (strong, nonatomic) IBOutlet UIView *sproutView;



-(IBAction)goToHome:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)exportSport:(id)sender;

@end
