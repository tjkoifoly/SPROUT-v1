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
#import "ConfirmPurchaseViewController.h"
#import "ExportSproutViewController.h"
#import "Sprout.h"

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
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-main.png"]];
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
    controller = nil;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:expController animated:YES];
    expController = nil;
}

-(void)loadFromLibToContinue:(SaveSproutViewController *)fromController to: (SaveorDiscardPhotoViewController *)controller
{
    fromController = nil;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:controller animated:YES];
    controller = nil;
}

-(void)optimizeSize:(NSString *)sName
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    SaveSproutViewController *displaySproutViewController = [[SaveSproutViewController alloc] initWithNibName:@"SaveSproutViewController" bundle:nil];
    id s = [Sprout sproutForName:sName];
    
    NSMutableArray *imgArray = [[NSMutableArray alloc]initWithArray:[Sprout imagesOfSrpout:s]];
    
    displaySproutViewController.imagesArray = imgArray;
    displaySproutViewController.sprout = s;
    displaySproutViewController.fromDrag = YES;
    
    [self.navigationController pushViewController:displaySproutViewController animated:YES];
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

#pragma Purcharse Delgate
-(void) gotoConfirm:(PurcharseCanvasViewController *)controller toView:(ConfirmPurchaseViewController *)confirmView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:confirmView animated:YES];
    confirmView = nil;
    controller = nil;
}

#pragma Export Delegate
-(void)optimizeSproutReview:(NSString *)sName
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    SaveSproutViewController *displaySproutViewController = [[SaveSproutViewController alloc] initWithNibName:@"SaveSproutViewController" bundle:nil];
    id s = [Sprout sproutForName:sName];
    
    NSMutableArray *imgArray = [[NSMutableArray alloc]initWithArray:[Sprout imagesOfSrpout:s]];
    
    displaySproutViewController.imagesArray = imgArray;
    displaySproutViewController.sprout = s;
    displaySproutViewController.fromDrag = YES;
    
    [self.navigationController pushViewController:displaySproutViewController animated:YES];
}


@end
