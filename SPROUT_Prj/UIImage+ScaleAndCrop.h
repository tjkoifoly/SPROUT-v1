//
//  UIImage+ScaleAndCrop.h
//  FashionApp
//
//  Created by Tran Ngoc Linh on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScaleAndCrop)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
