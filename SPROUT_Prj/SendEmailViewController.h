//
//  SendEmailViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SendEmailViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) MFMailComposeViewController *mailer;

@property (strong, nonatomic) UIImage *imageToSend;

-(IBAction)goToHome:(id)sender;
-(IBAction)send:(id)sender;
-(IBAction)resignKeyboard:(id)sender;

@end
