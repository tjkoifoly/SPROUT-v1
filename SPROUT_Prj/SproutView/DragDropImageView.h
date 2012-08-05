//
//  DragDropImageView.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/4/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DragDropImageView;

@protocol DragDropImageViewDelegate <NSObject>

-(void)dragDropImageView: (DragDropImageView *) imageViewSelected;

@end
@interface DragDropImageView : UIImageView

@property (retain, nonatomic) NSObject <DragDropImageViewDelegate> *delegate;

@property (assign, nonatomic) int tag;
@property (assign, nonatomic) int locationx;
@property (assign, nonatomic) int locationy;

-(id) initWithLocationX: (NSInteger) x andY: (NSInteger) y;

@end
