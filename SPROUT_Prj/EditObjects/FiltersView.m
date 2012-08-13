//
//  FiltersView.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/10/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "FiltersView.h"

@implementation FiltersView

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

-(IBAction)close:(id)sender
{
    [self.delegate closeFilter:self];
}

-(IBAction)normal:(id)sender
{
    [self.delegate filterApply:self typeFilter:1];
}
-(IBAction)sepia:(id)sender
{
    [self.delegate filterApply:self typeFilter:2];    
}
-(IBAction)antique:(id)sender
{
    [self.delegate filterApply:self typeFilter:3];    
}
-(IBAction)blur:(id)sender
{
    [self.delegate filterApply:self typeFilter:4];    
}
-(IBAction)vignette:(id)sender
{
    [self.delegate filterApply:self typeFilter:5];    
}
-(IBAction)blackWhite:(id)sender
{
    [self.delegate filterApply:self typeFilter:6];
}

@end
