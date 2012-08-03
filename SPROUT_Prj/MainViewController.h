//
//  MainViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TakePhotoViewController;
@class SelectGridSizeViewController;
@class ViewSproutViewController;

@interface MainViewController : UIViewController

@property (strong, nonatomic) TakePhotoViewController *takePhotoViewController;
@property (strong, nonatomic) SelectGridSizeViewController *selectGridViewController;
@property (strong, nonatomic) ViewSproutViewController *viewSproutViewController;

-(IBAction)captureSprout:(id)sender;
-(IBAction)createSprout:(id)sender;
-(IBAction)viewSprout:(id)sender;
-(IBAction)reminder :(id)sender;

@end
