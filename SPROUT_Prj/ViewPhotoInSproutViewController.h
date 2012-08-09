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

-(void)deletePhoto : (ViewPhotoInSproutViewController *)controller : (NSManagedObject *)object;

@end

@interface ViewPhotoInSproutViewController : UIViewController<UIScrollViewDelegate>

@property (assign, nonatomic) id <DeletePhotoDelegate> delegate;
@property (strong, nonatomic) UIScrollView *scrollImages;
@property (strong, nonatomic) UIImage *current;
@property (strong, nonatomic) NSMutableArray *listImages;

@property (strong, nonatomic) NSMutableArray *imagesMgr;
@property (strong, nonatomic) NSManagedObject *currentObject;

-(IBAction)back:(id)sender;
-(IBAction)deleteImage:(id)sender;
-(UIScrollView *)loadScrollView: (NSArray *)list : (id)currentObj;

@end
