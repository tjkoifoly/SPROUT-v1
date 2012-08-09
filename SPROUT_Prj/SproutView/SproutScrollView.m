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
            
            DragDropImageView *imv = [[DragDropImageView alloc] initWithLocationX:i andY:j fromURL:u : cellWidth];
            
            //imv.image = [UIImage imageNamed:@"baby"];
            imv.tag = t;
            imv.userInteractionEnabled = YES;
            imv.delegate = self;
            
            [self addSubview:imv];
            
            //NSLog(@"%i %i %i", i , j, imv.tag);
        }
    }
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 2.f;
    
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
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 2.f;

    return self;
}

-(void) updateImageToSprout: (NSString *) imageURL  inTag:(NSInteger)cellTag
{
    [((DragDropImageView*)[self.subviews objectAtIndex:cellTag]) loadImageFromAssetURL:[NSURL URLWithString:imageURL]];
    ((DragDropImageView*)[self.subviews objectAtIndex:cellTag]).url = imageURL;
    
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
    NSLog(@"From Image: %@", iSelected);
}
-(void)dropInGrid:(DragDropImageView *)toImv
{
    NSLog(@"To Image: %@", toImv);
}

-(void)touchEnableScroll:(DragDropImageView *)sender moveable:(BOOL)enableOK
{
    self.enable = enableOK;
    self.imvSelected = sender;
}

-(void)moveImageFrom:(DragDropImageView *)fromImage to:(DragDropImageView *)toImage
{
    NSLog(@"Move image from %@ to %@", fromImage.url, toImage.url);
    [self.delegate moveImageInSprout:self from:fromImage to:toImage];
}

@end
