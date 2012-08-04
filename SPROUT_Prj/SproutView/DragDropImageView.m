//
//  DragDropImageView.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/4/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "DragDropImageView.h"

#define kWidth 40
#define kHeight 40

@implementation DragDropImageView

@synthesize tag;
@synthesize locationx;
@synthesize locationy;

-(id) initWithLocation
{
    return [self initWithFrame:CGRectMake(locationy*kWidth, locationx*kHeight, kWidth, kHeight)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    switch ([touch tapCount]) {
        case 1:
        {
            [self performSelector:@selector(oneTap:) withObject:self.image afterDelay:.5];
        }
            break;
            
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTap:) object:nil];
            [self performSelector:@selector(twoTaps:) withObject:self.image afterDelay:.5];
            break;
            
        case 3:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(twoTaps:) object:nil];
            [self performSelector:@selector(threeTaps:) withObject:self.image afterDelay:.5];
            break;
            
        default:
            break;
    }
}

-(void)oneTap:(UIImage *)i
{
    NSLog(@"%@", i);
    NSLog(@"Single tap");
}

-(void)twoTaps :(UIImage *)i
{
    NSLog(@"Double tap");
}

-(void)threeTaps :(UIImage *) i 
{
    NSLog(@"Triple tap");
}


@end
