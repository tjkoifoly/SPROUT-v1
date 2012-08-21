//
//  CreateSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SproutScrollView.h"
#import "SaveorDiscardPhotoViewController.h"
@class CreateSproutViewController;
@protocol CreateSproutDelegate <NSObject>

-(void)gotoCapturePhoto;
-(void)loadFromLibOK:(SaveorDiscardPhotoViewController *)controller;

@end

@interface CreateSproutViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, SproutDelegate>

@property (unsafe_unretained, nonatomic) id<CreateSproutDelegate>delegate;
@property (strong, nonatomic) UIImagePickerController *pickerImage;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) SproutScrollView *sprout;
@property (strong, nonatomic) IBOutlet UIView *sproutView;



-(IBAction)loadImageFromLibrary:(id)sender;
-(IBAction)goToHome:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)share:(id)sender;
-(IBAction)capture:(id)sender;

@end
