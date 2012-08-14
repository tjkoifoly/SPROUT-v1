//
//  DisplaySproutViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ExportSproutViewController.h"
#import "SendEmailViewController.h"
#import "PurcharseCanvasViewController.h"
#import <Twitter/Twitter.h>
#import "CNCAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>

#define kSize 200

@implementation ExportSproutViewController
{
    UIImage *imageToSave;
    UIView *tempView;
    BOOL saved;
}

@synthesize sproutToImage;
@synthesize emailButton;
@synthesize purchaseButton;
@synthesize saveButton;
@synthesize sproutScroll;

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
    //CGSize sizeOfSprout = [self.sproutScroll contentSize];
    tempView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0, self.sproutScroll.colSize * kSize, self.sproutScroll.rowSize *kSize)];
    tempView.layer.borderColor = [UIColor whiteColor].CGColor;
    tempView.layer.borderWidth = 2.0f;
    int x;
    int y;
    for(id ix in self.sproutScroll.subviews)
    {
        y = [ix tag]%(self.sproutScroll.colSize);
        x = [ix tag]/(self.sproutScroll.colSize);
        
        [ix setFrame:CGRectMake(y*kSize, x*kSize, kSize, kSize)];
        [tempView addSubview:ix];
    }
    
    imageToSave = [self imageCaptureSave:tempView];
    saved = NO;
}

-(void)saveToLibrary: (UIImage *)imageForSave
{
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    
    __block NSString *urlString;
    
    [library writeImageToSavedPhotosAlbum:imageForSave.CGImage orientation:(ALAssetOrientation)imageForSave.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
     {
         urlString = [assetURL absoluteString];
         
         [library assetForURL:assetURL resultBlock:^(ALAsset *asset )
          {
              NSLog(@"we have our ALAsset!");
              
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successfull" message:
                                    [NSString stringWithFormat:@"Save sprout as image to Library!%@"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
              [alert show];
          } 
                 failureBlock:^(NSError *error )
          {
              NSLog(@"Error loading asset");
          }];
     }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sproutToImage      = nil;
    self.emailButton        = nil;
    self.purchaseButton     = nil;
    self.saveButton         = nil;
    self.sproutScroll       = nil;
    imageToSave             = nil;
    tempView                = nil;
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

-(IBAction)sendViaEmail:(id)sender
{
    SendEmailViewController *sendEmailViewController = [[SendEmailViewController alloc] initWithNibName:@"SendEmailViewController" bundle:nil];

    sendEmailViewController.imageToSend = imageToSave;
    [self.navigationController pushViewController:sendEmailViewController animated:YES];
}

-(IBAction)purcharseCanvas:(id)sender
{
    PurcharseCanvasViewController *purchaseViewController = [[PurcharseCanvasViewController alloc] initWithNibName:@"PurcharseCanvasViewController" bundle:nil];
    
    [self.navigationController pushViewController:purchaseViewController animated:YES];
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

-(IBAction)saveAsImage:(id)sender
{
    saved = YES;
    
    self.emailButton.hidden = YES;
    self.purchaseButton.hidden = YES;
    self.saveButton.hidden = YES;
    
    self.sproutToImage.image = imageToSave;

    //Save image to asset library
    CGPoint pointCenter = [self.sproutToImage center];
    if(tempView.bounds.size.width < self.sproutToImage.bounds.size.width)
    {
        [self.sproutToImage setFrame:tempView.frame];
        self.sproutToImage.center = pointCenter;
    }
    
    [self saveToLibrary:imageToSave];
    self.sproutToImage.hidden = NO;
    
}

-(IBAction)shareViaSocialNetwork:(id)sender
{
    /*
    if(!saved)
    {
        UIAlertView *alertSave = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"Sprout has not been saved.\nPlease save sprout before share." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertSave show];
        return;
    }
     */
    
    UIButton *shareButton = (UIButton *)sender;
    
    //POST ON TWITTER
    if(shareButton.tag == 1)
    {
        if([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc]init];
            [tweetSheet setInitialText:@"You can write tittle for picture to post Twitter !"];
            
            //Set image in HERE
            [tweetSheet addImage:self.sproutToImage.image];
            [self presentModalViewController:tweetSheet animated:YES];
        }else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't send a tweet right now, make sure  your device has an internet connection and you have                                at least one Twitter account setup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    //POST ON FACEBOOK
    else if(shareButton.tag == 2)
    {
        
        __block UIView *tempViewPost = [[UIView alloc] initWithFrame:self.view.frame];
        tempViewPost.backgroundColor = [UIColor blackColor];
        tempViewPost.alpha = 0.5f;
        __block UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = tempViewPost.center;
        //indicator.color = [UIColor blackColor];
        indicator.hidesWhenStopped = YES;
        [tempViewPost addSubview:indicator];
        [indicator startAnimating];
        [self.view addSubview:tempViewPost];
        
        [FBSession sessionOpenWithPermissions:nil 
                            completionHandler:^(FBSession *session, 
                                                FBSessionState status, 
                                                NSError *error) {
                                // session might now be open.  
                                if (session.isOpen) {
                                    FBRequest *me = [FBRequest requestForMe];
                                    [me startWithCompletionHandler: ^(FBRequestConnection *connection, 
                                                                      NSDictionary<FBGraphUser> *my,
                                                                      NSError *error) {
                                        NSLog(@"%@", my.first_name);
                                        UIImage *imgToPost = imageToSave;
                                        FBRequest *photoUploadRequest = [FBRequest requestForUploadPhoto:imgToPost];
                                        
                                        [photoUploadRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {        
                                            if(error == nil)
                                            {
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shared succeed." message:@"Sprout was posted on your facebok." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                [alert show];
                                                
                                                [indicator stopAnimating];
                                                [tempViewPost removeFromSuperview];
                                                tempViewPost = nil;
                                            }
                                            
                                        }];
                                        
                                    }];
                                }
                            }];
        
    }
    //POST ON LINKIN
    else if(shareButton.tag == 3)
    {
        
    }
        
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
}






@end
