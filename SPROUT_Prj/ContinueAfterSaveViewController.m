//
//  ContinueAfterSaveViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ContinueAfterSaveViewController.h"
#import "UploadToSproutViewController.h"
#import "EditImageViewController.h"
#import <Twitter/Twitter.h>

@implementation ContinueAfterSaveViewController

@synthesize imageInput;
@synthesize viewImage;
@synthesize urlImage;

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
    viewImage.image = imageInput;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageInput = nil;
    self.viewImage = nil;
    self.urlImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBAction

-(IBAction)uploadToSprout:(id)sender
{
    UploadToSproutViewController *uploadViewController = [[UploadToSproutViewController alloc] initWithNibName:@"UploadToSproutViewController" bundle:nil];
    
    uploadViewController.urlImage = self.urlImage;
    uploadViewController.imageInput = self.imageInput;
    
    [self.navigationController pushViewController:uploadViewController animated:YES];
}

-(IBAction)edit:(id)sender
{
    EditImageViewController *editViewController = [[EditImageViewController alloc] initWithNibName:@"EditImageViewController" bundle:nil];
    
    editViewController.imageToEdit = self.imageInput;
    editViewController.delegate = self;
    
    [self.navigationController pushViewController:editViewController animated:YES];
}

-(IBAction)postToSocialNetwork:(id)sender
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
            [tweetSheet addImage:[UIImage imageNamed:@"baby"]];
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

}

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)saveImage:(EditImageViewController *)controller withImage:(UIImage *)imageSaved andURL:(NSString *)urlOfImage
{
    self.imageInput = imageSaved;
    self.viewImage.image = self.imageInput;
    self.urlImage = urlOfImage;
}

@end
