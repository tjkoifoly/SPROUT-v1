//
//  DragDropImageView.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/4/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

//assets-library://asset/asset.JPG?id=109CAF18-3A70-4384-9205-41CA01373030&ext=JPG

@class DragDropImageView;

@protocol DragDropImageViewDelegate <NSObject>

-(void)dragDropImageView: (DragDropImageView *) imageViewSelected;
-(void)touchInAImage: (DragDropImageView *) iSelected;
-(void)dropInGrid: (DragDropImageView *)toImv;
-(void)touchEnableScroll: (DragDropImageView *) sender;

@end
@interface DragDropImageView : UIImageView

@property (retain, nonatomic) NSObject <DragDropImageViewDelegate> *delegate;

@property (assign, nonatomic) int tag;
@property (assign, nonatomic) int locationx;
@property (assign, nonatomic) int locationy;
@property (strong, nonatomic) NSString *url;

-(id) initWithLocationX: (NSInteger) x andY: (NSInteger) y;
-(id) initWithLocationX: (NSInteger) x andY: (NSInteger) y fromURL: (NSString *)urlimage;

- (void)loadImageFromAssetURL: (NSURL *)assetURL;

@end
