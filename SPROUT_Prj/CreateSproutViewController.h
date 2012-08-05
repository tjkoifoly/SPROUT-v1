//
//  CreateSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SproutScrollView.h"

@interface CreateSproutViewController : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

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
