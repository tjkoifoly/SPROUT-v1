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
//#define kOAuthConsumerKey        @"38Sta1K1CLYsGrIZ8Vhxw"         //REPLACE With Twitter App OAuth Key    
//#define kOAuthConsumerSecret    @"3PFrnOPxcU0t1lpNQfTAkmlEp18sHw9divmAnz2zyPo"     //REPLACE With Twitter App OAuth Secret  
#define TWITPIC_API_KEY @"ee5b53769c6055e2a9cd022c3d9e6f4c"
#define TWITPIC_API_FORMAT @"json"

@implementation ContinueAfterSaveViewController
{
    BOOL logged;
    SA_OAuthTwitterEngine *_engine;
    GSTwitPicEngine *twitpicEngine;

    __block UIView *tempView;
}

@synthesize imageInput;
@synthesize viewImage;
@synthesize urlImage;
@synthesize imageLinks;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
     
}

-(void)applicationWillResignActive
{
    if(tempView != nil)
    {
        [tempView removeFromSuperview];
        tempView = nil;
        NSLog(@"QUIT FROM POST");
    }
  
    [self hudWasHidden:HUD];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageInput     = nil;
    self.viewImage      = nil;
    self.urlImage       = nil;
    _engine             = nil;
    tempView            = nil;
    self.imageLinks     = nil;
    twitpicEngine       = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)postTwitteriOS4
{
    twitpicEngine = (GSTwitPicEngine *)[GSTwitPicEngine twitpicEngineWithDelegate:self];   
    
    if (_engine == nil) {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _engine.consumerKey = TWITTER_OAUTH_CONSUMER_KEY;
        _engine.consumerSecret = TWITTER_OAUTH_CONSUMER_SECRET;      
    }
   
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        
        [self presentModalViewController:controller animated:YES];  
    }  else
    {
        SA_OAuthTwitterController *controller1 = [[SA_OAuthTwitterController alloc] initWithEngine: _engine andOrientation: UIInterfaceOrientationPortrait];
        controller1.delegate = self;
        
        [self presentModalViewController:controller1 animated:YES];
        //[twitpicEngine setAccessToken:[_engine getAccessToken]];
        //[twitpicEngine uploadPicture:self.imageInput withMessage:@"Post from my iPhone"];
    }
}

- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}


#pragma mark SA_OAuthTwitterEngineDelegate    

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
   
    [twitpicEngine setAccessToken:[_engine getAccessToken]];
    [twitpicEngine uploadPicture:self.imageInput withMessage:@"Post from my iPhone"];
    
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    if(tempView != nil)
    {
        [tempView removeFromSuperview];
        tempView = nil;
    }
    
    [self hudWasHidden:HUD];
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    if(tempView != nil)
    {
        [tempView removeFromSuperview];
        tempView = nil;
    }
    [self hudWasHidden:HUD];
	NSLog(@"Authentication Canceled.");
}

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:data forKey: @"authData"];
	[defaults synchronize];
    NSLog(@"Data: %@",data);
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    NSLog(@"Data: %@",[[NSUserDefaults standardUserDefaults] objectForKey: @"authData"]);
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark TwitterEngineDelegate  
- (void) requestSucceeded: (NSString *) requestIdentifier {  
    NSLog(@"Request %@ succeeded", requestIdentifier);  
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);  
} 

#pragma mark -
#pragma mark - GSTwitPicEngineDelegate
- (void)twitpicDidFinishUpload:(NSDictionary *)response {
    
    [self hudWasHidden:HUD];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shared succeed." message:@"Photo was posted on your twitter." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    if(tempView != nil)
    {
        [tempView removeFromSuperview];
        tempView = nil;
    }
    NSLog(@"TwitPic finished uploading: %@", response);
    
    // [response objectForKey:@"parsedResponse"] gives an NSDictionary of the response one of the parsing libraries was available.
    // Otherwise, use [[response objectForKey:@"request"] objectForKey:@"responseString"] to parse yourself.
    
    //    if ([[[response objectForKey:@"request"] userInfo] objectForKey:@"message"] > 0 && [[response objectForKey:@"parsedResponse"] count] > 0) {
    // Uncomment to update status upon successful upload, using MGTwitterEngine's instance.
    //        [twitterEngine sendUpdate:[NSString stringWithFormat:@"%@ %@", [[[response objectForKey:@"request"] userInfo] objectForKey:@"message"], [[response objectForKey:@"parsedResponse"] objectForKey:@"url"]]];
    //    }
    NSDictionary *parsedResponse = [response objectForKey:@"parsedResponse"];
    NSString *imageLink = [parsedResponse objectForKey:@"url"];
//    [imageLinks addObject:imageLink];
//    if (imageLinks.count == 1) {
//        NSString *links = [NSString stringWithFormat:@"%@", [imageLinks objectAtIndex:0]];
//        NSLog(@"links: %@", links);
        NSString *update = [NSString stringWithFormat:@"Images: %@", imageLink];
        [_engine sendUpdate:update];
        
        
//    }
}

- (void)twitpicDidFailUpload:(NSDictionary *)error {
    
    if(tempView != nil)
    {
        [tempView removeFromSuperview];
        tempView = nil;
    }
    
    [self hudWasHidden:HUD];
    
    NSLog(@"TwitPic failed to upload: %@", error);
    
    if ([[error objectForKey:@"request"] responseStatusCode] == 401) {
        //        UIAlertViewQuick(@"Authentication failed", [error objectForKey:@"errorDescription"], @"OK");
    }    
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
        /*
        NSString *reqSysVer = @"5.0";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
        {
            [self postTwitter:self.imageInput];
        }else{
            tempView = [[UIView alloc] initWithFrame:self.view.frame];
            tempView.backgroundColor = [UIColor blackColor];
            tempView.alpha = 0.5f;
            __block UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicator.center = tempView.center;
            //indicator.color = [UIColor blackColor];
            indicator.hidesWhenStopped = YES;
            [tempView addSubview:indicator];
            [indicator startAnimating];
            [self.view addSubview:tempView];
            
            [self postTwitteriOS4];
            //[_engine sendUpdate:@"FOLY"];
        }
         */
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Sharing...";
        [HUD show:YES];
        
        //[HUD showWhileExecuting:@selector(postTwitteriOS4) onTarget:self withObject:nil animated:YES];
        
        [self postTwitteriOS4];
        
    }
    //POST ON FACEBOOK
    else if(shareButton.tag == 2)
    {
        /*
        tempView = [[UIView alloc] initWithFrame:self.view.frame];
        tempView.backgroundColor = [UIColor blackColor];
        tempView.alpha = 0.5f;
        __block UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = tempView.center;
        //indicator.color = [UIColor blackColor];
        indicator.hidesWhenStopped = YES;
        [tempView addSubview:indicator];
        [indicator startAnimating];
        [self.view addSubview:tempView];
         */
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Sharing...";
        [HUD show:YES];
        
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
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shared succeed." message:@"Photo was posted on your facebok." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                [alert show];
                                            }
                                            /*
                                            if(tempView != nil)
                                            {
                                                //[indicator stopAnimating];
                                                [tempView removeFromSuperview];
                                                tempView = nil;
                                            }
                                             */
                                            [self hudWasHidden:HUD];
                                            
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

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

@end
