//
//  SproutScrollView.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/4/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "SproutScrollView.h"
#import "DragDropImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "Sprout.h"

#define kWidth 40
#define kHeight 40

#define kWidthLarge 60
#define kHeightLarge 60

#define kMAXWidth 280
#define kMAXHeight 280

@implementation SproutScrollView
{
    NSInteger fromTag;
    NSInteger toTag;
    UIImageView *okMen;

}

@synthesize rowSize;
@synthesize colSize;
@synthesize name;
@synthesize images;
@synthesize imvSelected;
@synthesize delegate;
@synthesize enable;

-(id) initWithArrayImage: (NSInteger)rs : (NSInteger) cs: (NSArray*) ai
{
    enable = NO;
    self.rowSize = rs;
    self.colSize = cs;
   // NSLog(@" INIT %@", ai);
    
    int cellWidth = kWidth;
    int cellHeight = kHeight;
    
    if (rs < 5 && cs < 5)
        {
            cellWidth = kWidthLarge;
            cellHeight = kHeightLarge;
        }
    
    int maxWidth = self.colSize * cellWidth;
    int maxHeight = self.rowSize * cellHeight;
    
    if(maxWidth > kMAXWidth)
    {
        maxWidth = kMAXWidth;
    }
    
    if (maxHeight > kMAXHeight)
    {
        maxHeight = kMAXHeight;
    }
    
    //NSLog(@"row = %i, col = %i", self.rowSize, self.colSize);
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, maxWidth, maxHeight)];
    
    [self setContentSize:CGSizeMake((self.colSize * cellWidth), (self.rowSize *cellHeight))];
    
    [self setScrollEnabled:YES];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    
    for(int i = 0; i< self.rowSize ; i++)
    {
        for(int j = 0; j < self.colSize; j++)
        {
            NSString *u = @"URL";
            NSInteger t = i * (self.colSize) + j;
            
            for(id aoi in ai)
            {
                if([[aoi valueForKey:@"tag"] intValue] == t)
                {
                    u = [aoi valueForKey:@"url"];
                }
            }
            
            //NSLog(@"TAG %i - URL %@", t, u);
            
            //DragDropImageView *imv = [[DragDropImageView alloc] initWithLocationX:i andY:j fromURL:u : cellWidth];
            DragDropImageView *imv =  [[DragDropImageView alloc] initWithLocationX:i andY:j fromURL:u :cellWidth andPath:[NSString stringWithFormat:@"%@-atTag-%i", name, t]];
            NSLog(@"%@", [NSString stringWithFormat:@"%@-atTag-%i", name, t]);
            
            //imv.image = [UIImage imageNamed:@"baby"];
            imv.tag = t;
            imv.userInteractionEnabled = YES;
            imv.delegate = self;
            
            [self addSubview:imv];
            
            //NSLog(@"%i %i %i", i , j, imv.tag);
        }
    }
    //self.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.layer.borderWidth = 2.f;
    
    return self;

}

-(id) initWithName:(NSString *)sName: (NSInteger)rs : (NSInteger) cs: (NSArray*) ai
{
    UILongPressGestureRecognizer *changeImage = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveToBlank:)];
    
    changeImage.delegate = self;
    changeImage.minimumPressDuration = 0.6f;
    
    [self addGestureRecognizer:changeImage];
    
    name = sName;
    NSString *xName = [self.name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    enable = NO;
    self.rowSize = rs;
    self.colSize = cs;
    // NSLog(@" INIT %@", ai);
    
    int cellWidth = kWidth;
    int cellHeight = kHeight;
    
    if (rs < 5 && cs < 5)
    {
        cellWidth = kWidthLarge;
        cellHeight = kHeightLarge;
    }
    
    int maxWidth = self.colSize * cellWidth;
    int maxHeight = self.rowSize * cellHeight;
    
    if(maxWidth > kMAXWidth)
    {
        maxWidth = kMAXWidth;
    }
    
    if (maxHeight > kMAXHeight)
    {
        maxHeight = kMAXHeight;
    }
    
    //NSLog(@"row = %i, col = %i", self.rowSize, self.colSize);
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, maxWidth, maxHeight)];
    
    [self setContentSize:CGSizeMake((self.colSize * cellWidth), (self.rowSize *cellHeight))];
    
    [self setScrollEnabled:YES];
    [self setMinimumZoomScale:1.f];
    [self setMaximumZoomScale:2.f];
    [self setMultipleTouchEnabled:YES];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    
    for(int i = 0; i< self.rowSize ; i++)
    {
        for(int j = 0; j < self.colSize; j++)
        {
            NSString *u = @"URL";
            NSInteger t = i * (self.colSize) + j;
            
            for(id aoi in ai)
            {
                if([[aoi valueForKey:@"tag"] intValue] == t)
                {
                    u = [aoi valueForKey:@"url"];
                }
            }
            
            //NSLog(@"TAG %i - URL %@", t, u);
            
            //DragDropImageView *imv = [[DragDropImageView alloc] initWithLocationX:i andY:j fromURL:u : cellWidth];
            DragDropImageView *imv =  [[DragDropImageView alloc] initWithLocationX:i andY:j fromURL:u :cellWidth andPath:[NSString stringWithFormat:@"%@-atTag-%i", xName, t]];
            //NSLog(@"%@", [NSString stringWithFormat:@"%@-atTag-%i", sName, t]);
                
                //imv.image = [UIImage imageNamed:@"baby"];
            imv.tag = t;
            imv.userInteractionEnabled = YES;
            imv.delegate = self;
            
            [self addSubview:imv];
            imv = nil;
            //NSLog(@"%i %i %i", i , j, imv.tag);
        }
    }
    //self.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.layer.borderWidth = 2.f;
    
    return self;
}

