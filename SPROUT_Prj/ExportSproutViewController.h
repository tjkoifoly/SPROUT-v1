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
#import <MessageUI/MessageUI.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "GSTwitPicEngine.h"
#import "MBProgressHUD.h"

@interface ExportSproutViewController : UIViewController <SA_OAuthTwitterControllerDelegate,MFMailComposeViewControllerDelegate, UIScrollViewDelegate, GSTwitPicEngineDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *sproutToImage;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@property (strong, nonatomic) IBOutlet UIButton *purchaseButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *btnFB;
@property (strong, nonatomic) IBOutlet UIButton *btnTW;
@property (strong, nonatomic) IBOutlet UIButton *btnFB_before;
@property (strong, nonatomic) IBOutlet UIButton *btnTW_before;
@property (strong, nonatomic) IBOutlet UIImageView *font1;
@property (strong, nonatomic) IBOutlet UIImageView *font2;

@property (strong, nonatomic) SproutScrollView *sproutScroll;

-(IBAction)goToHome:(id)sender;
-(IBAction)sendViaEmail:(id)sender;
-(IBAction)purcharseCanvas:(id)sender;
-(IBAction)saveAsImage:(id)sender;
-(IBAction)shareViaSocialNetwork:(id)sender;
-(UIImage *)imageCaptureSave: (UIView *)viewInput;
-(UIImage *)thumnailImageFromImageView: (UIImage *)inputImage;
-(void)viewPhoto;
-(void) postTwitter: (UIImage *)imageToPost;
-(void)saveImageToFile : (NSString *)fileName input: (UIImage *)inputImage;


@end
