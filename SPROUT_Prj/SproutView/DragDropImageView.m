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
#import "SproutScrollView.h"
#import <AssetsLibrary/ALAssetRepresentation.h>

@implementation DragDropImageView
{
    NSTimeInterval touchStartTime;
}

@synthesize tag;
@synthesize locationx;
@synthesize locationy;
@synthesize delegate;
@synthesize url;


-(id) initWithLocationX: (NSInteger) x andY: (NSInteger) y : (NSInteger)size
{
    self.locationx = x;
    self.locationy = y;
    
    self = [super initWithFrame:CGRectMake(locationy*size, locationx*size, size, size)];
    
    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.f;
    
    return self;
}

-(id) initWithLocationX: (NSInteger) x andY: (NSInteger) y fromURL: (NSString *)urlimage : (NSInteger)size
{
    self = [self initWithLocationX:x andY:y :size];
    [self loadImageFromAssetURL:[NSURL URLWithString:urlimage]];
    self.url = urlimage;
    return self;

}

-(void)setUrlImage:(NSString *)urlString
{
    self.url = urlString;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchStartTime = [event timestamp];
    
    UITouch *touch = [touches anyObject];
    
    [(SproutScrollView *)self.superview imvSelected].alpha= 1.0f;
    
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
    NSTimeInterval touchTimeDuration = [event timestamp] - touchStartTime;
    
    NSLog(@"Touch duration: %3.2f seconds", touchTimeDuration);
    
    if(touchTimeDuration > 0.8f)
    {
        [self performSelector:@selector(threeTaps) withObject:nil];
    }
}

-(void)oneTap
{
    NSLog(@"Single tap");
    NSLog(@"Tag = %i", self.tag);
    
    if(![(SproutScrollView *)self.superview enable])
    {
        [self.delegate touchInAImage:self];
        NSLog(@"URL = %@", self.url);
        
    }else
    {
        if(self.image == nil)
        {
            NSLog(@"Sending delegate ....");
            
            //[self.delegate moveImageFrom:[(SproutScrollView *)self.superview imvSelected] to:self];
            
            self.image = [(SproutScrollView *)self.superview imvSelected].image;
            self.url = [(SproutScrollView *)self.superview imvSelected].url;
            [[(SproutScrollView *)self.superview imvSelected] setImage:nil];
            [(SproutScrollView *)self.superview imvSelected].url = @"URL";
            //NSLog(@"%@", [(SproutScrollView *)self.superview imvSelected].url);
        }
        [self.delegate touchEnableScroll:nil moveable:NO];
    }
    
}

-(void)twoTaps
{
    NSLog(@"Double tap");
    NSLog(@"Tag = %i", self.tag);
    [self.delegate touchEnableScroll:nil moveable:NO];
    if(self.image != nil)    
    {
        [self.delegate dragDropImageView:self];
    }
}

-(void)threeTaps 
{
    NSLog(@"Triple tap");
    NSLog(@"Tag = %i", self.tag);
    if(self.image != nil)
    {
        self.alpha = 0.35f;
        [self.delegate touchEnableScroll:self moveable:YES];
    }
    
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
    
            //NSLog(@" image from here: %@",[UIImage imageWithCGImage:cgImage]);
            self.image = [UIImage imageWithCGImage:cgImage];
//            NSLog(@"DCMCM: %@", self.image);
        }
        
    };
    
    ALAssetsLibraryAccessFailureBlock failure = ^(NSError *__strong error){
        NSLog(@"Error retrieving asset from url: %@", [error localizedFailureReason]);
    };
    
    [library assetForURL:assetURL resultBlock:result failureBlock:failure];
    
}


@end
