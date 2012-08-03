//
//  ConfirmPurchaseViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPurchaseViewController : UIViewController

@property (nonatomic) BOOL accept;
@property (strong, nonatomic) IBOutlet UIImageView *acceptView;

-(void) touchCheck;
-(IBAction)goToHome:(id)sender;
-(IBAction)confirmPurchase:(id)sender;
-(IBAction)checkAccept:(id)sender;

@end
