//
//  TellAboutController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/27/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GSTwitPicEngine.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "MBProgressHUD.h"

@interface TellAboutController : UIViewController<MFMailComposeViewControllerDelegate, SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate, MBProgressHUDDelegate, UIAlertViewDelegate, FBViewControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *titleApp;
@property (strong, nonatomic) IBOutlet UITextView *comment;
@property (nonatomic) BOOL stayup;

-(IBAction)resignKeyboard:(id)sender;
-(IBAction)sendEmail:(id)sender;
-(IBAction)shareFB:(id)sender;
-(IBAction)shareTW:(id)sender;
-(IBAction)gotoHome:(id)sender;
-(IBAction)nextComment:(id)sender;

-(void)setViewMoveUp: (BOOL) moveUp;

@end
