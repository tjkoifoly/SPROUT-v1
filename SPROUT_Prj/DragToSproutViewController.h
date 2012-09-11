//
//  DragToSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragDropImageView.h"
#import "SproutScrollView.h"
#import "ViewPhotoInSproutViewController.h"

@interface DragToSproutViewController : UIViewController
<SproutDelegate, DeletePhotoDelegate>

//SproutScroll as a array store all of images of sprout
@property (strong, nonatomic) SproutScrollView *sproutScroll;
//Frame for sprout
@property (strong, nonatomic) IBOutlet UIView *sproutView;
//Image to drag in sprout
@property (strong, nonatomic) IBOutlet UIImageView *imageForSprout;
@property (strong, nonatomic) IBOutlet UIImageView *fontFrame;
//Image
@property (strong, nonatomic) UIImage *imageInput;

//Sprout Object
@property (strong, nonatomic) NSManagedObject *sprout;
//URL of image input
@property (strong, nonatomic) NSString *urlImage;
//Array of objects image of sprout
@property (strong, nonatomic) NSMutableArray *imagesArray;

-(IBAction)goToHome:(id)sender;
-(void)getImageFromFile : (NSString *)fileName input: (UIImage *)inputImage;
-(UIImage *)thumnailImageFromImageView: (UIImage *)inputImage;


@end
