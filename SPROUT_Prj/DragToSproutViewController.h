//
//  DragToSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragToSproutViewController : UIViewController

@property (strong, nonatomic) UIScrollView *sproutScroll;
@property (strong, nonatomic) IBOutlet UIView *sproutView;
@property (strong, nonatomic) IBOutlet UIImageView *imageForSprout;
@property (strong, nonatomic) UIImage *imageInput;

-(IBAction)goToHome:(id)sender;

@end
