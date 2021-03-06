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
-(void)touchEnableScroll: (DragDropImageView *) sender moveable: (BOOL)enableOK;
-(void)moveImageFrom: (DragDropImageView *)fromImage to: (DragDropImageView*)toImage;

@end
@interface DragDropImageView : UIImageView 

@property (retain, nonatomic) NSObject <DragDropImageViewDelegate> *delegate;

@property (assign, nonatomic) int tag;
@property (assign, nonatomic) int locationx;
@property (assign, nonatomic) int locationy;
@property (strong, nonatomic) NSString *url;

-(id) initWithLocationX: (NSInteger) x andY: (NSInteger) y : (NSInteger)size;
-(id) initWithLocationX: (NSInteger) x andY: (NSInteger) y fromURL: (NSString *)urlimage : (NSInteger)size;
-(id) initWithLocationX:(NSInteger)x andY:(NSInteger)y fromURL:(NSString *)urlimage :(NSInteger)size andPath: (NSString *)fileName;

- (void)loadImageFromAssetURL: (NSURL *)assetURL;
-(void)setUrlImage:(NSString *)urlString;
-(NSString *)dataPathFile:(NSString *)fileName;
-(UIImage *)loadImageFromFile: (NSString *)fileName;
-(void)getImageFromFile : (NSString *)fileName input: (UIImage *)inputImage;

@end
