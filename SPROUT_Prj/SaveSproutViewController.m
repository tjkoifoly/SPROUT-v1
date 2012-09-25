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
#import "CNCAppDelegate.h"
#import "SaveorDiscardPhotoViewController.h"
#import "Sprout.h"
#import "ContinueAfterSaveViewController.h"
#import "NYOBetterZoomUIScrollView.h"

#define margin 5

@implementation SaveSproutViewController
{
    NYOBetterZoomUIScrollView *imageScrollView;
    UIView *backView;
    UIView *fullView;
    CGPoint staticCenterDefault;
    NSTimer *timer;
}

@synthesize sproutScroll;
@synthesize sproutView;
@synthesize sprout;
@synthesize imagesArray;
@synthesize exportButton;
@synthesize capButton;
@synthesize libButton;
@synthesize statusLabel;
@synthesize fromDrag;
@synthesize delegate;
@synthesize fontFrame;
@synthesize saveButton;

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
    
    //
    //Display button after drag
//    if(fromDrag)
//    {
//        //capButton.hidden    = NO;
//        //libButton.hidden    = NO;
//        //statusLabel.hidden  = YES;
//        self.delegate = [[self.navigationController viewControllers]objectAtIndex:0];
//    }
    
    self.delegate = [[self.navigationController viewControllers]objectAtIndex:0];
    self.imagesArray = [[NSMutableArray alloc] initWithArray:[Sprout imagesOfSrpout:self.sprout]];
    
    if(self.sproutScroll == nil)
    {
        //self.sproutScroll =  [[SproutScrollView alloc] initWithArrayImage:[[self.sprout valueForKey:@"rowSize"] intValue] :[[self.sprout valueForKey:@"colSize"] intValue] :self.imagesArray];
        self.sproutScroll = [[SproutScrollView alloc] initWithName:[self.sprout valueForKey:@"name"] :[[self.sprout valueForKey:@"rowSize"] intValue] :[[self.sprout valueForKey:@"colSize"] intValue] :imagesArray];
        //set Space for cell in sprout
        [self performSelector:@selector(autoResize)];
    }
    
    self.sproutScroll.delegate = self;
    CGPoint center = CGPointMake(self.sproutView.frame.size.width / 2., self.sproutView.frame.size.height / 2.);
    self.sproutScroll.center = center;
    
    [self.sproutView addSubview:self.sproutScroll];
    self.sproutView.backgroundColor = [UIColor clearColor];
    
    statusLabel.text = sproutScroll.name;
    [self enableExport];
    
    //Set Font Frame Sprout
    CGRect frame1 = self.sproutView.frame;
    CGRect frame2 = self.sproutScroll.frame;
    
    CGRect newFrame = CGRectMake(frame1.origin.x+frame2.origin.x - margin, frame1.origin.y+frame2.origin.y - margin, frame2.size.width+ 2*margin, frame2.size.height + 2*margin);
    [self.fontFrame setFrame:newFrame];
    
    //Set location for Sprout
    timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(slideSproutToCenter) userInfo:nil repeats:YES];
    
}

-(void)autoResize
{
    for(id aobj in self.sproutScroll.subviews)
    {
        CGRect frame = [aobj frame];
        CGRect newFrame = CGRectMake(frame.origin.x + 2, frame.origin.y +2, frame.size.width - 4, frame.size.height - 4);
        [aobj setFrame:newFrame];
    }
}


-(void)viewDidDisappear:(BOOL)animated
{
}

-(void)slideSproutToCenter
{
    CGPoint mainCenter = self.view.center;
    CGFloat centerY = mainCenter.y;
    CGFloat centerX = mainCenter.x;
    
    CGPoint sCenter = self.sproutView.center;
    CGFloat sCenterY = sCenter.y;
    
    if(sCenterY > centerY)
    {
        sCenterY --;
        self.sproutView.center = CGPointMake(centerX, sCenterY);
        self.fontFrame.center = CGPointMake(centerX, sCenterY);
    }else
    {
        [timer invalidate];
        timer = nil;
    }
    
}

-(void)enableExport
{
    if([Sprout sproutFinished:self.sprout])
    {
        self.exportButton.hidden = NO;
        self.saveButton.hidden = YES;
        
    }else
    {
        self.exportButton.hidden = YES;
        self.saveButton.hidden = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sproutView         = nil;
    self.sproutScroll       = nil;
    self.sprout             = nil;
    self.imagesArray        = nil;
    self.exportButton       = nil;
    self.statusLabel        = nil;
    self.capButton          = nil;
    self.libButton          = nil;
    self.delegate           = nil;
    fullView                = nil;
    self.fontFrame          = nil;
    self.saveButton         = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBAction
-(IBAction)goToHome:(id)sender
{
    [self viewDidUnload];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSArray *array = self.sproutScroll.subviews;
    int i = 0;
    for(i = 0; i< self.imagesArray.count; i++)
    {
        [[self.imagesArray objectAtIndex:i] setValue:[(DragDropImageView *)[array objectAtIndex:i] url] forKey:@"url"];
    }
    
    if([context save:&error])
    {
        if(sender != nil)
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful!" message:@"Sprout saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self enableExport];
        }
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!" message:@"Save sprout failed!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }

}

