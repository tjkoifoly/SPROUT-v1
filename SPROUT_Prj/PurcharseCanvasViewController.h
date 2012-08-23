//
//  PurcharseCanvasViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PurcharseCanvasViewController;
@class ConfirmPurchaseViewController;
@protocol PurcharseDelegate <NSObject>

-(void)gotoConfirm: (PurcharseCanvasViewController *)controller toView: (ConfirmPurchaseViewController *)confirmView;

@end

@interface PurcharseCanvasViewController : UIViewController

@property (unsafe_unretained, nonatomic) id <PurcharseDelegate> delegate;
@property (strong, nonatomic) UIImage *imageToPrint;

-(IBAction)goToHome:(id)sender;
-(IBAction)chooseCanvas:(id)sender;

@end
