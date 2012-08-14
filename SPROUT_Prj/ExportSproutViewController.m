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

@implementation ExportSproutViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sproutToImage      = nil;
    self.emailButton        = nil;
    self.purchaseButton     = nil;
    self.saveButton         = nil;
    self.sproutScroll       = nil;
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
    self.emailButton.hidden = YES;
    self.purchaseButton.hidden = YES;
    self.saveButton.hidden = YES;
    
    CGSize sizeOfSprout = [self.sproutScroll contentSize];
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0, sizeOfSprout.width, sizeOfSprout.height)];
    for(id ix in self.sproutScroll.subviews)
    {
        [tempView addSubview:ix];
    }
    //[self.view addSubview:tempView];
    
    UIImage *imageX = [self imageCaptureSave:tempView];
    self.sproutToImage.image = imageX;

    //Save image to asset library
    CGPoint pointCenter = [self.sproutToImage center];
    if(tempView.bounds.size.width < self.sproutToImage.bounds.size.width)
    {
        [self.sproutToImage setFrame:tempView.frame];
        self.sproutToImage.center = pointCenter;
    }
    
    self.sproutToImage.hidden = NO;
}

-(IBAction)shareViaSocialNetwork:(id)sender
{
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
