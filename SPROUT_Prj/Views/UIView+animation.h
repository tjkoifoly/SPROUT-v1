//
//  UIView+animation.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/28/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (animations)

-(void)removeWithEffect;
-(void)addSubview:(UIView *)view withAnimation:(BOOL)animation;
-(void)showHidewithAnimation: (BOOL) show;

@end
