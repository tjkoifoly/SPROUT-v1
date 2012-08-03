//
//  DragToSproutViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "DragToSproutViewController.h"
#import "SaveSproutViewController.h"

@implementation DragToSproutViewController

@synthesize imageForSprout;
@synthesize imageInput;

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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGRect frameImage = [self.imageForSprout frame];
    
    if (touchPoint.x > frameImage.origin.x && touchPoint.y > frameImage.origin.y) {
        
        SaveSproutViewController *saveViewController = [[SaveSproutViewController alloc] initWithNibName:@"SaveSproutViewController" bundle:nil];

        [self.navigationController pushViewController:saveViewController animated:NO];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(imageInput == nil)
        imageInput = [UIImage imageNamed:@"baby"];
    
    self.imageForSprout.image = imageInput;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageForSprout = nil;
    self.imageInput = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end