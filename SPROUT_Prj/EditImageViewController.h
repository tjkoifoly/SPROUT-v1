//
//  EditImageViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleColorView.h"

@interface EditImageViewController : UIViewController<ChangeColorDelegate>

@property (strong, nonatomic) UIImage *imageToEdit;
@property (strong, nonatomic) IBOutlet UIImageView *frameForEdit;
@property (strong, nonatomic) IBOutlet UIImageView *frontViewChangeColor;
@property (strong, nonatomic) IBOutlet UIView *areForEdit;

-(IBAction)goToHome:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)exportImage:(id)sender;
-(IBAction)changeColor:(id)sender;
-(IBAction)cropImage:(id)sender;
-(IBAction)changeEffect:(id)sender;
-(IBAction)rotateImage:(id)sender;

@end
