//
//  ContinueAfterSaveViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditImageViewController.h"

@interface ContinueAfterSaveViewController : UIViewController<SaveForEditDelegate>

@property (strong, nonatomic) UIImage *imageInput;
@property (strong, nonatomic) IBOutlet UIImageView *viewImage;
@property (strong, nonatomic) NSString *urlImage;

-(IBAction)uploadToSprout:(id)sender;
-(IBAction)edit:(id)sender;
-(IBAction)postToSocialNetwork:(id)sender;
-(IBAction)goToHome:(id)sender;

@end
