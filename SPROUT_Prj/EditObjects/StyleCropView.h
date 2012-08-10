//
//  StyleCropView.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/9/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StyleCropView;
@protocol CropImageDelegate <NSObject>

-(void)resizeFrame: (StyleCropView *)view : (CGFloat) value;
-(void)cropImageInFrame : (StyleCropView *)view;
-(void)closeFrame: (StyleCropView *)view;
-(void)undoImage: (StyleCropView *)view;

@end

@interface StyleCropView : UIView

@property (assign, nonatomic) id <CropImageDelegate> delegate;

-(IBAction)resize:(id)sender;
-(IBAction)crop:(id)sender;
-(IBAction)close:(id)sender;
-(IBAction)undo:(id)sender;

@end
