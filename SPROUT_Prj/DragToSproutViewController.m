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
            NSMutableArray *imagesArray = [[NSMutableArray alloc] initWithArray:[Sprout imagesOfSrpout:self.sprout]];
            
            for(id x in imagesArray)
            {
                if([[x valueForKey:@"url"] isEqual:@"URL"])
                {
                    [x setValue:@"assets-library://asset/asset.JPG?id=109CAF18-3A70-4384-9205-41CA01373030&ext=JPG" forKey:@"url"];
                    break;
                }
            }
            
            SaveSproutViewController *saveViewController = [[SaveSproutViewController alloc] initWithNibName:@"SaveSproutViewController" bundle:nil];
            saveViewController.sprout = self.sprout;
            saveViewController.imagesArray = imagesArray;
            
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
    
    
    NSMutableArray *imagesArray = [[NSMutableArray alloc] initWithArray:[Sprout imagesOfSrpout:self.sprout]];
    
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
    self.imageForSprout = nil;
    self.imageInput = nil;
    self.sproutView = nil;
    self.sproutScroll = nil;
    self.sprout = nil;
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
    ViewPhotoInSproutViewController *photoViewController = [[ViewPhotoInSproutViewController alloc] initWithNibName:@"ViewPhotoInSproutViewController" bundle:nil];
    [self.navigationController pushViewController:photoViewController animated:YES];
}






@end
