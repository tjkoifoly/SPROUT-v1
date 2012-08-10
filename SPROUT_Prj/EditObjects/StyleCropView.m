//
//  StyleCropView.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/9/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "StyleCropView.h"

@implementation StyleCropView

@synthesize delegate;

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

-(IBAction)resize:(id)sender
{
    UISlider *sliderResize = (UISlider *)sender;
    [self.delegate resizeFrame:self :sliderResize.value];
}

-(IBAction)crop:(id)sender
{
    [self.delegate cropImageInFrame:self];
}

-(IBAction)close:(id)sender
{
    [self.delegate closeFrame:self];
}
-(IBAction)undo:(id)sender
{
    [self.delegate undoImage:self];
}

@end
