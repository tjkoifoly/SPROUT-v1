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

@end

@interface StyleColorView : UIView

@property (assign, nonatomic) id <ChangeColorDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *closeStyleView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *switchControl;
@property (strong, nonatomic) IBOutlet UISlider *slider;

-(IBAction)closeView:(id)sender;
-(IBAction)sliderChange:(id)sender;
-(void)loadViewController;
-(IBAction)switchSystemColor:(id)sender;

@end