-(id)initWithrowSize: (NSInteger) rs andColSize: (NSInteger) cs
{
    enable = NO;
    self.rowSize = rs;
    self.colSize = cs;
    NSLog(@" INIT %@", self.images);
    int cellWidth = kWidth;
    int cellHeight = kHeight;
    
    if (rs < 5 && cs < 5)
    {
        cellWidth = kWidthLarge;
        cellHeight = kHeightLarge;
    }

    
    int maxWidth = self.colSize * cellWidth;
    int maxHeight = self.rowSize * cellHeight;
    
    if(maxWidth > kMAXWidth)
    {
        maxWidth = kMAXWidth;
    }
    
    if (maxHeight > kMAXHeight)
    {
        maxHeight = kMAXHeight;
    }
    
    //NSLog(@"row = %i, col = %i", self.rowSize, self.colSize);
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, maxWidth, maxHeight)];
    
    [self setContentSize:CGSizeMake((self.colSize * cellWidth), (self.rowSize *cellHeight))];
    
    [self setScrollEnabled:YES];
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
    
        for(int i = 0; i< self.rowSize ; i++)
        {
            for(int j = 0; j < self.colSize; j++)
            {
                DragDropImageView *imv = [[DragDropImageView alloc] initWithLocationX:i andY:j :cellWidth];
                
                //imv.image = [UIImage imageNamed:@"baby"];
                imv.tag = i * (self.colSize) + j;
                imv.userInteractionEnabled = YES;
                imv.delegate = self;
                [self addSubview:imv];
                
                //NSLog(@"%i %i %i", i , j, imv.tag);
            }
        }
    //self.layer.borderColor = [UIColor whiteColor].CGColor;
    //self.layer.borderWidth = 2.f;

    return self;
}

-(void) updateImageToSprout: (NSString *) imageURL  inTag:(NSInteger)cellTag
{
    [((DragDropImageView*)[self.subviews objectAtIndex:cellTag]) loadImageFromAssetURL:[NSURL URLWithString:imageURL]];
    ((DragDropImageView*)[self.subviews objectAtIndex:cellTag]).url = imageURL;
    
}

- (void)moveToBlank:(UILongPressGestureRecognizer *)recognizer 
{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Long Press OK");
        CGPoint currentPoint = [recognizer locationInView:self];
        //NSLog(@"%f x %f", currentPoint.x, currentPoint.y);
        fromTag = [self cellInPoint:currentPoint];
        if([(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] image] != nil)
        {
            float widthCell = [[self.subviews objectAtIndex:0]frame].size.width;
            okMen = [[UIImageView alloc] initWithImage:[(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] image]];
            [(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] setAlpha:0.5f];
            [okMen setFrame:CGRectMake(0.0, 0.0, widthCell, widthCell)];
            okMen.center = currentPoint;
            [self  addSubview:okMen];
            NSLog(@"%i", fromTag);
        }
        
    }else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        //NSLog(@"Change Location");
         //NSLog(@"%i", fromTag);
        if(okMen != nil)
        {
            CGPoint currentPoint = [recognizer locationInView:self];
            okMen.center = currentPoint;
        }
        
    }else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"End OK");
        CGPoint currentPoint = [recognizer locationInView:self];
        
        if(okMen != nil)
        {
            [(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] setAlpha:1.f];
            [okMen removeFromSuperview];
            okMen = nil;
        }
        
        if(![self checkInSprout:currentPoint])
        {
            NSLog(@"OUT");
            return;
        }
        
        toTag = [self cellInPoint:currentPoint];
        
        NSLog(@"%i to % i", fromTag, toTag);
        
        if([(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] image] != nil)
        {
            if([(DragDropImageView *)[[self subviews]objectAtIndex:toTag] image] == nil)
            {
               
                
                //SWAP
                [(DragDropImageView *)[[self subviews]objectAtIndex:toTag] setImage:[(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] image]];
                [(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] setImage:nil];
                [(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] setBackgroundColor:[UIColor lightGrayColor]];
                //Set background again
                int w = [[[self subviews]objectAtIndex:fromTag] frame].size.width;
                
                NSLog(@"WITH = %@", [NSString stringWithFormat:@"bg-cell%i.png", w+4]);
                [(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg-cell%i.png", w+4]]]];
                
                [(DragDropImageView *)[[self subviews]objectAtIndex:toTag] setUrlImage:[(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] url]];
                [(DragDropImageView *)[[self subviews]objectAtIndex:fromTag] setUrlImage:@"URL"];
                
                NSString *sName = [self.name stringByReplacingOccurrencesOfString:@"/" withString:@""];
                
                NSString *fileName = [NSString stringWithFormat:@"%@-atTag-%i", sName, toTag];
                [(DragDropImageView *)[[self subviews]objectAtIndex:toTag] getImageFromFile:fileName input:[(DragDropImageView *)[[self subviews]objectAtIndex:toTag] image]];
                
            }
        }
         
         
    }
}

