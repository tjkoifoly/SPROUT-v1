//
//  DragToSproutViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "DragToSproutViewController.h"
#import "SaveSproutViewController.h"
#import "SproutScrollView.h"
#import "DragDropImageView.h"
#import "ViewPhotoInSproutViewController.h"
#import "Sprout.h"

@implementation DragToSproutViewController
{
    UIImage *temp;
}

@synthesize imageForSprout;
@synthesize imageInput;
@synthesize sproutView;
@synthesize sproutScroll;
@synthesize sprout;
@synthesize urlImage;
@synthesize imagesArray;

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
    
    if (touchPoint.x > frameImage.origin.x 
        && touchPoint.x < (frameImage.origin.x + frameImage.size.width)
        && touchPoint.y > frameImage.origin.y
        && (touchPoint.y < frameImage.origin.y + frameImage.size.height)) {
        
        temp = self.imageInput;
        
//        SaveSproutViewController *saveViewController = [[SaveSproutViewController alloc] initWithNibName:@"SaveSproutViewController" bundle:nil];
//
//        [self.navigationController pushViewController:saveViewController animated:NO];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGRect frameView = [self.sproutView frame];
    CGRect frameImage = [self.sproutScroll frame];
    
    if (touchPoint.x > (frameView.origin.x + frameImage.origin.x )
        && touchPoint.x < (frameView.origin.x +frameImage.origin.x + frameImage.size.width)
        && touchPoint.y > (frameImage.origin.y + frameView.origin.y)
        && (touchPoint.y < (frameImage.origin.y + frameImage.size.height +frameView.origin.y))) {
        if(temp != nil)
        {
            SaveSproutViewController *saveViewController = [[SaveSproutViewController alloc] initWithNibName:@"SaveSproutViewController" bundle:nil];
            
            for(id x in self.sproutScroll.subviews)
            {
                if([[(DragDropImageView *)x url] isEqual:@"URL"])
                {
                    //[x setValue:self.urlImage forKey:@"url"];
                    [(DragDropImageView *)x setUrlImage: self.urlImage];
                    [(DragDropImageView *)x setImage:self.imageInput];
                    //saveViewController.lastBlank = x;
                    break;
                }
            }
            
            saveViewController.sprout = self.sprout;
            //saveViewController.imagesArray = imagesArray;
            
            saveViewController.sproutScroll = self.sproutScroll;
            //saveViewController.urlImage = self.urlImage;
            
            [self.navigationController pushViewController:saveViewController animated:NO];
        }
        
    }
    
    temp = nil;

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    temp = nil;
    
    if(imageInput == nil)
        imageInput = [UIImage imageNamed:@"baby"];
    
    self.imageForSprout.image = imageInput;
    
   // NSLog(@"SPROUT = %@", self.sprout);
    
    self.imagesArray = [[NSMutableArray alloc] initWithArray:[Sprout imagesOfSrpout:self.sprout]];
    
    //self.sproutScroll = [[SproutScrollView alloc] initWithrowSize:[[self.sprout valueForKey:@"rowSize"] intValue] andColSize:[[self.sprout valueForKey:@"colSize"] intValue]];
    
    self.sproutScroll =  [[SproutScrollView alloc] initWithArrayImage:[[self.sprout valueForKey:@"rowSize"] intValue] :[[self.sprout valueForKey:@"colSize"] intValue] :imagesArray];

    self.sproutScroll.delegate = self;
    
    CGPoint center = CGPointMake(self.sproutView.frame.size.width / 2., self.sproutView.frame.size.height / 2.);
    
    self.sproutScroll.center = center;
    [self.sproutView addSubview:self.sproutScroll];
    self.sproutView.backgroundColor = [UIColor clearColor];
    
    
    //NSLog(@"%f %f",self.sproutScroll.center.x,self.sproutScroll.center.y );    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageForSprout     = nil;
    self.imageInput         = nil;
    self.sproutView         = nil;
    self.sproutScroll       = nil;
    self.sprout             = nil;
    self.urlImage           = nil;
    self.imagesArray        = nil;
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

-(void)sproutDidSelectedViewImage:(SproutScrollView *)sprout :(DragDropImageView *)imageSelected
{
    /*
    NSArray *subSprouts = self.sproutScroll.subviews;
    NSMutableArray *listImages = [[NSMutableArray alloc] init];
    
    for(id aImgV in subSprouts)
    {
        UIImage * i = [((DragDropImageView*)aImgV) image];
        if(i != nil)
            [listImages addObject:i];
    }
    
    NSMutableArray *imagesMng = [[NSMutableArray alloc] init];
    NSManagedObject *currentImage;
    
    for(NSManagedObject *aImgObj in self.imagesArray)
    {
        if(![[aImgObj valueForKey:@"url"] isEqual:@"URL"])
        {
            [imagesMng addObject:aImgObj];
        }
    }
    
    currentImage = [self.imagesArray objectAtIndex:imageSelected.tag];
    
    if(listImages.count >0)
    {
        ViewPhotoInSproutViewController *photoViewController = [[ViewPhotoInSproutViewController alloc] initWithNibName:@"ViewPhotoInSproutViewController" bundle:nil];
        photoViewController.current = imageSelected.image;
        photoViewController.listImages = listImages;
        photoViewController.delegate = self;
        photoViewController.imagesMgr = imagesMng;
        photoViewController.currentObject = currentImage;
        
        [self.navigationController pushViewController:photoViewController animated:YES];
    }
*/
}

-(void)moveImageInSprout:(SproutScrollView *)sprout from:(DragDropImageView *)fromItem to:(DragDropImageView *)toItem
{
    /*
    NSManagedObject *from = [self.imagesArray objectAtIndex:fromItem.tag];
    [from setValue:toItem.url forKey:@"url"];
    NSManagedObject *to = [self.imagesArray objectAtIndex:toItem.tag];
    [to setValue:fromItem.url forKey:@"url"];
    
    //NSLog(@"%@", self.imagesArray);
     */
}

-(void)deletePhoto:(ViewPhotoInSproutViewController *)controller :(DragDropImageView *)object
{
    NSLog(@"Delete OK");
    NSInteger tag = object.tag;
    
    [(DragDropImageView *)[self.sproutScroll.subviews objectAtIndex:tag] setImage:nil];
    [(DragDropImageView *)[self.sproutScroll.subviews objectAtIndex:tag] setUrlImage:@"URL"];
    //[[self.imagesArray objectAtIndex:tag] setValue:@"URL" forKey:@"url"];

}



@end
