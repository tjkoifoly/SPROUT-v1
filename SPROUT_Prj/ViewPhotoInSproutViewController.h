//
//  ViewPhotoInSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragDropImageView.h"

@interface ViewPhotoInSproutViewController : UIViewController

@property (strong, nonatomic) NSArray *listImages;
@property (strong, nonatomic) UIScrollView *scrollImages;
@property (strong, nonatomic) DragDropImageView *current;


-(IBAction)back:(id)sender;

@end
