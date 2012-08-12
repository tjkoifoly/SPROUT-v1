//
//  ViewPhotoInSproutViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ViewPhotoInSproutViewController.h"
#import "Sprout.h"

const CGFloat kScrollObjHeight	= 400.f;
const CGFloat kScrollObjWidth	= 300.f;

@implementation ViewPhotoInSproutViewController
{
    int currentPoint;
}

@synthesize listImages;
@synthesize scrollImages;
@synthesize currentObject;
@synthesize delegate;

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
    
    self.scrollImages = [self loadScrollView:self.listImages :self.currentObject];
    [self.view addSubview:self.scrollImages];
    self.scrollImages.delegate = self;
}

-(UIScrollView *)loadScrollView: (NSArray *)list : (id)currentObj
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 50.f, kScrollObjWidth, kScrollObjHeight)];
    [scrollView setContentSize:CGSizeMake(kScrollObjWidth * list.count, kScrollObjHeight)];
    
    [scrollView setScrollEnabled:YES];
    scrollView.pagingEnabled = YES;
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.backgroundColor = [UIColor clearColor];
    
    NSUInteger i;
	for (i = 0; i < list.count; i++)
	{
		UIImage *image = [(DragDropImageView *)[list objectAtIndex:i] image];
        
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
        
		[scrollView addSubview:imageView];
        
	}
    currentPoint = [list indexOfObject:currentObj];
    
    [scrollView scrollRectToVisible:CGRectMake(currentPoint  * kScrollObjWidth, 0.0f, kScrollObjWidth, kScrollObjHeight) animated:NO];
    scrollView.delegate = self;

    return scrollView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.listImages = nil;
    self.scrollImages = nil;
    self.currentObject = nil;
    self.delegate = nil;
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

-(IBAction)deleteImage:(id)sender
{
    //NSLog(@"CURRENT POINT = %i", currentPoint);
   
    NSLog(@"%@ - at %i", [self.scrollImages.subviews objectAtIndex:currentPoint], currentPoint);
    if(self.listImages.count > 0)
    {
        [self.delegate deletePhoto:self :[self.listImages objectAtIndex:currentPoint]];
        [self.listImages removeObjectAtIndex:currentPoint];
        [self.scrollImages removeFromSuperview];
        
        if(currentPoint > 0)
        {
            currentPoint --;
        }
        if(self.listImages.count > 0)
        {
        self.scrollImages = [self loadScrollView:self.listImages :[self.listImages objectAtIndex:currentPoint]];
        [self.view addSubview:self.scrollImages];
        }
        else
        {
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noPhoto"]];
            [imgV setFrame:CGRectMake(10.0f, 50.f, kScrollObjWidth, kScrollObjHeight)];
            [imgV setContentMode:UIViewContentModeScaleAspectFit];
            [self.view addSubview:imgV];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No photo in sprout" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No photo in sprout" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    currentPoint = (int)([scrollView contentOffset].x / kScrollObjWidth);
}

@end
