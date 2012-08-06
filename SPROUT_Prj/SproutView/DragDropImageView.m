//
//  DragDropImageView.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/4/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DragDropImageView.h"
#import "ViewPhotoInSproutViewController.h"
#import <AssetsLibrary/ALAssetRepresentation.h>


#define kWidth 40
#define kHeight 40

@implementation DragDropImageView

@synthesize tag;
@synthesize locationx;
@synthesize locationy;
@synthesize delegate;
@synthesize url;


-(id) initWithLocationX: (NSInteger) x andY: (NSInteger) y
{
    self.locationx = x;
    self.locationy = y;
    
    self = [super initWithFrame:CGRectMake(locationy*kWidth, locationx*kHeight, kWidth, kHeight)];
    
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1.f;
    
    [self loadImageFromAssetURL:[NSURL URLWithString:self.url]];
    
    return self;
}

-(id) initWithLocationX: (NSInteger) x andY: (NSInteger) y fromURL: (NSString *)urlimage
{
    self.locationx = x;
    self.locationy = y;
    
    self = [super initWithFrame:CGRectMake(locationy*kWidth, locationx*kHeight, kWidth, kHeight)];
    
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1.f;
    
    [self loadImageFromAssetURL:[NSURL URLWithString:urlimage]];
    
    return self;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    switch ([touch tapCount]) {
        case 1:
            [self performSelector:@selector(oneTap) withObject:nil afterDelay:.5];
        
            break;
            
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(oneTap) object:nil];
            [self performSelector:@selector(twoTaps) withObject:nil afterDelay:.5];
            break;
            
        case 3:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(twoTaps) object:nil];
            [self performSelector:@selector(threeTaps) withObject:nil afterDelay:.5];
            break;
            
        default:
            break;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate touchInAImage:self];
    NSLog(@"PASS");
}

-(void)oneTap
{
    NSLog(@"Single tap");
    NSLog(@"Tag = %i", self.tag);
    [self.delegate touchInAImage:self];
}

-(void)twoTaps
{
    NSLog(@"Double tap");
    NSLog(@"Tag = %i", self.tag);
    [self.delegate dragDropImageView:self];
}

-(void)threeTaps 
{
    NSLog(@"Triple tap");
    NSLog(@"Tag = %i", self.tag);
}

- (void)loadImageFromAssetURL: (NSURL *)assetURL
{
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    
    ALAssetsLibraryAssetForURLResultBlock result = ^(ALAsset *__strong asset){
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        // This data retrieval crashes on the simulator
        CGImageRef cgImage = [assetRepresentation CGImageWithOptions:nil]; 
    
        if (cgImage)
        {
    
            NSLog(@" image from here: %@",[UIImage imageWithCGImage:cgImage]);
            self.image = [UIImage imageWithCGImage:cgImage];
            NSLog(@"DCMCM: %@", self.image);
        }
        
    };
    
    ALAssetsLibraryAccessFailureBlock failure = ^(NSError *__strong error){
        NSLog(@"Error retrieving asset from url: %@", [error localizedFailureReason]);
    };
    
    [library assetForURL:assetURL resultBlock:result failureBlock:failure];
    
}


@end
