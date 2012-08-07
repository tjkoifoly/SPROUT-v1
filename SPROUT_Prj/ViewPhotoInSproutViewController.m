//
//  ViewPhotoInSproutViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ViewPhotoInSproutViewController.h"

const CGFloat kScrollObjHeight	= 400.f;
const CGFloat kScrollObjWidth	= 300.f;

@implementation ViewPhotoInSproutViewController

@synthesize listImages;
@synthesize scrollImages;
@synthesize current;

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
    self.view.backgroundColor = [UIColor blackColor];
    
    self.scrollImages = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 90.0f, kScrollObjWidth, kScrollObjHeight)];
    [self.scrollImages setContentSize:CGSizeMake(kScrollObjWidth * self.listImages.count, kScrollObjHeight)];
    [self.scrollImages setScrollEnabled:YES];
    self.scrollImages.pagingEnabled = YES;
    self.scrollImages.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.scrollImages.backgroundColor = [UIColor clearColor];
    
    NSUInteger i;
	for (i = 0; i < self.listImages.count; i++)
	{
		UIImage *image = [self.listImages objectAtIndex:i];
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScrollObjWidth, 0.0f,kScrollObjWidth , kScrollObjHeight)];
        [imageView setImage:image];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        imageView.backgroundColor = [UIColor clearColor];
		
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		CGRect rect = imageView.frame;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		imageView.frame = rect;
		imageView.tag = i;	
        // tag our images for later use when we place them in serial fashion
		[self.scrollImages addSubview:imageView];

	}
    [self.scrollImages scrollRectToVisible:CGRectMake(self.current.tag * kScrollObjWidth, 0.0f, kScrollObjWidth, kScrollObjHeight) animated:NO];
    
    [self.view addSubview:self.scrollImages];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.listImages = nil;
    self.scrollImages = nil;
    self.current = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBAction

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
