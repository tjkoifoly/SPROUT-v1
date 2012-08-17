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

@implementation SaveSproutViewController

@synthesize sproutScroll;
@synthesize sproutView;
@synthesize sprout;
@synthesize imagesArray;
@synthesize exportButton;

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
    
    self.imagesArray = [[NSMutableArray alloc] initWithArray:[Sprout imagesOfSrpout:self.sprout]];
    if(self.sproutScroll == nil)
    {
        //self.sproutScroll =  [[SproutScrollView alloc] initWithArrayImage:[[self.sprout valueForKey:@"rowSize"] intValue] :[[self.sprout valueForKey:@"colSize"] intValue] :self.imagesArray];
        self.sproutScroll = [[SproutScrollView alloc] initWithName:[self.sprout valueForKey:@"name"] :[[self.sprout valueForKey:@"rowSize"] intValue] :[[self.sprout valueForKey:@"colSize"] intValue] :imagesArray];
    }
    
    self.sproutScroll.delegate = self;
    CGPoint center = CGPointMake(self.sproutView.frame.size.width / 2., self.sproutView.frame.size.height / 2.);
    self.sproutScroll.center = center;
    [self.sproutView addSubview:self.sproutScroll];
    self.sproutView.backgroundColor = [UIColor clearColor];
    
    [self enableExport];
}

-(void)viewDidDisappear:(BOOL)animated
{
}

-(void)enableExport
{
    if([Sprout sproutFinished:self.sprout])
    {
        self.exportButton.enabled = YES;
    }else
    {
        self.exportButton.enabled = NO;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful!" message:@"Sprout saved!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [self enableExport];
    }
    
     
}

-(IBAction)exportSport:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"Rending sprout as a image might use much memory.\nSafely, you should quit other applications before export!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Accept", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"BUTTON INDEX SELECTED : %i", buttonIndex);
    if(buttonIndex == 0) return;
    else
    {
        ExportSproutViewController *exportSproutViewController = [[ExportSproutViewController alloc] initWithNibName:@"ExportSproutViewController" bundle:nil];
        
        exportSproutViewController.sproutScroll = self.sproutScroll;
        
        [self.navigationController pushViewController:exportSproutViewController animated:YES];
    }
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
    self.exportButton.enabled = NO;
}

-(void)deletePhoto:(ViewPhotoInSproutViewController *)controller :(DragDropImageView *)object
{
    self.exportButton.enabled = NO;
    NSLog(@"Delete OK");
    NSInteger tag = object.tag ;
    
    [(DragDropImageView *)[self.sproutScroll.subviews objectAtIndex:tag] setImage:nil];
    [(DragDropImageView *)[self.sproutScroll.subviews objectAtIndex:tag] setUrlImage:@"URL"];
    //[[self.imagesArray objectAtIndex:tag] setValue:@"URL" forKey:@"url"];
     
}


@end
