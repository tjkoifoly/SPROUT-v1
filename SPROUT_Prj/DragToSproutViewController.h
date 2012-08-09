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

@property (strong, nonatomic) SproutScrollView *sproutScroll;
@property (strong, nonatomic) NSManagedObject *sprout;
@property (strong, nonatomic) IBOutlet UIView *sproutView;
@property (strong, nonatomic) IBOutlet UIImageView *imageForSprout;
@property (strong, nonatomic) UIImage *imageInput;
@property (strong, nonatomic) NSString *urlImage;
@property (strong, nonatomic) NSMutableArray *imagesArray;

-(IBAction)goToHome:(id)sender;

@end
