//
//  SproutScrollView.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/4/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragDropImageView.h"

@class SproutScrollView;
@protocol SproutDelegate <UIScrollViewDelegate>

-(void)sproutDidSelectedViewImage: (SproutScrollView *) sprout: (DragDropImageView *) imageSelected;

-(void) moveImageInSprout: (SproutScrollView *)sprout from: (DragDropImageView *)fromItem to:(DragDropImageView *) toItem;

@end

@interface SproutScrollView : UIScrollView <DragDropImageViewDelegate>

@property (nonatomic, assign) NSInteger rowSize;
@property (nonatomic, assign) NSInteger colSize;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) DragDropImageView *imvSelected;
@property (assign, nonatomic) id <SproutDelegate> delegate;
@property (assign, nonatomic) BOOL enable;


-(id)initWithrowSize: (NSInteger) rs andColSize: (NSInteger) cs;
-(id) initWithArrayImage: (NSInteger)rs : (NSInteger) cs: (NSArray*) ai;
-(void) updateImageToSprout: (NSString *) imageURL  inTag:(NSInteger)cellTag;
-(void) reloadImageOfSprout: (NSString *)sName;



@end
