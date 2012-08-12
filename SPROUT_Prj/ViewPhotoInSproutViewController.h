//
//  ViewPhotoInSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragDropImageView.h"
@class ViewPhotoInSproutViewController;
@protocol DeletePhotoDelegate <NSObject>

-(void)deletePhoto : (ViewPhotoInSproutViewController *)controller : (DragDropImageView *)object;

@end

@interface ViewPhotoInSproutViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollImages;

@property (strong, nonatomic) NSMutableArray *listImages;
@property (assign, nonatomic) id <DeletePhotoDelegate> delegate;
@property (strong, nonatomic) DragDropImageView *currentObject;

-(IBAction)back:(id)sender;
-(IBAction)deleteImage:(id)sender;
-(UIScrollView *)loadScrollView: (NSArray *)list : (id)currentObj;

@end
