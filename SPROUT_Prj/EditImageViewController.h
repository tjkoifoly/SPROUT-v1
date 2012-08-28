//
//  EditImageViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyleColorView.h"
#import "SquareEditView.h"
#import "StyleCropView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "FiltersView.h"
#import "ImageFilter.h"

@class EditImageViewController;
@protocol SaveForEditDelegate <NSObject>

-(void)saveImage: (EditImageViewController *)controller withImage: (UIImage *)imageSaved andURL: (NSString *)urlOfImage;

@end

@interface EditImageViewController : UIViewController<ChangeColorDelegate, CropImageDelegate, FilterDelegate>

@property(assign, nonatomic)    id <SaveForEditDelegate> delegate;
@property (strong, nonatomic)   NSString *urlOfImage;
@property (strong, nonatomic)   UIImage *preoviousImage;
@property (strong, nonatomic)   UIImage *imageToEdit;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *editingIndicator;

@property (strong, nonatomic)   IBOutlet UIImageView *frameForEdit;
@property (strong, nonatomic)   IBOutlet SquareEditView *areForEdit;

-(IBAction)goToHome:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)exportImage:(id)sender;
-(IBAction)changeColor:(id)sender;
-(IBAction)cropImage:(id)sender;
-(IBAction)changeEffect:(id)sender;
-(IBAction)rotateImage:(id)sender;
-(NSString *)dataPathFile;

-(UIImage *)hueChangetoValue: (CGFloat)value withFilter: (CIFilter *)filterx andContext: (CIContext *)contextx;
-(UIImage *)situationChangetoValue: (CGFloat)value withFilter: (CIFilter *)filterx andContext: (CIContext *)contextx;

@end
