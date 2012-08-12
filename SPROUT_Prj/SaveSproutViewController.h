//
//  SaveSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragDropImageView.h"
#import "SproutScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewPhotoInSproutViewController.h"

@interface SaveSproutViewController : UIViewController
<SproutDelegate, DeletePhotoDelegate>

@property (strong, nonatomic) SproutScrollView *sproutScroll;


@property (strong, nonatomic) IBOutlet UIView *sproutView;

@property (strong, nonatomic) NSManagedObject *sprout;
@property (strong, nonatomic) NSMutableArray *imagesArray;

-(IBAction)goToHome:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)exportSport:(id)sender;

@end
