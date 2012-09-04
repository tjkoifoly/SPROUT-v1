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
    NSString *reqSysVer = @"5.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([reqSysVer floatValue] > [currSysVer floatValue])
    {
        NSLog(@"IOS 4");
        [slider setMaximumValue:180];
        [slider setMinimumValue:-180.0];
        [slider setValue:0.0];
        
        [sSlider setMinimumValue:-100];
        [sSlider setMaximumValue:100.0];
        [sSlider setValue:0.0];
        return;
    }
    NSLog(@"IOS 5");
}

-(IBAction)sliderChange:(id)sender
{
    NSString *reqSysVer = @"5.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([reqSysVer floatValue] > [currSysVer floatValue])
    {
        [self.delegate changeHUeIOS4:slider.value withSatuation:sSlider.value];
        //
        return;
        
    }
    
    NSLog(@"slide value: %f x %f", slider.value, sSlider.value);
    
    [self.delegate changeHue:self withValue:((UISlider *)sender).value];
    
}

-(IBAction)sSliderChange:(id)sender
{
    NSString *reqSysVer = @"5.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([reqSysVer floatValue] > [currSysVer floatValue])
    {
        [self.delegate changeSatuationIOS4:sSlider.value withHue:slider.value];
        NSLog(@"IOS 4 slide value: %f", ((UISlider *)sender).value);
        return;
    }
    
    [self.delegate changeSatuation:self withValue:((UISlider *)sender).value];
    NSLog(@"IOS 5 slide value: %f", ((UISlider *)sender).value);

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
