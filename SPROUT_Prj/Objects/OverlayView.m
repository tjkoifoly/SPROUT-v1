//
//  OverlayView.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/7/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *overlayGraphic = [UIImage imageNamed:@"overlaygraphic.png"];
        UIImageView *overlayGraphicView = [[UIImageView alloc] initWithImage:overlayGraphic];
        overlayGraphicView.frame = CGRectMake(30, 100, 260, 200);
        
        [self addSubview:overlayGraphicView];
        
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

@end
