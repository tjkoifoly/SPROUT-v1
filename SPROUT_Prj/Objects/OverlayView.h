//
//  OverlayView.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/7/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OverlayView;
@protocol OverlayViewDelegate <NSObject>

-(void)overlayButtonPressed: (OverlayView *) view withTag: (NSInteger)buttonTag;
-(void)switchCamera: (OverlayView *)oView;
-(void)turnFlash: (OverlayView*)oView withState:(BOOL) state;

@end

@interface OverlayView : UIView

@property (assign, nonatomic) id <OverlayViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *buttonHome;
@property (strong, nonatomic) IBOutlet UIButton *buttonLib;
@property (strong, nonatomic) IBOutlet UIButton *buttonCap;
@property (strong, nonatomic) IBOutlet UIButton *switchButtonCamrera;
@property (strong, nonatomic) IBOutlet UISwitch *turnFlash;
@property (strong, nonatomic) IBOutlet UIImageView *flashStatus;
 
-(IBAction)buttonPressed:(id)sender;
-(IBAction)turnFlashAction:(id)sender;
-(IBAction)switchCameraType:(id)sender;
-(IBAction)turnOnFlash:(id)sender;
-(void)loadView;

@end
