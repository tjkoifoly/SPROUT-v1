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
{
    OverlayView *overlay;
}
@synthesize pickerImage;
@synthesize save;
@synthesize urlImage;
@synthesize isLibrary;

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
        isLibrary = NO;
    }else
    {
        isLibrary = YES;
    }
    
    if(isLibrary)
    {
        
    }else
    {
        self.pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.pickerImage.mediaTypes = [NSArray arrayWithObjects:
                                       (NSString *) kUTTypeImage,
                                       nil];
        self.pickerImage.allowsEditing          = NO;
        self.pickerImage.showsCameraControls    = NO;
        //self.pickerImage.navigationBarHidden    = YES;
        if(overlay == nil)
        {
            NSArray *nibObjects;
            nibObjects = [[NSBundle mainBundle]loadNibNamed:@"OverlayView" owner:self options:nil];
            
            for(id currentObject in nibObjects)
            {
                overlay = (OverlayView *)currentObject;
            }
            overlay.frame = CGRectMake(0.0f, 0.0f, 320.f, 480.f);
            overlay.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Untitled-1bg001.png"]];
            overlay.delegate = self;
            
            //[self.pickerImage.view setFrame:CGRectMake(0, 20, 320, 460)];
            [self.pickerImage.view addSubview:overlay];
        }else
        {
            overlay.hidden = NO;
        }
        
        
        [self.view addSubview:self.pickerImage.view];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pickerImage = [[UIImagePickerController alloc] init];
    self.pickerImage.delegate = self;
    isLibrary = NO;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pickerImage    = nil;
    self.urlImage       = nil;

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
            NSLog(@"LIBRARY");
            [self loadImageFromLibrary:nil];
            break;
        }
        case 3:
            NSLog(@"TAKE");
            //[self dismissModalViewControllerAnimated:NO];
            [self.pickerImage takePicture];
            break;
            
        default:
            break;
    }
}

#pragma PickerImage delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) picker 
{
    if(self.isLibrary)
    {
        self.isLibrary = NO;
        overlay.hidden = NO;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else
        {
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if( [picker sourceType] == UIImagePickerControllerSourceTypeCamera )
    {
        SaveorDiscardPhotoViewController *saveViewController = [[SaveorDiscardPhotoViewController alloc] initWithNibName:@"SaveorDiscardPhotoViewController" bundle:nil];
        saveViewController.image = image;
        
        [self.navigationController pushViewController:saveViewController animated:YES];
    }else
    {
        //NSLog(@"Image = %@", i);
        self.urlImage = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
        
        ContinueAfterSaveViewController *continueViewController = [[ContinueAfterSaveViewController alloc] initWithNibName:@"ContinueAfterSaveViewController" bundle:nil];
        
        continueViewController.urlImage = self.urlImage;
        continueViewController.imageInput = image;
        
        [self.navigationController pushViewController:continueViewController animated:YES];
        [self dismissModalViewControllerAnimated:NO];
    }
    
    
}

#pragma IBAction

-(IBAction)capture:(id)sender
{
    [self.pickerImage takePicture];
}

-(IBAction)goToHome :(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(IBAction)loadImageFromLibrary:(id)sender
{
    self.isLibrary = YES;
    overlay.hidden = YES;
    
    self.pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self presentModalViewController:pickerImage animated:YES];
    }
}



@end