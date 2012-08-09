//
//  StyleColorView.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/9/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "StyleColorView.h"

@implementation StyleColorView

@synthesize sliderColorRed;
@synthesize sliderColorBlur;
@synthesize sliderColorGreen;
@synthesize closeStyleView;
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
-(void)loadViewController
{
    [sliderColorRed setMaximumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorGreen setMaximumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorBlur setMaximumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider.png" ofType:nil]] forState:UIControlStateNormal];

    
    [sliderColorRed setMinimumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider1.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorGreen setMinimumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider2.png" ofType:nil]] forState:UIControlStateNormal];
    [sliderColorBlur setMinimumTrackImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider3.png" ofType:nil]] forState:UIControlStateNormal];
    
    [sliderColorRed setThumbImage: [UIImage imageNamed:@"whiteSlide.png"] forState:UIControlStateNormal];
    [sliderColorGreen setThumbImage: [UIImage imageNamed:@"whiteSlide.png"] forState:UIControlStateNormal];
    [sliderColorBlur setThumbImage: [UIImage imageNamed:@"whiteSlide.png"] forState:UIControlStateNormal];
    
    [sliderColorRed addTarget:self action:@selector(updateColorRed:) forControlEvents:UIControlEventValueChanged];
    [sliderColorGreen addTarget:self action:@selector(updateColorGreen:) forControlEvents:UIControlEventValueChanged];
    [sliderColorBlur addTarget:self action:@selector(updateColorBlur:) forControlEvents:UIControlEventValueChanged];
    
    [sliderColorRed setMinimumValue:0.0f]; [sliderColorRed setMaximumValue:1.0f]; [sliderColorRed setValue:1.0f];
    [sliderColorGreen setMinimumValue:0.0f]; [sliderColorGreen setMaximumValue:1.0f]; [sliderColorGreen setValue:1.0f];
    [sliderColorBlur setMinimumValue:0.0f]; [sliderColorBlur setMaximumValue:1.0f]; [sliderColorBlur setValue:1.0f];
}

- (void) updateColorRed: (UISlider *) slider
{
    [self.delegate changeColor:self valueRed:slider.value valueGreen:self.sliderColorGreen.value valueBlue:self.sliderColorBlur.value];
}

- (void) updateColorGreen: (UISlider *) slider
{
    [self.delegate changeColor:self valueRed:self.sliderColorRed.value valueGreen:self.sliderColorGreen.value valueBlue:slider.value];
}

- (void) updateColorBlur: (UISlider *) slider
{
    [self.delegate changeColor:self valueRed:self.sliderColorRed.value valueGreen:slider.value valueBlue:self.sliderColorBlur.value];
}


-(IBAction)closeView:(id)sender
{
    [self removeFromSuperview];
}

@end
