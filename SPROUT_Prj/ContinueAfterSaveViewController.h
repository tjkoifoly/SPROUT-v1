//
//  ContinueAfterSaveViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContinueAfterSaveViewController : UIViewController

@property (strong, nonatomic) UIImage *imageInput;
@property (strong, nonatomic) IBOutlet UIImageView *viewImage;

-(IBAction)uploadToSprout:(id)sender;
-(IBAction)edit:(id)sender;
-(IBAction)postToSocialNetwork:(id)sender;
-(IBAction)goToHome:(id)sender;

@end
