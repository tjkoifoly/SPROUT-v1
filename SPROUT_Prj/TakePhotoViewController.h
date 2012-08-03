//
//  SplashViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePhotoViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIImagePickerController *pickerImage;

-(IBAction)capture:(id)sender;
-(IBAction)goToHome :(id)sender;
-(IBAction)loadImageFromLibrary:(id)sender;

@end
