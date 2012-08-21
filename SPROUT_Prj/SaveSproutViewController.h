//
//  SaveSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragDropImageView.h"
#import "SproutScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewPhotoInSproutViewController.h"
#import "ContinueAfterSaveViewController.h"
#import "ExportSproutViewController.h"
#import "SaveorDiscardPhotoViewController.h"
#import "NYOBetterZoomUIScrollView.h"

@class SaveSproutViewController;
@protocol SaveSproutDelegate <NSObject>

-(void)captureContinue: (SaveSproutViewController *)controller;

-(void)loadFromLibContinue: (SaveSproutViewController *)controller toView: (ContinueAfterSaveViewController *)continueViewController;

-(void)loadFromLibToContinue: (SaveorDiscardPhotoViewController *)controller;

-(void)exportSproutOK: (SaveSproutViewController *)controller toView: (ExportSproutViewController *)expController;

@end

@interface SaveSproutViewController : UIViewController
<SproutDelegate, DeletePhotoDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, BetterZoomDelegate>

@property (strong, nonatomic) SproutScrollView *sproutScroll;
@property (assign, nonatomic) id <SaveSproutDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *sproutView;
@property (strong, nonatomic) IBOutlet UIButton *exportButton;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIButton *capButton;
@property (strong, nonatomic) IBOutlet UIButton *libButton;

@property (nonatomic) BOOL fromDrag;
@property (strong, nonatomic) NSManagedObject *sprout;
@property (strong, nonatomic) NSMutableArray *imagesArray;

-(IBAction)goToHome:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)exportSport:(id)sender;
-(IBAction)capturePressed:(id)sender;
-(IBAction)loadLibPressed:(id)sender;
-(IBAction)viewFullScreen:(id)sender;

-(void)enableExport;
-(void)exportFunction;
- (void)setMinimumZoomForCurrentFrame;

@end
