//
//  ViewPhotoInSproutViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ViewPhotoInSproutViewController.h"
#import "Sprout.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kScrollObjHeight	= 400.f;
const CGFloat kScrollObjWidth	= 300.f;

@implementation ViewPhotoInSproutViewController
{
    int currentPoint;
    UIView *viewScroll;
    BOOL loaded;
    NSMutableArray *imagesList;
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

-(UIImage *)imageCaptureSave: (UIView *)viewInput
{
    CGSize viewSize = viewInput.bounds.size;
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [viewInput.layer renderInContext:context];
    UIImage *imageX = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageX;
}

-(IBAction)saveScroll:(id)sender
{
    UIImage *im = [self imageCaptureSave:viewScroll];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 30.f, 320.f, 400.f)];
    iv.image = im;
    [self.view addSubview:iv];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    loaded = NO;
    self.scrollImages = [self loadScrollView:self.listImages :self.currentObject];
    [self.view addSubview:self.scrollImages];
    self.scrollImages.delegate = self;
    
}

-(UIScrollView *)loadScrollView: (NSArray *)list : (id)currentObj
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 50.f, kScrollObjWidth, kScrollObjHeight)];
    [scrollView setContentSize:CGSizeMake(kScrollObjWidth * list.count, kScrollObjHeight)];

    viewScroll = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScrollObjWidth*list.count, kScrollObjHeight)];
    [scrollView addSubview:viewScroll];
    
    [scrollView setScrollEnabled:YES];
    scrollView.pagingEnabled = YES;
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.backgroundColor = [UIColor clearColor];
    
    NSUInteger i;
	for (i = 0; i < list.count; i++)
	{
		UIImage *image = [(DragDropImageView *)[list objectAtIndex:i] image];
        
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScrollObjWidth, 0.0f,kScrollObjWidth , kScrollObjHeight)];
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView loadImageFromLibAssetURL:[(DragDropImageView *)[list objectAtIndex:i] url]];
        });
        */
        imageView.image = image;
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        imageView.backgroundColor = [UIColor clearColor];
		
		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
		CGRect rect = imageView.frame;
		rect.size.height = kScrollObjHeight;
		rect.size.width = kScrollObjWidth;
		imageView.frame = rect;
		imageView.tag = 0;	
        // tag our images for later use when we place them in serial fashion
        
		//[scrollView addSubview:imageView];
        [viewScroll addSubview:imageView];
        //[viewScroll addSubview:imageView withAnimation:YES];
        
	}
    currentPoint = [list indexOfObject:currentObj];
    
    if(currentPoint > 0)
        [((UIImageView *)[[viewScroll subviews] objectAtIndex:(currentPoint -1)]) loadImageFromLibAssetURL:[(DragDropImageView *)[list objectAtIndex:(currentPoint -1)] url]];
    [((UIImageView *)[[viewScroll subviews] objectAtIndex:currentPoint]) loadImageFromLibAssetURL:[(DragDropImageView *)[list objectAtIndex:currentPoint] url]];
    if(currentPoint < (list.count -1))
        [((UIImageView *)[[viewScroll subviews] objectAtIndex:(currentPoint + 1)]) loadImageFromLibAssetURL:[(DragDropImageView *)[list objectAtIndex:(currentPoint+1)] url]];
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
   
    //NSLog(@"%@ - at %i", [self.scrollImages.subviews objectAtIndex:currentPoint], currentPoint);
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
    
    if(currentPoint > 1)
    {
        [[[[[self.scrollImages subviews] objectAtIndex:0]subviews] objectAtIndex:(currentPoint - 2)]setTag:0];
        [[[[[self.scrollImages subviews] objectAtIndex:0]subviews] objectAtIndex:(currentPoint - 2)]setImage:nil];
    }
    
    if(currentPoint < listImages.count - 2)
    {
        [[[[[self.scrollImages subviews] objectAtIndex:0]subviews] objectAtIndex:(currentPoint + 2)]setTag:0];
        [[[[[self.scrollImages subviews] objectAtIndex:0]subviews] objectAtIndex:(currentPoint + 2)]setImage:nil];
    }
    
    /*
    if([[[[[self.scrollImages subviews] objectAtIndex:0]subviews] objectAtIndex:currentPoint]tag] == 0)
    dispatch_async(dispatch_get_main_queue(), ^{
        [(UIImageView *)[[[[self.scrollImages subviews] objectAtIndex:0]subviews] objectAtIndex:currentPoint] loadImageFromLibAssetURL:[(DragDropImageView *)[self.listImages objectAtIndex:currentPoint] url]];
        [[[[[self.scrollImages subviews] objectAtIndex:0]subviews] objectAtIndex:currentPoint] setTag:1];
    });
    */
    if(currentPoint > 0)
        [self loadImageinPoint:(currentPoint -1)];
    if(currentPoint < listImages.count - 1)
        [self loadImageinPoint:(currentPoint +1)];
    
}

-(void)loadImageinPoint: (NSInteger)point
{
    if([[[[[self.scrollImages subviews] objectAtIndex:0]subviews] objectAtIndex:point]tag] == 0)
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIImageView *)[[[[self.scrollImages subviews] objectAtIndex:0]subviews] objectAtIndex:point] loadImageFromLibAssetURL:[(DragDropImageView *)[self.listImages objectAtIndex:point] url]];
            [[[[[self.scrollImages subviews] objectAtIndex:0]subviews] objectAtIndex:point] setTag:1];
        });
}

@end
