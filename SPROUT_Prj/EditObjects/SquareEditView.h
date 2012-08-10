//
//  SquareEditView.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/9/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageToDag.h"

@interface SquareEditView : UIView

@property (strong, nonatomic) ImageToDag *areaToCrop;

-(void)createAreaToCrop;
-(void)resizeArea : (CGFloat)size;
-(void)removeAreaToCropFromView;
-(UIImage *)cropImage;
-(UIImage *)saveImage;

-(BOOL) checkInAreaToCrop: (CGPoint)currentPoint;
-(BOOL) checkInCornnerTopLeftOfAreaToCrop: (CGPoint)currentPoint;

@end
