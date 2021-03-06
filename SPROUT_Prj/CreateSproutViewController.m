//
//  CreateSproutViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CreateSproutViewController.h"
#import "DragToSproutViewController.h"
#import "ExportSproutViewController.h"
#import "SaveorDiscardPhotoViewController.h"
#import "ViewPhotoInSproutViewController.h"
#import "UploadToSproutViewController.h"
#import "CNCAppDelegate.h"
#import "OverlayView.h"
#import "TakePhotoViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ContinueAfterSaveViewController.h"

#define SCREEN_WIDTH 320
#define SCREEN_HEIGTH 480
// Transform values for full screen support:
#define CAMERA_TRANSFORM_X 1
//#define CAMERA_TRANSFORM_Y 1.12412 //use this is for iOS 3.x
#define CAMERA_TRANSFORM_Y 1.24299 // use this is for iOS 4.x

@implementation CreateSproutViewController

@synthesize pickerImage;
@synthesize imageView;
@synthesize sprout;
@synthesize sproutView;
@synthesize delegate;
@synthesize fontFrame;

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
    NSLog(@"%i %i", sprout.rowSize, sprout.colSize);
        
    CGPoint center = CGPointMake(self.sproutView.frame.size.width / 2., self.sproutView.frame.size.height / 2.);
    self.sprout.delegate = self;
    self.sprout.center = center;
    [self.sproutView addSubview:self.sprout];
    
    //Set Font Frame Sprout
    CGRect frame1 = self.sproutView.frame;
    CGRect frame2 = self.sprout.frame;
    
    CGRect newFrame = CGRectMake(frame1.origin.x+frame2.origin.x - 5 , frame1.origin.y+frame2.origin.y - 5, frame2.size.width+ 10, frame2.size.height + 10);
    [self.fontFrame setFrame:newFrame];

    self.sproutView.backgroundColor = [UIColor clearColor];
    
    NSLog(@"%@ - %i - %i", self.sprout.name, self.sprout.rowSize, self.sprout.colSize);
    
    [self performSelector:@selector(autoResize)];
    
    
    }

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pickerImage = nil;
    self.sprout = nil;
    self.sproutView = nil;
    self.delegate = nil;
    self.fontFrame  = nil;
}

-(void)autoResize
{
    for(id aobj in self.sprout.subviews)
    {
        CGRect frame = [aobj frame];
        CGRect newFrame = CGRectMake(frame.origin.x + 2, frame.origin.y +2, frame.size.width - 4, frame.size.height - 4);
        [aobj setFrame:newFrame];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
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
    [self dismissModalViewControllerAnimated:YES]; 

    if( [picker sourceType] == UIImagePickerControllerSourceTypeCamera )
    {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        __block NSString *urlString;
        
        [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             urlString = [assetURL absoluteString];
             
             
             /*
              UIAlertView *alert = [[UIAlertView alloc]
              initWithTitle: @"Saved to : "
              message: urlString
              delegate: nil
              cancelButtonTitle:@"OK"
              otherButtonTitles:nil];
              [alert show];
              */
             [Sprout createSprout:self.sprout.name :self.sprout.rowSize :self.sprout.colSize];
             
             ContinueAfterSaveViewController *continueViewController = [[ContinueAfterSaveViewController alloc] initWithNibName:@"ContinueAfterSaveViewController" bundle:nil];
             
             continueViewController.urlImage = [assetURL absoluteString];
             continueViewController.imageInput = image;
             
             
             [self.navigationController pushViewController:continueViewController animated:YES];
             
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
    
    else
    {
        [Sprout createSprout:self.sprout.name :self.sprout.rowSize :self.sprout.colSize];
        
        UIImage *i = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.imageView.image = i;
        NSString *urlImage = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
        SaveorDiscardPhotoViewController *saveOrDiscardVC = [[SaveorDiscardPhotoViewController alloc] initWithNibName:@"SaveorDiscardPhotoViewController" bundle:nil];
        saveOrDiscardVC.image = i;
        saveOrDiscardVC.urlImage = urlImage;
        saveOrDiscardVC.fromLib = YES;
        
        self.delegate = [[self.navigationController viewControllers]objectAtIndex:0];
        
        [self.delegate loadFromLibOK:saveOrDiscardVC];
    /*
        DragToSproutViewController *dragViewController = [[DragToSproutViewController alloc] initWithNibName:@"DragToSproutViewController" bundle:nil];
    
        dragViewController.imageInput = i;
        
        dragViewController.urlImage = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
        
        dragViewController.sprout = [Sprout sproutForName:self.sprout.name];
    
        [self.navigationController pushViewController:dragViewController animated:YES];
     */
    }
    
}



#pragma IBAction

-(IBAction)loadImageFromLibrary:(id)sender
{
    
    if(self.pickerImage == nil)
    {
        self.pickerImage = [[UIImagePickerController alloc] init];
        self.pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.pickerImage.delegate = self;
    
    [self presentModalViewController:pickerImage animated:YES];
}



-(IBAction)goToHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender
{
    //SAVE sprout to database method
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSLog(@"%@", documentDirectory);
    
    if([Sprout createSprout:self.sprout.name :self.sprout.rowSize :self.sprout.colSize])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful!" message:@"Sprout saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    //[self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:([self.navigationController.childViewControllers indexOfObject:self] - 2)] animated:YES];
}

-(IBAction)share:(id)sender
{
    ExportSproutViewController *exportSproutViewController = [[ExportSproutViewController alloc] initWithNibName:@"ExportSproutViewController" bundle:nil];
    
    [self.navigationController pushViewController:exportSproutViewController animated:YES];
}

-(IBAction)capture:(id)sender
{
    [Sprout createSprout:self.sprout.name :self.sprout.rowSize :self.sprout.colSize];
    
    self.delegate = [[self.navigationController viewControllers]objectAtIndex:0];
    [self.delegate gotoCapturePhoto];
}

-(void)sproutDidSelectedViewImage:(SproutScrollView *)sprout :(DragDropImageView *)imageSelected
{
}

-(void)moveImageInSprout:(SproutScrollView *)sprout from:(DragDropImageView *)fromItem to:(DragDropImageView *)toItem
{

}

@end
