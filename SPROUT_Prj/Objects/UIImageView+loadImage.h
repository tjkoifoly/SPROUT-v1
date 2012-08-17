//
//  UIImageView+loadImage.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/16/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface UIImageView (loadImage)

-(void) loadImageFromLibAssetURL: (NSString *)urlString;

@end
