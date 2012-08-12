//
//  FiltersView.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/10/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersView;
@protocol FilterDelegate <NSObject>

-(void)closeFilter: (FiltersView *)view;

-(void)filterApply: (FiltersView *)view typeFilter: (NSInteger)type;

@end

@interface FiltersView : UIView

@property (assign, nonatomic) id <FilterDelegate> delegate;

-(IBAction)close:(id)sender;
-(IBAction)normal:(id)sender;
-(IBAction)sepia:(id)sender;
-(IBAction)antique:(id)sender;
-(IBAction)blur:(id)sender;
-(IBAction)vignette:(id)sender;

@end
