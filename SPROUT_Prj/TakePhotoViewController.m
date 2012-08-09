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
@synthesize urlImage;

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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self capture:nil];
    }

}

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
    self.urlImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma OverlayDelegate

-(void)overlayButtonPressed:(OverlayView *)view withTag:(NSInteger)buttonTag
{
    switch (buttonTag) {
        case 1:
            [self dismissModalViewControllerAnimated:NO];
            [self goToHome:nil];
            break;
        case 2:
        {
            [self dismissModalViewControllerAnimated:NO];
            [self loadImageFromLibrary:nil];
            break;
        }
        case 3:
            [self.pickerImage takePicture];
            break;
            
        default:
            break;
    }
}

#pragma PickerImage delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker 
{
    [self dismissModalViewControllerAnimated:YES];
    self.pickerImage = nil;
    [self capture:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if( [picker sourceType] == UIImagePickerControllerSourceTypeCamera )
    {
        self.imageView.image = image;
        SaveorDiscardPhotoViewController *saveViewController = [[SaveorDiscardPhotoViewController alloc] initWithNibName:@"SaveorDiscardPhotoViewController" bundle:nil];
        saveViewController.image = image;
        
        [self.navigationController pushViewController:saveViewController animated:YES];
        
        [self dismissModalViewControllerAnimated:NO];
        
    }else
    {
        //NSLog(@"Image = %@", i);
        self.urlImage = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    
        ContinueAfterSaveViewController *continueViewController = [[ContinueAfterSaveViewController alloc] initWithNibName:@"ContinueAfterSaveViewController" bundle:nil];
    
        continueViewController.urlImage = self.urlImage;
        continueViewController.imageInput = image;
    
        [self.navigationController pushViewController:continueViewController animated:YES];
        [self dismissModalViewControllerAnimated:YES]; 
    }
    self.pickerImage = nil;
    
    }

#pragma IBAction

-(IBAction)capture:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        OverlayView *overlay;
        NSArray *nibObjects;
        nibObjects = [[NSBundle mainBundle]loadNibNamed:@"OverlayView" owner:self options:nil];
        
        for(id currentObject in nibObjects)
        {
            overlay = (OverlayView *)currentObject;
        }
        overlay.frame = CGRectMake(0.0f, 0.0f, 320.f, 480.f);
        
        overlay.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Untitled-1bg001.png"]];
        overlay.delegate = self;

        self.pickerImage =
        [[UIImagePickerController alloc] init];
        
        self.pickerImage.delegate = self;
        
        self.pickerImage.sourceType = 
        UIImagePickerControllerSourceTypeCamera;
        
        self.pickerImage.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        
        self.pickerImage.allowsEditing = NO;
        self.pickerImage.showsCameraControls = NO;
        //imagePicker.showsCameraControls = NO;
        self.pickerImage.navigationBarHidden = YES;
        //self.pickerImage.cameraViewTransform = CGAffineTransformScale(self.pickerImage.cameraViewTransform, CAMERA_TRANSFORM_X, CAMERA_TRANSFORM_Y);
        
        self.pickerImage.cameraOverlayView = overlay;
        
        [self presentModalViewController:self.pickerImage 
                                animated:NO];
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
    self.pickerImage = [[UIImagePickerController alloc] init];
    self.pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    self.pickerImage.delegate = self;
    
    [self presentModalViewController:pickerImage animated:YES];
}



@end
