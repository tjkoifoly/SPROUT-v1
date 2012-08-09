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

@synthesize image;
@synthesize imageView;
@synthesize urlImage ;
@synthesize imageViewBack;

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
    
    self.imageViewBack.image = self.image;
    /*
    UIImage *imageX = [self imageByCropping:self.image toRect:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    imageView.image = imageX;
     */
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
   /* 
    CGSize viewSize = self.imageView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 0.0);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, [self.imageViewBack center].x, [self.imageViewBack center].y);
    CGContextTranslateCTM(context,
                          -self.imageView.bounds.size.width * [[self.imageViewBack layer] anchorPoint].x,
                          -self.imageView.bounds.size.height * [[self.imageViewBack layer] anchorPoint].y);
    [self.imageViewBack.layer renderInContext:context];

    // Read the UIImage object
    UIImage *imageX = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"%@", imageX);
    
    //imageViewBack.image = nil;
    imageView.image = imageX;
    */
    /*
    CGFloat ratioWith = self.imageView.bounds.size.width / self.imageViewBack.bounds.size.width;
    CGFloat ratioHeiht = self.imageView.bounds.size.height / self.imageViewBack.bounds.size.height;
    
    CGFloat ratioX = self.imageView.frame.origin.x / self.view.bounds.size.width;
    CGFloat ratioY = self.imageView.frame.origin.y / self.view.bounds.size.height;
    CGFloat imageWith = self.image.size.width;
    CGFloat imageHeith = self.image.size.height;
    
    CGImageRef cropOfImage = CGImageCreateWithImageInRect(self.image.CGImage, CGRectMake(ratioX * imageWith, ratioY*imageHeith, ratioWith * imageWith, ratioHeiht *imageHeith));
    
    UIImage *imageX = [UIImage imageWithCGImage:cropOfImage];
    self.imageView.image = imageX;
     */
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
