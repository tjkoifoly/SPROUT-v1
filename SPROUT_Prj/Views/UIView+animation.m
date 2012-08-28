//
//  UIView+animation.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/28/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "UIView+animation.h"

@implementation UIView (animations)

-(void)removeWithEffect
{
    [UIView beginAnimations:@"removeWithEffect" context:nil];
    [UIView setAnimationDuration:1.f];
    //Change frame parameters, you have to adjust
    self.frame = CGRectMake(0,0,320,480);
    self.alpha = 0.0f;
    [UIView commitAnimations];
    [self performSelector:@selector(removeFromSuperview) withObject:self afterDelay:1.f];
}

-(void)addSubview:(UIView *)view withAnimation:(BOOL)animation
{
    if(animation == YES)
    {
        [UIView beginAnimations:@"addSubviewEffect" context:nil];
        [UIView setAnimationDuration:1.0f];
        //Change frame parameters, you have to adjust
        self.frame = view.frame;
        self.alpha = 1.0f;
        [UIView commitAnimations];
        [self performSelector:@selector(addSubview:) withObject:view afterDelay:1.0f];
    }else
    {
        [self addSubview:view];
    }
}

-(void)showHidewithAnimation : (BOOL)show
{
    [UIView beginAnimations:@"showHideEffect" context:nil];
    [UIView setAnimationDuration:1.0f];
    //Change frame parameters, you have to adjust
    if(show)
        self.alpha = 0.5f;
    else
        self.alpha = 0.0f;
    [UIView commitAnimations];
    //[self performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:show] afterDelay:1.0f];
}


@end
