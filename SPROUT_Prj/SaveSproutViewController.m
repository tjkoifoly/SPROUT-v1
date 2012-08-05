//
//  SaveSproutViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "SaveSproutViewController.h"
#import "ExportSproutViewController.h"
#import "ViewPhotoInSproutViewController.h"


@implementation SaveSproutViewController

@synthesize sproutScroll;
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
    
    self.sproutScroll = [[SproutScrollView alloc] initWithrowSize:3 andColSize:4];
    
    self.sproutScroll.delegate = self;
    
    CGPoint center = CGPointMake(self.sproutView.frame.size.width / 2., self.sproutView.frame.size.height / 2.);
    
    self.sproutScroll.center = center;
    [self.sproutView addSubview:self.sproutScroll];
    self.sproutView.backgroundColor = [UIColor clearColor];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sproutView = nil;
    self.sproutScroll = nil;
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
    
}

-(IBAction)exportSport:(id)sender
{
    ExportSproutViewController *exportSproutViewController = [[ExportSproutViewController alloc] initWithNibName:@"ExportSproutViewController" bundle:nil];

    [self.navigationController pushViewController:exportSproutViewController animated:YES];
}

-(void)sproutDidSelectedViewImage:(SproutScrollView *)sprout :(DragDropImageView *)imageSelected
{
    ViewPhotoInSproutViewController *photoViewController = [[ViewPhotoInSproutViewController alloc] initWithNibName:@"ViewPhotoInSproutViewController" bundle:nil];
    [self.navigationController pushViewController:photoViewController animated:YES];

}





@end
