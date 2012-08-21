//
//  MainViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "MainViewController.h"
#import "TakePhotoViewController.h"
#import "SelectGridSizeViewController.h"
#import "ViewSproutViewController.h"
#import "ReminderViewController.h"
#import "ContinueAfterSaveViewController.h"
#import "ExportSproutViewController.h"

@implementation MainViewController

@synthesize takePhotoViewController;
@synthesize selectGridViewController;
@synthesize viewSproutViewController;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.takePhotoViewController = nil;
    self.selectGridViewController = nil;
    self.viewSproutViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBAction

-(IBAction)captureSprout:(id)sender
{
    if(takePhotoViewController == nil)
    {
        takePhotoViewController = [[TakePhotoViewController alloc]initWithNibName:@"TakePhotoViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:takePhotoViewController animated:NO];
}

-(IBAction)createSprout:(id)sender
{
    if(selectGridViewController == nil)
    {
        selectGridViewController = [[SelectGridSizeViewController alloc]initWithNibName:@"SelectGridSizeViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:selectGridViewController animated:YES];
}

-(IBAction)viewSprout:(id)sender
{
    if(viewSproutViewController == nil)
    {
        viewSproutViewController = [[ViewSproutViewController alloc]initWithNibName:@"ViewSproutViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:viewSproutViewController animated:YES];
}

-(IBAction)reminder :(id)sender
{
    ReminderViewController *reminderViewController = [[ReminderViewController alloc] initWithNibName: @"ReminderViewController" bundle:nil];
    
    [self.navigationController pushViewController:reminderViewController animated:YES];
}

-(void)captureContinue:(SaveSproutViewController *)controller
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self captureSprout:nil];
}

-(void)loadFromLibContinue:(SaveSproutViewController *)controller toView:(ContinueAfterSaveViewController *)continueViewController
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [self.navigationController pushViewController:continueViewController animated:YES];
}

-(void)exportSproutOK:(SaveSproutViewController *)controller toView:(ExportSproutViewController *)expController
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:expController animated:YES];
}

-(void)loadFromLibToContinue:(SaveorDiscardPhotoViewController *)controller
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma Create delegate
-(void)gotoCapturePhoto
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self captureSprout:nil];
}

-(void)loadFromLibOK:(SaveorDiscardPhotoViewController *)controller
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:controller animated:YES];
}





@end
