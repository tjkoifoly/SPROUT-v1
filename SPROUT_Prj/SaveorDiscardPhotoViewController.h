//
//  SaveorDiscardPhotoViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>


@interface SaveorDiscardPhotoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewBack;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *urlImage;
@property (nonatomic) BOOL fromLib;

-(IBAction)save:(id)sender;
-(IBAction)discard:(id)sender;
-(IBAction)goToHome:(id)sender;
- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect;
-(UIImage *)imageCaptureSave: (UIView *)viewInput;

@end
