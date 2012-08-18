//
//  SaveorDiscardPhotoViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "SaveorDiscardPhotoViewController.h"
#import "ContinueAfterSaveViewController.h"

@implementation SaveorDiscardPhotoViewController
{
    UIScrollView *scrollImage;
}

@synthesize image;
@synthesize imageView;
@synthesize urlImage ;
@synthesize imageViewBack;
@synthesize fromLib;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect

{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return cropped;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(fromLib == NO)
    {
        self.imageViewBack.image = self.image;
    
        CGSize viewSize = self.imageViewBack.bounds.size;
        UIGraphicsBeginImageContextWithOptions(viewSize, NO, 1.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.imageViewBack.layer renderInContext:context];
        UIImage *imageX = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    
        CGFloat x = self.imageView.frame.origin.x;
        CGFloat y = self.imageView.frame.origin.y;
        CGFloat width = self.imageView.frame.size.width;
        CGFloat height = self.imageView.frame.size.height;
    
        CGImageRef cropOfImage = CGImageCreateWithImageInRect(imageX.CGImage, CGRectMake(x, y, width, height));
    
        UIImage *croppedImage = [UIImage imageWithCGImage:cropOfImage];
        //imageView.image = croppedImage;
        self.image = croppedImage;
        //self.imageView.image = self.image;
    }else
    {
        scrollImage = [[UIScrollView alloc] initWithFrame:self.imageView.frame];
        [scrollImage setScrollEnabled:YES];
        //[scrollImage setContentSize:self.image.size];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:self.image];
        [imgView setFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
        
        
        [scrollImage setContentSize:imgView.frame.size];
        [scrollImage setShowsHorizontalScrollIndicator:NO];
        [scrollImage setShowsVerticalScrollIndicator:NO];

        [scrollImage addSubview:imgView];
        [self.view addSubview:scrollImage];
    }
   
}

-(UIImage *)imageCaptureSave: (UIView *)viewInput
{
    CGSize viewSize = viewInput.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [viewInput.layer renderInContext:context];
    UIImage *imageX = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageX;
}

- (void)viewDidUnLoad
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.image = nil;
    self.imageView = nil;
    self.urlImage = nil;
    self.imageViewBack =nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBAction
-(IBAction)save:(id)sender
{
    if(fromLib)
    {
        UIImage *viewImage = [self imageCaptureSave:self.view];
        CGFloat x = self.imageView.frame.origin.x;
        CGFloat y = self.imageView.frame.origin.y;
        CGFloat width = self.imageView.frame.size.width;
        CGFloat height = self.imageView.frame.size.height;
        
        CGImageRef cropOfImage = CGImageCreateWithImageInRect(viewImage.CGImage, CGRectMake(x, y, width, height));
        
        UIImage *croppedImage = [UIImage imageWithCGImage:cropOfImage];
        //imageView.image = croppedImage;
        self.image = croppedImage;
    }
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    __block NSString *urlString;
    
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
     {
         urlString = [assetURL absoluteString];

         self.urlImage = urlString;
         ContinueAfterSaveViewController *updateImageViewController = [[ContinueAfterSaveViewController alloc] initWithNibName:@"ContinueAfterSaveViewController" bundle:nil];
         updateImageViewController.imageInput = self.image;
         updateImageViewController.urlImage = self.urlImage;
         
         [self.navigationController pushViewController:updateImageViewController animated:YES];
         
         [library assetForURL:assetURL resultBlock:^(ALAsset *asset )
          {
              NSLog(@"we have our ALAsset!");
          } 
                 failureBlock:^(NSError *error )
          {
              NSLog(@"Error loading asset");
          }];
     }];
}



-(IBAction)discard:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
