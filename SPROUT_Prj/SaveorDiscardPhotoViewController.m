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

@synthesize delegate;
@synthesize image;

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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.delegate = nil;
    self.image = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBAction
-(IBAction)save:(id)sender
{
    /*
    ContinueAfterSaveViewController *updateImageViewController = [[ContinueAfterSaveViewController alloc] initWithNibName:@"ContinueAfterSaveViewController" bundle:nil];
    updateImageViewController.imageInput = [UIImage imageNamed:@"baby"];
    [self.navigationController pushViewController:updateImageViewController animated:YES];
     */
    [self.delegate saveOrDiscardPhoto:self :YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)discard:(id)sender
{
    [self.delegate saveOrDiscardPhoto:self :NO];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
