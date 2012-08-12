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
    if(switchControl.selectedSegmentIndex == 1)
    {
        [self.delegate changeSatuation:self withValue:((UISlider *)sender).value];
    }else
    {
        [self.delegate changeHue:self withValue:((UISlider *)sender).value];
    }
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
        [slider setMinimumValue:0.];
        [slider setValue:1.0];
    }else
    {
        [slider setMinimumValue:-2.0];
        [slider setValue:0.0];
    }
}

@end
