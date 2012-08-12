//
//  SquareEditView.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/9/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "SquareEditView.h"

@implementation SquareEditView
{
    CGPoint previousPoint;
}

@synthesize areaToCrop;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)createAreaToCrop
{
    self.areaToCrop = [[ImageToDag alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.f, 100.f)];
    
    self.areaToCrop.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2) ;
    
    self.areaToCrop.layer.borderColor = [UIColor whiteColor].CGColor;
    self.areaToCrop.layer.borderWidth = 3.f;

    [self addSubview:self.areaToCrop];
}

-(void)removeAreaToCropFromView
{
    [self.areaToCrop removeFromSuperview];
}

-(BOOL) checkInAreaToCrop: (CGPoint)currentPoint
{
    CGRect frame = self.areaToCrop.frame;
    if(currentPoint.x > (frame.origin.x+10)
       && currentPoint.x < ((frame.origin.x + frame.size.width)-10)
       && currentPoint.y > (frame.origin.y +10)
       && currentPoint.y < (frame.origin.y + frame.size.height -10))
    {
        return YES;
    }else
    {
        return NO;
    }
}

-(BOOL) checkInCornnerTopLeftOfAreaToCrop: (CGPoint)currentPoint
{
     CGRect frame = self.areaToCrop.frame;
    if((currentPoint.x > frame.origin.x
       && currentPoint.x < (frame.origin.x +10)
       && currentPoint.y > frame.origin.y)
       && currentPoint.y < frame.origin.y +10)
    {
        return YES;
    }else
        return NO;
}

-(void)resizeArea:(CGFloat)size
{
    CGPoint c = self.areaToCrop.center;
    [self.areaToCrop setFrame:CGRectMake(0.0f, 0.0f, size, size)];
    self.areaToCrop.center = c;
    if(self.areaToCrop.frame.origin.x < 0 || (self.areaToCrop.frame.origin.x+self.areaToCrop.frame.size.width )> self.bounds.size.width
       || self.areaToCrop.frame.origin.y < 0 
       || (self.areaToCrop.frame.origin.y+self.areaToCrop.frame.size.height) > self.bounds.size.height)
    {
        self.areaToCrop.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    }
    
}

-(UIImage *)cropImage
{
    self.areaToCrop.layer.borderWidth = 0.0f;
    
    CGSize viewSize = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *imageX = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat x = self.areaToCrop.frame.origin.x;
    CGFloat y = self.areaToCrop.frame.origin.y;
    CGFloat width = self.areaToCrop.frame.size.width;
    CGFloat height = self.areaToCrop.frame.size.height;
    
    CGImageRef cropOfImage = CGImageCreateWithImageInRect(imageX.CGImage, CGRectMake(x, y, width, height));
    
    UIImage *croppedImage = [UIImage imageWithCGImage:cropOfImage];
    self.areaToCrop.layer.borderWidth = 2.f;
    //[self removeAreaToCropFromView];
    return croppedImage;
}

-(UIImage *)saveImage
{
    self.areaToCrop.layer.borderWidth = 0.0f;
    CGSize viewSize = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *imageX = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //self.areaToCrop.layer.borderWidth = 2.f;
    return imageX;
}

@end
