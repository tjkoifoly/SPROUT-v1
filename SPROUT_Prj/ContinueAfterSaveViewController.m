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
#import <FacebookSDK/FacebookSDK.h> 
#import "SA_OAuthTwitterEngine.h"

#define kOAuthConsumerKey        @"sm1Qgf3RlbCtsC4GgLZw"         //REPLACE With Twitter App OAuth Key    
#define kOAuthConsumerSecret    @"S9ghHLlgPLAJ4dN2bAKyAqR2pF58FrygQUxhSKEieI"     //REPLACE With Twitter App OAuth Secret  

@implementation ContinueAfterSaveViewController
{
    BOOL logged;
    SA_OAuthTwitterEngine *_engine;
}

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
    self.imageInput     = nil;
    self.viewImage      = nil;
    self.urlImage       = nil;
    _engine = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)postTwitteriOS4
{
    if(!_engine){  
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;    
    }  
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        if (controller){  
            [self presentModalViewController: controller animated: YES];  
        }
    }  else
    {
        [_engine sendUpdate:@"OK DCM VCL"];
    }
    
}

#pragma mark SA_OAuthTwitterEngineDelegate  
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {  
    NSUserDefaults          *defaults = [NSUserDefaults standardUserDefaults];  
    
    [defaults setObject: data forKey: @"authData"];  
    [defaults synchronize];  
}  

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username { 
    //NSLog(@"%@", username);
    return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];  
}  

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark TwitterEngineDelegate  
- (void) requestSucceeded: (NSString *) requestIdentifier {  
    NSLog(@"Request %@ succeeded", requestIdentifier);  
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);  
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

-(void) postTwitter: (UIImage *)imageToPost
{
    if([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc]init];
        [tweetSheet setInitialText:@"You can write tittle for picture to post Twitter !"];
        
        //Set image in HERE
        [tweetSheet addImage:imageToPost];
        [self presentModalViewController:tweetSheet animated:YES];
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't send a tweet right now, make sure  your device has an internet connection and you have                                at least one Twitter account setup" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(IBAction)postToSocialNetwork:(id)sender
{
    UIButton *shareButton = (UIButton *)sender;
    
    //POST ON TWITTER
    if(shareButton.tag == 1)
    {
        NSString *reqSysVer = @"5.0";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
        {
            [self postTwitter:self.imageInput];
        }else{
            [self postTwitteriOS4];
            //[_engine sendUpdate:@"FOLY"];
        }
        
        
    }
    //POST ON FACEBOOK
    else if(shareButton.tag == 2)
    {
        __block UIView *tempView = [[UIView alloc] initWithFrame:self.view.frame];
        tempView.backgroundColor = [UIColor blackColor];
        tempView.alpha = 0.5f;
        __block UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = tempView.center;
        //indicator.color = [UIColor blackColor];
        indicator.hidesWhenStopped = YES;
        [tempView addSubview:indicator];
        [indicator startAnimating];
        [self.view addSubview:tempView];
        
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
                                        logged = YES;
                                        NSLog(@"%@", my.first_name);
                                        UIImage *imgToPost = self.imageInput;
                                        FBRequest *photoUploadRequest = [FBRequest requestForUploadPhoto:imgToPost];
                                        
                                        [photoUploadRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {        
                                            if(error == nil)
                                            {
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shared succeed." message:@"Image was posted on your facebok." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                [alert show];
                                                
                                                [indicator stopAnimating];
                                                [tempView removeFromSuperview];
                                                tempView = nil;
                                            }
                                            
                                        }];

                                    }];
                                }
                            }];
    }

}//END POST


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
