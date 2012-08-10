//
//  EditImageViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "EditImageViewController.h"
#import "ExportSproutViewController.h"
#import "StyleColorView.h"

@implementation EditImageViewController
{
    BOOL change;
    NSInteger rotate;
}


@synthesize imageToEdit;
@synthesize frameForEdit;
@synthesize areForEdit;
@synthesize frontViewChangeColor;
@synthesize delegate;
@synthesize preoviousImage;
@synthesize urlOfImage;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.frameForEdit.image = self.imageToEdit;
    NSLog(@"Orientation = %@", self.imageToEdit.imageOrientation);
    change = NO;
    rotate = 0;
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageToEdit = nil;
    self.frameForEdit = nil;
    self.areForEdit = nil;
    self.frontViewChangeColor = nil;
    self.delegate = nil;
    self.preoviousImage = nil;
    self.urlOfImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBAction

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender
{
    if(preoviousImage != nil)
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        __block NSString *urlString;
        
        [library writeImageToSavedPhotosAlbum:self.preoviousImage.CGImage orientation:(ALAssetOrientation)self.preoviousImage.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             urlString = [assetURL absoluteString];
             self.urlOfImage = urlString;
             
             [self.delegate saveImage:self withImage:preoviousImage andURL:urlOfImage];
             
             [self.navigationController popViewControllerAnimated:YES];
             
             [library assetForURL:assetURL resultBlock:^(ALAsset *asset )
              {
                  NSLog(@"we have our ALAsset!");
              } 
                     failureBlock:^(NSError *error )
              {
                  NSLog(@"Error loading asset");
              }];
         }];
    }else if(change)
    {
        UIImage *img = [self.areForEdit saveImage];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        __block NSString *urlString;
        
        [library writeImageToSavedPhotosAlbum:img.CGImage orientation:(ALAssetOrientation)img.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             urlString = [assetURL absoluteString];
             self.urlOfImage = urlString;
             
             [self.delegate saveImage:self withImage:img andURL:urlOfImage];
             
             [self.navigationController popViewControllerAnimated:YES];
             
             [library assetForURL:assetURL resultBlock:^(ALAsset *asset )
              {
                  NSLog(@"we have our ALAsset!");
              } 
                     failureBlock:^(NSError *error )
              {
                  NSLog(@"Error loading asset");
              }];
         }];

        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(IBAction)exportImage:(id)sender
{
    ExportSproutViewController *exportSproutViewController = [[ExportSproutViewController alloc] initWithNibName:@"ExportSproutViewController" bundle:nil];
    
    [self.navigationController pushViewController:exportSproutViewController animated:YES];
}

-(IBAction)changeColor:(id)sender
{
    StyleColorView *styleView;
    NSArray *nibObjects;
    nibObjects = [[NSBundle mainBundle]loadNibNamed:@"StyleColorView" owner:self options:nil];
    
    for(id currentObject in nibObjects)
    {
        styleView = (StyleColorView *)currentObject;
    }
    
    //styleView.backgroundColor = [UIColor clearColor];
    styleView.frame = CGRectMake(0.0f, 330.f, 320.f, 130.f);
    styleView.delegate = self;
    [styleView loadViewController];
    [self.view addSubview:styleView];
}

-(IBAction)cropImage:(id)sender
{
    [self.areForEdit createAreaToCrop];
    StyleCropView *styleView;
    NSArray *nibObjects;
    nibObjects = [[NSBundle mainBundle]loadNibNamed:@"StyleCropView" owner:self options:nil];
    
    for(id currentObject in nibObjects)
    {
        styleView = (StyleCropView *)currentObject;
    }
    
    styleView.frame = CGRectMake(0.0f, 380.f, 320.f, 80.f);
    styleView.delegate = self;
    [self.view addSubview:styleView];

}

-(IBAction)changeEffect:(id)sender
{
    
}

-(IBAction)rotateImage:(id)sender
{
    rotate += 90;
    change = YES;
    if(rotate == 360)
    {
        rotate = 0;
    }
    
    self.frameForEdit.transform = CGAffineTransformMakeRotation(rotate/180.f *M_PI);
    
}

-(void)changeColor:(StyleColorView *)view valueRed:(CGFloat)red valueGreen:(CGFloat)green valueBlue:(CGFloat)blue
{
    //NSLog(@"Red: %f Green : %f Blue: %f", red, green, blue);
    self.frontViewChangeColor.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
}

-(void)closeFrame:(StyleCropView *)view
{
    [view removeFromSuperview];
    [self.areForEdit removeAreaToCropFromView];
}

-(void)cropImageInFrame:(StyleCropView *)view
{
    UIImage *imageCropped = [self.areForEdit cropImage];
    self.frameForEdit.image = imageCropped;
    self.preoviousImage = imageCropped;
}

-(void)resizeFrame:(StyleCropView *)view :(CGFloat)value
{
    [self.areForEdit resizeArea:value];
}

-(void)undoImage:(StyleCropView *)view
{
    self.frameForEdit.image = self.imageToEdit;
    self.preoviousImage = nil;
}


@end
