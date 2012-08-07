//
//  SplashViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SaveorDiscardPhotoViewController.h"

@interface TakePhotoViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIImagePickerController *pickerImage;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL newMedia;
@property (nonatomic) BOOL save;

-(IBAction)capture:(id)sender;
-(IBAction)goToHome :(id)sender;
-(IBAction)loadImageFromLibrary:(id)sender;

@end
