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

-(void)changeSatuation: (StyleColorView *)view withValue: (CGFloat)valueS;
-(void)changeHue: (StyleColorView *)view withValue: (CGFloat)valueH;
-(void)changeSystemColor: (StyleColorView *)view to: (NSInteger) indexColor;
-(void)closeStyle: (StyleColorView *)view;

-(void)changeHUeIOS4: (CGFloat)hue withSatuation: (CGFloat)satu;
-(void)changeSatuationIOS4: (CGFloat) satu withHue: (CGFloat)hue;

@end

@interface StyleColorView : UIView

@property (assign, nonatomic) id <ChangeColorDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *closeStyleView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *switchControl;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UISlider *sSlider;

-(IBAction)closeView:(id)sender;
-(IBAction)sliderChange:(id)sender;
-(IBAction)sSliderChange:(id)sender;
-(void)loadViewController;
-(IBAction)switchSystemColor:(id)sender;

@end