-(IBAction)exportSport:(id)sender
{
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"Rending sprout as a image might use much memory.\nSafely, you should quit other applications before export!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Accept", nil];
    [alert show];
     */
    [self exportFunction];
    
}

-(IBAction)capturePressed:(id)sender;
{

    [self save:nil];
    NSLog(@"%@", [[self.navigationController viewControllers]objectAtIndex:0]);
    [self.delegate captureContinue:self];
}

-(IBAction)loadLibPressed:(id)sender
{
    [self save:nil];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *urlImage = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    
    SaveorDiscardPhotoViewController *saveOrDiscardViewController = [[SaveorDiscardPhotoViewController alloc] initWithNibName:@"SaveorDiscardPhotoViewController" bundle:nil];
    saveOrDiscardViewController.urlImage = urlImage;
    saveOrDiscardViewController.image = image;
    saveOrDiscardViewController.fromLib = YES;
    
    [self.delegate loadFromLibToContinue: self to: saveOrDiscardViewController];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"BUTTON INDEX SELECTED : %i", buttonIndex);
    if(buttonIndex == 0) return;
    else
    {
        [self exportFunction];
    }
}

-(void)exportFunction
{
    ExportSproutViewController *exportSproutViewController = [[ExportSproutViewController alloc] initWithNibName:@"ExportSproutViewController" bundle:nil];
    
    exportSproutViewController.sproutScroll = self.sproutScroll;

    self.delegate = [[self.navigationController viewControllers] objectAtIndex:0];
    
    [self.delegate exportSproutOK:self toView:exportSproutViewController];
    
    //[self.navigationController pushViewController:exportSproutViewController animated:YES];
}

-(void)sproutDidSelectedViewImage:(SproutScrollView *)sprout :(DragDropImageView *)imageSelected
{
    NSArray *subSprouts = self.sproutScroll.subviews;
    NSMutableArray *listImages = [[NSMutableArray alloc] init];
    
    for(id aImgV in subSprouts)
    {
        UIImage * i = [((DragDropImageView*)aImgV) image];
        if(i != nil)
            [listImages addObject:aImgV];
    }
    
    NSMutableArray *imagesMng = [[NSMutableArray alloc] init];
    
    for(NSManagedObject *aImgObj in self.imagesArray)
    {
        if(![[aImgObj valueForKey:@"url"] isEqual:@"URL"])
        {
            [imagesMng addObject:aImgObj];
        }
    }
    //NSLog(@"LIST = %@; CURRENT = %@", imagesMng, currentImage);
    
    if(listImages.count >0)
    {
        ViewPhotoInSproutViewController *photoViewController = [[ViewPhotoInSproutViewController alloc] initWithNibName:@"ViewPhotoInSproutViewController" bundle:nil];
        photoViewController.delegate = self;
//        photoViewController.current = imageSelected.image;
        photoViewController.listImages = listImages;
        //photoViewController.imagesMgr = imagesMng;
        photoViewController.currentObject = imageSelected;
    
        [self.navigationController pushViewController:photoViewController animated:YES];
    }

}

-(void)moveImageInSprout:(SproutScrollView *)sprout from:(DragDropImageView *)fromItem to:(DragDropImageView *)toItem
{
    /*
    NSManagedObject *from = [self.imagesArray objectAtIndex:fromItem.tag];
    [from setValue:toItem.url forKey:@"url"];
    NSManagedObject *to = [self.imagesArray objectAtIndex:toItem.tag];
    [to setValue:fromItem.url forKey:@"url"];
    */
    //NSLog(@"%@", self.imagesArray);
    //self.exportButton.hidden = YES;
    NSLog(@"Done");
}

