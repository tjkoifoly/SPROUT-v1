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

#define kWidth 40
#define kHeight 40
#define kMAXWidth 280
#define kMAXHeight 280

@implementation SproutScrollView

@synthesize rowSize;
@synthesize colSize;
@synthesize name;
@synthesize images;

-(id)initWithrowSize: (NSInteger) rs andColSize: (NSInteger) cs
{
    self.rowSize = rs;
    self.colSize = cs;
    
    int maxWidth = self.colSize * kWidth;
    int maxHeight = self.rowSize * kHeight;
    
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
    
    [self setContentSize:CGSizeMake(self.rowSize * kWidth, self.colSize *kHeight)];
    [self setScrollEnabled:YES];
        for(int i = 0; i< self.rowSize ; i++)
        {
            for(int j = 0; j < self.colSize; j++)
            {
                DragDropImageView *imv = [[DragDropImageView alloc] initWithLocationX:i andY:j];
                
                imv.image = [UIImage imageNamed:@"baby"];
                imv.tag = i * (self.colSize) + j;
                imv.userInteractionEnabled = YES;
                [self addSubview:imv];
                
                NSLog(@"%i %i %i", i , j, imv.tag);
            }
        }
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 2.f;

    if(((maxWidth<kMAXWidth)) && ((maxHeight<kMAXHeight)))
    {
        [self setScrollEnabled:NO];
    }
    return self;
}

-(void) updateImageToSprout: (NSMutableArray *) imagesOfSprout
{
    
}

@end
