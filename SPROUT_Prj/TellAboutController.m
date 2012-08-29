//
//  TellAboutController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/27/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "TellAboutController.h"

@implementation TellAboutController
{
    __block MBProgressHUD *HUD;
    SA_OAuthTwitterEngine *_engine;
}

@synthesize titleApp;
@synthesize comment;

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
    comment.layer.cornerRadius = 20.f;
    comment.layer.borderColor = [UIColor blackColor].CGColor;
    comment.layer.borderWidth = 2.f;
    titleApp.layer.cornerRadius = 10.f;
    titleApp.layer.borderColor = [UIColor blackColor].CGColor;
    titleApp.layer.borderWidth = 1.f;
    
    self.navigationItem.title = @"About";
    
    self.navigationController.navigationBarHidden = NO;
    //Back Button
    UIButton *backButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0,-5,60,30);
    [backButton addTarget:self action:@selector(backtoPreviousView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton =YES;
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
}

-(void)applicationWillResignActive
{
    [self hudWasHidden:HUD];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    titleApp  = nil;
    comment = nil;
    HUD = nil;
    _engine = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)backtoPreviousView
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma IBAction

-(IBAction)resignKeyboard:(id)sender
{
    [self.titleApp resignFirstResponder];
    [self.comment resignFirstResponder];
}

-(IBAction)sendEmail:(id)sender
{
     __block MFMailComposeViewController *mailer;
    if([MFMailComposeViewController canSendMail])
    {
        
            mailer = [[MFMailComposeViewController alloc]init];
            mailer.mailComposeDelegate = self;
            
                            
            [mailer setSubject:[NSString stringWithFormat:@"SPROUT and more app - %@", titleApp.text ]];
            NSArray *toRecipients = [NSArray arrayWithObjects:nil];
            [mailer setToRecipients:toRecipients];
                
            NSString *emailBody = comment.text;
            [mailer setMessageBody:emailBody isHTML:NO];
                
                
            [self presentModalViewController:mailer animated:YES];
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Set up a mail account in Settings." delegate:nil cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
        
    }
}

-(IBAction)shareFB:(id)sender
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    //HUD.backgroundColor = [UIColor blackColor];
    HUD.delegate = self;
    HUD.labelText = @"Sharing...";
    //[HUD show:YES];
    
    //[FBSession sessionOpen];
    
    NSArray *permissions =  [NSArray arrayWithObjects:
                              @"read_stream", @"publish_stream", @"offline_access",nil] ;
    [[FBSession sessionOpen] closeAndClearTokenInformation];
    [FBSession sessionOpenWithPermissions:permissions 
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
                                    NSString *message = [NSString stringWithFormat:@"SPROUT and more!\nTitle:keep loving moments with Sprout - %@\n%@ \nPost at %@\nContact us: http://cnc.com.vn", titleApp.text, comment.text, [NSDate date]];
                                    NSLog(@"%@", message);
                                    
                                    //UIImage *photo = [UIImage imageNamed:@"baby"];
                                    
                                    FBRequest *statusRequest = [FBRequest requestForPostStatusUpdate:message];
                                    
                                    NSLog(@"%@", statusRequest);
                                    
                                    [statusRequest startWithCompletionHandler:^(FBRequestConnection *connection1, id result, NSError *error) {
                                        if(error == nil)
                                        {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful shared." message:@"Tell with more friends about app ." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                            [alert show];
                                        }else
                                        {
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Please check again network connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                            [alert show];
                                        }
                                        
                                        [self hudWasHidden:HUD];
                                        
                                    }];
                                    
                                }];
                            }
                        }];
}

-(IBAction)shareTW:(id)sender
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    //HUD.backgroundColor = [UIColor blackColor];
    HUD.delegate = self;
    HUD.labelText = @"Sharing...";
    [HUD show:YES];
    
    if (_engine == nil) {
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
        _engine.consumerKey = TWITTER_OAUTH_CONSUMER_KEY;
        _engine.consumerSecret = TWITTER_OAUTH_CONSUMER_SECRET;        
    }
    //[_engine clearAccessToken];
    if(![_engine isAuthorized]){  
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        [_engine requestAccessToken];
        [self presentModalViewController:controller animated:YES];  
    }  else
    {
        SA_OAuthTwitterController *controller1 = [[SA_OAuthTwitterController alloc] initWithEngine: _engine andOrientation: UIInterfaceOrientationPortrait];
        controller1.delegate = self;
        
        [self presentModalViewController:controller1 animated:YES];
        
    }
}

#pragma mark
#pragma Mail delegate
-(void)alertCancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Mail cancelled: you cancelled the operation and no email message was queued." delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    alert = nil;
}
-(void)alertSaved
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Mail saved: you saved the email message in the drafts folder." delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    alert = nil;
}
-(void)alertSent
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Mail send: the email message is queued in the outbox. It is ready to send." delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    alert = nil;
}
-(void)alertFailed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Mail failed: the email message was not saved or queued, possibly due to an error." delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    alert = nil;
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            [self performSelector:@selector(alertCancel) withObject:nil afterDelay:0.1f];
        }
            break;
        case MFMailComposeResultSaved:
        {
            
            [self performSelector:@selector(alertSaved) withObject:nil afterDelay:0.1f];
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
        }
            break;
        case MFMailComposeResultSent:
        {
            [self performSelector:@selector(alertSent) withObject:nil afterDelay:0.1f];
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
        }
            break;
        case MFMailComposeResultFailed:
        {
            [self performSelector:@selector(alertFailed) withObject:nil afterDelay:0.1f];
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
        }
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    controller.delegate = nil;
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark
#pragma HUD delegate

-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark SA_OAuthTwitterEngineDelegate 

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
    
    NSString *message = [NSString stringWithFormat:@"Share app: %@\n%@ \n-at %@\nContact us: http://cnc.com.vn", titleApp.text, comment.text, [NSDate date]];
    NSLog(@"%@", message);
    [_engine sendUpdate:message];
    
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    
    [self hudWasHidden:HUD];
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    
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
    [self hudWasHidden:HUD];
    [self backtoPreviousView];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful shared" message:@"Tell with more friends about app ." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"Request %@ succeeded", requestIdentifier);  
}  

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {  
    [self hudWasHidden:HUD];
    [self backtoPreviousView];
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);  
} 

#pragma mark
#pragma UIAlertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DCm." message:@"Tell with more friends about app ." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


@end
