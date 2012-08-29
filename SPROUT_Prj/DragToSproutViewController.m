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
    UIImageView *temView;
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
    
    //IF active point check in image
    if (touchPoint.x > frameImage.origin.x 
        && touchPoint.x < (frameImage.origin.x + frameImage.size.width)
        && touchPoint.y > frameImage.origin.y
        && (touchPoint.y < frameImage.origin.y + frameImage.size.height)) {
        
        temp = self.imageInput;
        temView = [[UIImageView alloc] initWithImage:temp];
        [temView setFrame:self.imageForSprout.frame];
        temView.alpha = 0.5f;
        temView.center = touchPoint;
        [self.view addSubview:temView];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    temView.center = touchPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [temView removeFromSuperview];
    temView = nil;
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    
    CGRect frameView = [self.sproutView frame];
    CGRect frameImage = [self.sproutScroll frame];
    
    if (touchPoint.x > (frameView.origin.x + frameImage.origin.x )
        && touchPoint.x < (frameView.origin.x +frameImage.origin.x + frameImage.size.width)
        && touchPoint.y > (frameImage.origin.y + frameView.origin.y)
        && (touchPoint.y < (frameImage.origin.y + frameImage.size.height +frameView.origin.y))) {
        if([Sprout sproutFinished:self.sprout])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"Sprout is full!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        if(temp != nil)
        {
            /*
            //UPDATE SPROUT
            for(id x in self.sproutScroll.subviews)
            {
                if([[(DragDropImageView *)x url] isEqual:@"URL"])
                {
                    //[x setValue:self.urlImage forKey:@"url"];
                    NSString *fileName = [NSString stringWithFormat:@"%@-atTag-%i", [self.sprout valueForKey:@"name"], [x tag]];
                    
                    UIImage *imageOfCell =[self thumnailImageFromImageView:self.imageInput];
                    [self getImageFromFile:fileName input:imageOfCell];
                    
                    [(DragDropImageView *)x setUrlImage: self.urlImage];
                    NSLog(@"from url = %@", self.urlImage);
                    [(DragDropImageView *)x setImage:imageOfCell];
                    [self.sproutScroll scrollRectToVisible:[x frame] animated:YES];
                    
                    //saveViewController.lastBlank = x;
                    break;
                }
            }
            */
            
            //UPDATE SPROUT follow 2
            CGPoint offSetSprout = self.sproutScroll.contentOffset;
            float originx = touchPoint.x - self.sproutView.frame.origin.x + offSetSprout.x;
            float originy = touchPoint.y - self.sproutView.frame.origin.y + offSetSprout.y;
            CGPoint activePoint = CGPointMake(originx, originy);
             NSLog(@"Touch Point = %f X %f", activePoint.x, activePoint.y);
            UIImage *imageOfCell =[self thumnailImageFromImageView:self.imageInput];
            
            NSLog(@"from url = %@", self.urlImage);
            if(![self.sproutScroll photoIntoSprout:imageOfCell url:self.urlImage atPoint:activePoint])
            {
                return;
            }
            
            
            SaveSproutViewController *saveViewController = [[SaveSproutViewController alloc] initWithNibName:@"SaveSproutViewController" bundle:nil];
            saveViewController.fromDrag = YES;
            
            saveViewController.sprout = self.sprout;
            //saveViewController.imagesArray = imagesArray;
            
            saveViewController.sproutScroll = self.sproutScroll;
            //saveViewController.urlImage = self.urlImage;
            [self viewDidUnload];
            [self.navigationController pushViewController:saveViewController animated:NO];
        }
        
    }
    
    temp = nil;

}

#pragma mark - View lifecycle

-(void) viewDidDisappear:(BOOL)animated
{
    self.sproutScroll = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sproutView.backgroundColor = [UIColor clearColor];
    temp = nil;
    self.imageForSprout.image = imageInput;
    self.imagesArray = [[NSMutableArray alloc] initWithArray:[Sprout imagesOfSrpout:self.sprout]];

    self.sproutScroll = [[SproutScrollView alloc] initWithName:[self.sprout valueForKey:@"name"] :[[self.sprout valueForKey:@"rowSize"] intValue] :[[self.sprout valueForKey:@"colSize"] intValue] :imagesArray];
    self.sproutScroll.delegate = self;
    CGPoint center = CGPointMake(self.sproutView.frame.size.width / 2., self.sproutView.frame.size.height / 2.);
        
    self.sproutScroll.center = center;
    [self.sproutView addSubview:self.sproutScroll];
    
}

- (void)viewDidUnload
{
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
    [self viewDidUnload];
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

-(NSString *)dataPathFile:(NSString *)fileName
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    
    //NSLog(@"%@", documentDirectory);
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

-(void)getImageFromFile : (NSString *)fileName input: (UIImage *)inputImage
{
    NSString *path = [self dataPathFile:fileName];    
    [UIImagePNGRepresentation(inputImage) writeToFile:path atomically:YES];
    NSLog(@"Saved");
    //return [UIImage imageWithContentsOfFile:path];
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

-(UIImage *)thumnailImageFromImageView: (UIImage *)inputImage
{
    UIImageView *imvToRender = [[UIImageView alloc] initWithImage:inputImage];

    if(self.sproutScroll.colSize < 5 && self.sproutScroll.rowSize < 5)
        [imvToRender setFrame:CGRectMake(0.0, 0.0, 100, 100)];
    else
    {
        [imvToRender setFrame:CGRectMake(0.0, 0.0, 60, 60)];
    }
    [imvToRender setContentMode:UIViewContentModeScaleToFill];
    
    return [self imageCaptureSave:imvToRender];
}


@end
