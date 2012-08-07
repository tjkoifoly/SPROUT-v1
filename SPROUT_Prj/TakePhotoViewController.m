//
//  SplashViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "SaveorDiscardPhotoViewController.h"
#import "ContinueAfterSaveViewController.h"
#import "DragDropImageView.h"
#import "Sprout.h"
#import "OverlayView.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define SCREEN_WIDTH 320
#define SCREEN_HEIGTH 480
// Transform values for full screen support:
#define CAMERA_TRANSFORM_X 1
//#define CAMERA_TRANSFORM_Y 1.12412 //use this is for iOS 3.x
#define CAMERA_TRANSFORM_Y 1.24299 // use this is for iOS 4.x

@implementation TakePhotoViewController

@synthesize pickerImage;
@synthesize imageView;
@synthesize newMedia;
@synthesize save;

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
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pickerImage = nil;
    self.imageView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma PickerImage delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker 
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"Image = %@", image);
    NSLog(@"Info = %@",editingInfo);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    
    if( [picker sourceType] == UIImagePickerControllerSourceTypeCamera )
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             NSLog(@"IMAGE SAVED TO PHOTO ALBUM");
             [library assetForURL:assetURL resultBlock:^(ALAsset *asset )
              {
                  NSLog(@"we have our ALAsset!");
              } 
                     failureBlock:^(NSError *error )
              {
                  NSLog(@"Error loading asset");
              }];
         }];
    }else
    {
    
        UIImage *i = [info objectForKey:UIImagePickerControllerOriginalImage];
    
        NSLog(@"Image = %@", i);
    
        ContinueAfterSaveViewController *continueViewController = [[ContinueAfterSaveViewController alloc] initWithNibName:@"ContinueAfterSaveViewController" bundle:nil];
    
        continueViewController.imageInput = i;
    
        [self.navigationController pushViewController:continueViewController animated:YES];
    }
    
    [self dismissModalViewControllerAnimated:YES];    
}




#pragma IBAction

-(IBAction)capture:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        OverlayView *overlay = [[OverlayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        
        imagePicker.sourceType = 
        UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        
        imagePicker.allowsEditing = NO;
        //imagePicker.showsCameraControls = NO;
        imagePicker.navigationBarHidden = YES;
        imagePicker.cameraViewTransform = CGAffineTransformScale(imagePicker.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
        
        imagePicker.cameraOverlayView = overlay;
        
        [self presentModalViewController:imagePicker 
                                animated:YES];
        newMedia = YES;
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"WARNING:"
                              message: @"No detect camera on device!"
                              delegate: nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil];
        [alert show];

    }
    /*
    SaveorDiscardPhotoViewController *saveViewController = [[SaveorDiscardPhotoViewController alloc] initWithNibName:@"SaveorDiscardPhotoViewController" bundle:nil];
    [self.navigationController pushViewController:saveViewController animated:YES];
     */
}

-(IBAction)goToHome :(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)loadImageFromLibrary:(id)sender
{
    
    if(self.pickerImage == nil)
    {
        self.pickerImage = [[UIImagePickerController alloc] init];
        self.pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    self.pickerImage.delegate = self;
    
    [self presentModalViewController:pickerImage animated:YES];
}

-(void)image:(UIImage *)image
    finishedSavingWithError:(NSError *)error 
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}



@end
