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
#import "OverlayView.h"

@interface TakePhotoViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, OverlayViewDelegate>

@property (retain, nonatomic) UIImagePickerController *pickerImage;

@property (nonatomic) BOOL save;
@property (nonatomic) BOOL isLibrary;
@property (strong, nonatomic) NSString *urlImage;

-(IBAction)capture:(id)sender;
-(IBAction)goToHome :(id)sender;
-(IBAction)loadImageFromLibrary:(id)sender;

@end