-(void)deletePhoto:(ViewPhotoInSproutViewController *)controller :(DragDropImageView *)object
{
    self.exportButton.hidden = YES;
    self.saveButton.hidden = NO;
    NSLog(@"Delete OK");
    NSInteger tag = object.tag ;
    
    [(DragDropImageView *)[self.sproutScroll.subviews objectAtIndex:tag] setImage:nil];
    [(DragDropImageView *)[self.sproutScroll.subviews objectAtIndex:tag] setUrlImage:@"URL"];
    //[[self.imagesArray objectAtIndex:tag] setValue:@"URL" forKey:@"url"];
    //Set background again
    int w = [(DragDropImageView *)[self.sproutScroll.subviews objectAtIndex:tag]frame].size.width;
    
    NSLog(@"WITH = %@", [NSString stringWithFormat:@"bg-cell%i.png", w+4]);
    [(DragDropImageView *)[self.sproutScroll.subviews objectAtIndex:tag] setBackgroundColor:[UIColor lightGrayColor]];
    [(DragDropImageView *)[self.sproutScroll.subviews objectAtIndex:tag] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg-cell%i.png", w+4]]]];
     
}

-(IBAction)viewFullScreen:(id)sender
{
    float w = self.sproutScroll.contentSize.width;
    float h = self.sproutScroll.contentSize.height;
    float x = 0.0f;
    float y = 0.0f;
    
    fullView = [[UIView alloc] initWithFrame:CGRectMake(x, y,w ,h )] ;
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"font-frame.png"]];
    [bgImg setFrame:fullView.frame];
    [fullView addSubview:bgImg];
    
    int size = 60;
    if(sproutScroll.rowSize > 4 || sproutScroll.colSize > 4)
    {
        size = 40;
    }
    
    for(id ix in self.sproutScroll.subviews)
    {
        UIImageView *x = [[UIImageView alloc] initWithFrame:[ix frame]];
        x.image = [ix image];
        if([ix image] == nil)
        {
            x.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg-cell%i.png", size]]];
        }
        x.layer.borderColor = [UIColor whiteColor].CGColor;
        x.layer.borderWidth= 1.f;
        //fullView.layer.borderWidth = 2.f;
        //fullView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [fullView addSubview:x];
    }
     
    staticCenterDefault = fullView.center;
    
    imageScrollView = [[NYOBetterZoomUIScrollView alloc] initWithFrame:self.view.frame andChildView:fullView];
    [imageScrollView setBackgroundColor:[UIColor blackColor]];
    imageScrollView.delegate = self;
    imageScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [imageScrollView setContentMode:UIViewContentModeScaleAspectFit];
    [imageScrollView setMaximumZoomScale:2.0f];
    float minScale = 1.0f;
    if(MAX(w, h) > 320.f)
        minScale = (320.f/ MAX(w, h));
    [imageScrollView setMinimumZoomScale:minScale];
    [imageScrollView setContentSize:self.sproutScroll.contentSize];
    [imageScrollView setShowsVerticalScrollIndicator:NO];
    [imageScrollView setShowsHorizontalScrollIndicator:NO];
    imageScrollView.touchDelegate = self;
    //[imageScrollView setChildView:fullView];
    
    [self setMinimumZoomForCurrentFrame];
    [imageScrollView setZoomScale:imageScrollView.minimumZoomScale animated:NO];
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.view
                             cache:YES];
    [self.view addSubview:imageScrollView];
    [UIView commitAnimations];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0, 320, 43)];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bar-top.png"]];
    backView.alpha = 0.9f;
    UIButton *backButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn-backview.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(13,5,31,31);
    [backButton addTarget:self action:@selector(backtoPreviousView) forControlEvents:UIControlEventTouchUpInside];
    backButton.alpha = 1.f;
    [backView addSubview:backButton];
    
    [self.view addSubview:backView];
}

-(void)backtoPreviousView
{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.view
                             cache:YES];

    [backView removeFromSuperview];
    [imageScrollView removeFromSuperview];
    [UIView commitAnimations];
}

#pragma UIScrollDelegate
- (void)setMinimumZoomForCurrentFrame {
	UIView *imageView = (UIView *)[imageScrollView childView];
    
	// Work out a nice minimum zoom for the image - if it's smaller than the ScrollView then 1.0x zoom otherwise a scaled down zoom so it fits in the ScrollView entirely when zoomed out
	CGSize imageSize = imageView.frame.size;
	CGSize scrollSize = imageScrollView.frame.size;
	CGFloat widthRatio = scrollSize.width / imageSize.width;
	CGFloat heightRatio = scrollSize.height / imageSize.height;
	CGFloat minimumZoom = MIN(1.0, (widthRatio > heightRatio) ? heightRatio : widthRatio);
	
	[imageScrollView setMinimumZoomScale:minimumZoom];
}

- (void)setMinimumZoomForCurrentFrameAndAnimateIfNecessary {
	BOOL wasAtMinimumZoom = NO;
    
	if(imageScrollView.zoomScale == imageScrollView.minimumZoomScale) {
		wasAtMinimumZoom = YES;
	}
	
	[self setMinimumZoomForCurrentFrame];
	
	if(wasAtMinimumZoom || imageScrollView.zoomScale < imageScrollView.minimumZoomScale) {
		[imageScrollView setZoomScale:imageScrollView.minimumZoomScale animated:YES];
	}	
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(scrollView == imageScrollView)
    {
        return [imageScrollView childView];
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(NYOBetterZoomUIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
#ifdef DEBUG
	UIView *theView = [scrollView childView];
	NSLog(@"view frame: %@", NSStringFromCGRect(theView.frame));
	NSLog(@"view bounds: %@", NSStringFromCGRect(theView.bounds));
#endif
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    //backView.hidden = YES;
    [backView showHidewithAnimation:NO];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //backView.hidden = YES;
    [backView showHidewithAnimation:NO];
    
}

-(void)backView
{
    //backView.hidden = NO;
    [backView showHidewithAnimation:YES];
    
}




@end
