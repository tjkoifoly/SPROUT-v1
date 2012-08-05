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

@implementation CreateSproutViewController

@synthesize pickerImage;
@synthesize imageView;
@synthesize sprout;
@synthesize sproutView;

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
    
    self.sproutView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pickerImage = nil;
    self.sprout = nil;
    self.sproutView = nil;
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
    
    UIImage *i = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    NSLog(@"Image = %@", i);
    self.imageView.image = i;
    
    DragToSproutViewController *dragViewController = [[DragToSproutViewController alloc] initWithNibName:@"DragToSproutViewController" bundle:nil];
    dragViewController.imageInput = i;
    [self.navigationController pushViewController:dragViewController animated:YES];
    
    [self dismissModalViewControllerAnimated:YES];    
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender
{
    
}

-(IBAction)share:(id)sender
{
    ExportSproutViewController *exportSproutViewController = [[ExportSproutViewController alloc] initWithNibName:@"ExportSproutViewController" bundle:nil];
    
    [self.navigationController pushViewController:exportSproutViewController animated:YES];
}

-(IBAction)capture:(id)sender
{
    SaveorDiscardPhotoViewController *takePhotoViewController = [[SaveorDiscardPhotoViewController alloc] initWithNibName:@"TakePhotoViewController" bundle:nil];
    
    [self.navigationController pushViewController:takePhotoViewController animated:YES];
}

-(void)sproutDidSelectedViewImage:(SproutScrollView *)sprout :(DragDropImageView *)imageSelected
{
    ViewPhotoInSproutViewController *photoViewController = [[ViewPhotoInSproutViewController alloc] initWithNibName:@"ViewPhotoInSproutViewController" bundle:nil];
    [self.navigationController pushViewController:photoViewController animated:YES];
    

}


@end
