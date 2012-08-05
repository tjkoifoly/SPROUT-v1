//
//  SproutScrollView.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/4/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SproutScrollView : UIScrollView

@property (nonatomic, assign) NSInteger rowSize;
@property (nonatomic, assign) NSInteger colSize;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *images;

-(id)initWithrowSize: (NSInteger) rs andColSize: (NSInteger) cs;
-(void) updateImageToSprout: (NSMutableArray *) imagesOfSprout;

@end
