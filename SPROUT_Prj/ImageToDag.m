//
//  ImageToDag.m
//  DragDrop
//
//  Created by Nguyen Chi Cong on 8/1/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ImageToDag.h"

@implementation ImageToDag

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint activePoint = [[touches anyObject] locationInView:self];
    
    CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - currentPoint.x), self.center.y + (activePoint.y - currentPoint.y));
    
    float midPointx = CGRectGetMidX(self.bounds);
    
    if(newPoint.x > self.superview.bounds.size.width - midPointx)
    {
        newPoint.x = self.superview.bounds.size.width - midPointx;
    }else if(newPoint.x < midPointx)
    {
        newPoint.x = midPointx;
    }
    
    float midPointY = CGRectGetMidY(self.bounds);
    // If too far down...
    if (newPoint.y > self.superview.bounds.size.height  - midPointY)
        newPoint.y = self.superview.bounds.size.height - midPointY;
    else if (newPoint.y < midPointY)  // If too far up...
        newPoint.y = midPointY;

    self.center = newPoint;

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}


@end
