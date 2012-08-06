//
//  SaveorDiscardPhotoViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SaveorDiscardPhotoViewController;
@protocol SaveOrDiscardPhotoDelegate <NSObject>

-(void) saveOrDiscardPhoto: (SaveorDiscardPhotoViewController *)controller: (BOOL) saved;

@end

@interface SaveorDiscardPhotoViewController : UIViewController

@property (assign, nonatomic) id <SaveOrDiscardPhotoDelegate> delegate;
@property (strong, nonatomic) UIImage *image;

-(IBAction)save:(id)sender;
-(IBAction)discard:(id)sender;
-(IBAction)goToHome:(id)sender;

@end
