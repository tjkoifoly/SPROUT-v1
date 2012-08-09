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

@end

@interface OverlayView : UIView

@property (assign, nonatomic) id <OverlayViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *buttonHome;
@property (strong, nonatomic) IBOutlet UIButton *buttonLib;
@property (strong, nonatomic) IBOutlet UIButton *buttonCap;

-(IBAction)buttonPressed:(id)sender;

@end
