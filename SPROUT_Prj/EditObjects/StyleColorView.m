//
//  StyleColorView.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/9/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "StyleColorView.h"

@implementation StyleColorView

@synthesize closeStyleView;
@synthesize delegate;
@synthesize switchControl;
@synthesize slider;
@synthesize sSlider;

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

-(void)loadViewController
{
    
}

-(IBAction)sliderChange:(id)sender
{
    [self.delegate changeHue:self withValue:((UISlider *)sender).value];
}

-(IBAction)sSliderChange:(id)sender
{
    [self.delegate changeSatuation:self withValue:((UISlider *)sender).value];
}

-(IBAction)closeView:(id)sender
{
    [self.delegate closeStyle:self];
}

-(IBAction)switchSystemColor:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    
    [self.delegate changeSystemColor:self to:(int)[seg selectedSegmentIndex]];
    
    if([seg selectedSegmentIndex] == 1)
    {
        slider.hidden = YES;
        sSlider.hidden = NO;
        
    }else
    {
        slider.hidden = NO;
        sSlider.hidden = YES;
    }
}

@end
