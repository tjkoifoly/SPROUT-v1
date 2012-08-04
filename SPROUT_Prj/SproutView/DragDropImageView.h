//
//  DragDropImageView.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/4/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragDropImageView : UIImageView

@property (assign, nonatomic) int tag;
@property (assign, nonatomic) int locationx;
@property (assign, nonatomic) int locationy;

@end
