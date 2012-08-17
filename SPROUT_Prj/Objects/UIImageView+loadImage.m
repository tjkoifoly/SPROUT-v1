//
//  UIImageView+loadImage.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/16/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "UIImageView+loadImage.h"

@implementation UIImageView (loadImage)

-(void) loadImageFromLibAssetURL: (NSString *)urlString
{
    //NSLog(@"OKMEN - %@", urlString);
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    
    __block UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.hidesWhenStopped = YES;
    indicator.center = self.center;
    [self addSubview:indicator];
    [indicator startAnimating];
    
    ALAssetsLibraryAssetForURLResultBlock result = ^(ALAsset *__strong asset){
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        // This data retrieval crashes on the simulator
        CGImageRef cgImage = [assetRepresentation CGImageWithOptions:nil];
        if (cgImage)
        {
            //NSLog(@" image from here: %@",[UIImage imageWithCGImage:cgImage]);
            self.image = [UIImage imageWithCGImage:cgImage];
            [self setTag:1];
            NSLog(@"%@", self.image);
        }
        
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    };
    
    ALAssetsLibraryAccessFailureBlock failure = ^(NSError *__strong error){
        NSLog(@"Error retrieving asset from url: %@", [error localizedFailureReason]);
    };
    
    NSURL *assetURL = [NSURL URLWithString:urlString];
    [library assetForURL:assetURL resultBlock:result failureBlock:failure];
}

@end
