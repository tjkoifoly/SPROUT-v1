//
//  DisplaySproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SproutScrollView.h"

@interface ExportSproutViewController : UIViewController 

@property (strong, nonatomic) IBOutlet UIImageView *sproutToImage;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@property (strong, nonatomic) IBOutlet UIButton *purchaseButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) SproutScrollView *sproutScroll;

-(IBAction)goToHome:(id)sender;
-(IBAction)sendViaEmail:(id)sender;
-(IBAction)purcharseCanvas:(id)sender;
-(IBAction)saveAsImage:(id)sender;
-(IBAction)shareViaSocialNetwork:(id)sender;
-(UIImage *)imageCaptureSave: (UIView *)viewInput;


@end