-(BOOL)checkInSprout: (CGPoint )point
{
    if(point.x < 0 || point.x > self.contentSize.width)
        return NO;
    else if(point.y < 0 || point.y > self.contentSize.height)
        return NO;
    else return YES;
}

-(NSInteger)cellInPoint: (CGPoint) curPoint
{
//    float cellWidth = [[[self subviews]objectAtIndex:0] frame].size.width;
//    float cellHeight = [[[self subviews]objectAtIndex:0] frame].size.height;
    
    int size = 60;
    if(self.colSize > 4 || self.rowSize > 4)
    {
        size = 40;
    }
    
    int localY = (int)curPoint.x / size;
    int localX = (int) curPoint.y / size;
    
    int inTag = localX * self.colSize + localY;
    
    NSLog(@"%i", inTag);
    return inTag;
}



-(void) reloadImageOfSprout: (NSString *)sName
{
    NSManagedObject *sp = [Sprout sproutForName:sName];
    NSArray *array = [Sprout imagesOfSrpout:sp];
    for(id i in self.subviews)
    {
        [(DragDropImageView *)i loadImageFromAssetURL:[NSURL URLWithString:[[array objectAtIndex:[i tag]] valueForKey:@"url"]]];
    }
}

-(void)dragDropImageView:(DragDropImageView *)imageViewSelected
{
    self.imvSelected = imageViewSelected;
    
    [self.delegate sproutDidSelectedViewImage:self :self.imvSelected];
    NSLog(@"Delegate Selected");
}

-(void)touchInAImage:(DragDropImageView *)iSelected
{
    //NSLog(@"From Image: %@", iSelected);
}
-(void)dropInGrid:(DragDropImageView *)toImv
{
    //NSLog(@"To Image: %@", toImv);
}

-(void)touchEnableScroll:(DragDropImageView *)sender moveable:(BOOL)enableOK
{
    self.enable = enableOK;
    self.imvSelected = sender;
}

-(void)moveImageFrom:(DragDropImageView *)fromImage to:(DragDropImageView *)toImage
{
    //NSLog(@"Move image from %@ to %@", fromImage.url, toImage.url);
    //[self.delegate moveImageInSprout:self from:fromImage to:toImage];
}

#pragma mark
#pragma drag Photo into sprout

-(BOOL)photoIntoSprout: (UIImage *)inputImage url: (NSString *)urlOfImage atPoint: (CGPoint) intoPoint
{
    int activeTag = [self cellInPoint:intoPoint];
    NSLog(@"URL into = %@", urlOfImage);
    if([(DragDropImageView *)[[self subviews]objectAtIndex:activeTag] image] != nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Please select another cell to drag photo." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    [(DragDropImageView *)[[self subviews]objectAtIndex:activeTag] setUrlImage:urlOfImage];
    [(DragDropImageView *)[[self subviews]objectAtIndex:activeTag] setImage:inputImage];
    
    NSString *sName = [self.name stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *fileName = [NSString stringWithFormat:@"%@-atTag-%i", sName, activeTag];
    
    [(DragDropImageView *)[[self subviews]objectAtIndex:toTag] getImageFromFile:fileName input:inputImage];
    [self scrollRectToVisible:[(DragDropImageView *)[[self subviews]objectAtIndex:activeTag] frame] animated:YES];
    return YES;
}

@end
