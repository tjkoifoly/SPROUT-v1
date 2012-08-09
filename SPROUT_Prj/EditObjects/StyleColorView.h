//
//  StyleColorView.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/9/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StyleColorView;
@protocol ChangeColorDelegate <NSObject>

-(void)changeColor: (StyleColorView *)view valueRed: (CGFloat)red valueGreen: (CGFloat)green valueBlue: (CGFloat) blue;

@end

@interface StyleColorView : UIView

@property (assign, nonatomic) id <ChangeColorDelegate> delegate;

@property (strong, nonatomic) IBOutlet UISlider*  sliderColorRed;
@property (strong, nonatomic) IBOutlet UISlider*  sliderColorGreen;
@property (strong, nonatomic) IBOutlet UISlider*  sliderColorBlur;
@property (strong, nonatomic) IBOutlet UIButton *closeStyleView;

-(IBAction)closeView:(id)sender;
-(void)loadViewController;

@end
