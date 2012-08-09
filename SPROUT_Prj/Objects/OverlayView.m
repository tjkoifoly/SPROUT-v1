//
//  OverlayView.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/7/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

@synthesize buttonCap;
@synthesize buttonLib;
@synthesize buttonHome;
@synthesize delegate;

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
        
        UIButton *homeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [homeButton setBackgroundImage:[UIImage imageNamed:@"Homebut.png"] forState:UIControlStateNormal];
        homeButton.frame = CGRectMake(0,0,100 ,100);
        
        [self addSubview:homeButton];
        
        UIButton *libButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [libButton setBackgroundImage:[UIImage imageNamed:@"LoadI.png"] forState:UIControlStateNormal];
        libButton.frame = CGRectMake(220,0,100 ,100);
        
        [self addSubview:libButton];
        
        UIButton *capButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [capButton setBackgroundImage:[UIImage imageNamed:@"Cap.png"] forState:UIControlStateNormal];
        capButton.frame = CGRectMake(127,381,57 ,59);
        
        [self addSubview:capButton];
        
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

-(IBAction)buttonPressed:(id)sender
{
    UIButton * button = (UIButton *)sender;
    
    [self.delegate overlayButtonPressed:self withTag:button.tag];
}

@end
