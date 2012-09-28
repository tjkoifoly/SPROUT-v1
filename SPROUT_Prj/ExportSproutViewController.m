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
#import "SaveSproutViewController.h"
#import <Twitter/Twitter.h>
#import "CNCAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+loadImage.h"
#import "MBProgressHUD.h"
#import "UIImage+FixRotation.h"
#import "Sprout.h"

#define kSize 200
#define kMaxSize 2000
#define kSizeToPost 600
#define kA4Width 2480
#define kA4Heigh 3508
// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@implementation ExportSproutViewController
{
    __block MBProgressHUD *HUD;
    UIImage *imageToSave;
    __block UIView *tempView;
   // __block UIView *tView;
    //__block UIView *tempViewPost;
    BOOL saved;
    //BOOL finished;
    UIScrollView *scrollView;
    SA_OAuthTwitterEngine *_engine;
    GSTwitPicEngine *twitpicEngine;
    __block MFMailComposeViewController *mailer;
    UIView *printPreview;
    BOOL preview;
    int COL;
    int ROW;
    int row;
    int col;
    NSString *sName;
    NSTimer * timer;
}

@synthesize sproutToImage;
@synthesize emailButton;
@synthesize purchaseButton;
@synthesize saveButton;
@synthesize sproutScroll;
@synthesize btnFB;
@synthesize btnTW;
@synthesize btnFB_before;
@synthesize btnTW_before;
@synthesize font1;
@synthesize font2;
@synthesize btnbackView;
@synthesize btnPreView;
@synthesize btnOpt;
@synthesize delegate;

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
    NSLog(@"WARNING WARNING WARNING MEMORY ...");
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



-(void)loadData
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    //HUD.backgroundColor = [UIColor blackColor];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD show:YES];
    
    /*
    tView  = [[UIView alloc] initWithFrame:self.view.frame];
    tView.backgroundColor = [UIColor blackColor];
    tView.alpha = 0.8f;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = tView.center;
    //indicator.color = [UIColor blackColor];
    indicator.hidesWhenStopped = YES;
    [tView addSubview:indicator];
    [indicator startAnimating];
    [self.view addSubview:tView];
    */
    sName = [sproutScroll name];
    
    NSInteger standardSize = kSize;
   
    row = sproutScroll.rowSize;
    col = sproutScroll.colSize;
    ROW = row;
    COL = col;
     /*
    if( row > 10 || col > 10)
    {
        int greater = row;
        if(col > row) greater = col;
        standardSize = kMaxSize/greater;
    } 
     */
    
    NSLog(@"%i", standardSize);
    
    tempView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0, col * standardSize+20, row *standardSize+20)];
    //tempView.layer.borderColor = [UIColor whiteColor].CGColor;
    //tempView.layer.borderWidth = 2.0f;
    tempView.backgroundColor = [UIColor clearColor];
    UIView *tempView2 = [[UIView alloc] initWithFrame:CGRectMake(10 , 10, col * standardSize, row *standardSize)];
    tempView2.backgroundColor = [UIColor clearColor];
    
    UIImageView *fontframe = [[UIImageView alloc] initWithFrame:tempView.frame];
    [fontframe setImage:[UIImage imageNamed:@"font-frame.png"]];
    [tempView addSubview:fontframe];
    
    [tempView addSubview:tempView2];
    
    __block int x;
    __block int y;
    __block UIImageView *imvX;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for(id ix in self.sproutScroll.subviews)
    {
        dispatch_sync(queue, ^{
        
        imvX = [[UIImageView alloc] init];
        y = [ix tag]%(self.sproutScroll.colSize);
        x = [ix tag]/(self.sproutScroll.colSize);
        [imvX setFrame:CGRectMake(y*standardSize + 5, x*standardSize + 5, standardSize - 10, standardSize - 10)];
        imvX.layer.borderColor = [UIColor whiteColor].CGColor;
        imvX.layer.borderWidth = 3.f;
        [imvX loadImageFromLibAssetURL:[(DragDropImageView *)ix url]];
        // [(UIImageView *)ix loadImageFromLibAssetURL:[(DragDropImageView *)ix url]];
        [tempView2 addSubview:imvX];
        
        });
        
    }
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(tempView.bounds.size.width - 80, tempView.bounds.size.height - 70, 60, 50)];
    logo.image = [UIImage imageNamed:@"logo.png"];
    [tempView addSubview:logo];
    
    dispatch_release(queue);
    self.sproutScroll = nil;
    
}

-(void)getImage
{
    if([self performSelector:@selector(checkFinished)])
    {
        imageToSave = [self imageCaptureSave:tempView];
        NSData* pngdata = UIImagePNGRepresentation (imageToSave); //PNG wrap 
        UIImage* img = [UIImage imageWithData:pngdata];
        imageToSave = img;
        saved = YES;
        NSLog(@"SAVED.");
        /*
         [tView removeFromSuperview];
         tView = nil;
         */
        //tempView = nil;
        [self hudWasHidden:HUD];
        [timer invalidate];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(saved == NO)
    {
        //WHILE LOOP CHECK FINISH LOAD PHOTO
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [self performSelector:@selector(getImage) withObject:nil afterDelay:0.5f];
//        });
       timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(getImage) userInfo:nil repeats:YES];
        
    }
    
    [super viewDidAppear:YES];
}

-(BOOL)checkFinished
{
    for(id icheck in [[[tempView subviews] objectAtIndex:1] subviews])
    {
        if([icheck tag] != 1)
        {
            return NO;
        }
    }
    
    return YES;
}

-(void)applicationWillResignActive
{
//    if(tempViewPost != nil)
//    {
//        [tempViewPost removeFromSuperview];
//        tempViewPost = nil;
//        NSLog(@"QUIT FROM POST");
//    }
    
    [self hudWasHidden:HUD];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    preview = NO;
    
    self.delegate = [[self.navigationController viewControllers] objectAtIndex:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
   
    NSLog(@"LOADING...");
    
    
    //Render sprout to image
    saved = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
    [super viewDidLoad];
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
              
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful" message:
                                    [NSString stringWithFormat:@"Sprout was saved as image to Library!"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    _engine                 = nil;
    twitpicEngine           = nil;
    mailer                  = nil;
    HUD                     = nil;
    scrollView              = nil;
    btnTW                   = nil;
    btnFB                   = nil;
    btnTW_before            = nil;
    btnFB_before            = nil;
    font1                   = nil;
    font2                   = nil;
    btnbackView             = nil;
    printPreview            = nil;
    btnPreView              = nil;
    btnOpt                  = nil;
    sName                   = nil;
    delegate                = nil;
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

-(IBAction)optimize:(id)sender
{
    //COL = 2;
    //ROW = 15;
    int product = COL * ROW;
    int min = MIN(COL, ROW);
    int max = (int)sqrt(product*1.0);
    NSLog(@"MIN = %i, %i", min, max);
    int temp = max;
    while (min <= max) {
        if((product % min) == 0)
        {
            temp = product/min;
        }
        min++;
    }
    ROW = temp;
    COL = product / temp;
    
    NSLog(@"ROW = %i,COL = %i", ROW, COL);
    NSLog(@"OPTIMIZING ... ");
    NSManagedObject *s = [Sprout sproutForName:sName];
    if(COL == [[s valueForKey:@"colSize"] intValue])
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Oh Yeah" message:@"Sprout is best match A4" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert1 show];
        
    } else if([Sprout optimizeSprout:sName withCol:COL andRow:ROW])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Optimize sprout match to A4 paper!" message:@"Accept and reload sprout!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

#pragma mark - UIAlert View Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%i", buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            [self.delegate optimizeSproutReview:sName];
        }
            break;
            
        case 1:
            [Sprout optimizeSprout:sName withCol:col andRow:row];
            break;
        default:
            break;
    }
}

-(IBAction)backViewAction:(id)sender
{
//    self.emailButton.hidden = NO;
//    self.purchaseButton.hidden = NO;
//    self.saveButton.hidden = NO;
//    self.btnFB.hidden = YES;
//    self.btnTW.hidden = YES;
//    self.btnFB_before.hidden = NO;
//    self.btnTW_before.hidden = NO;
//    font1.hidden =NO;
//    font2.hidden = YES;
    [self showContent:NO];
    btnPreView.hidden = NO;
    btnbackView.hidden = YES;
    btnOpt.hidden = NO;
     self.sproutToImage.hidden = YES;
    scrollView.hidden = YES;
}

-(IBAction)sendViaEmail:(id)sender
{/*
    SendEmailViewController *sendEmailViewController = [[SendEmailViewController alloc] initWithNibName:@"SendEmailViewController" bundle:nil];

    sendEmailViewController.imageToSend = imageToSave;
    [self.navigationController pushViewController:sendEmailViewController animated:YES];
  */

    if([MFMailComposeViewController canSendMail])
    {
        if(mailer == nil)
        {
        dispatch_queue_t queuemail = dispatch_get_global_queue(0, 0);
        UIImage *mailImage = [self thumnailImageFromImageView:imageToSave];
        mailer = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;
        
        dispatch_async(queuemail, ^{
            
            [mailer setSubject:@"Your sprout to send"];
            NSArray *toRecipients = [NSArray arrayWithObjects:nil];
            [mailer setToRecipients:toRecipients];
            
            UIImage *myImage = mailImage;
            NSLog(@"%f x %f", myImage.size.width, myImage.size.height);
            NSData *imageData = UIImagePNGRepresentation(myImage);
            [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"MyCoolSprout"];
            
            NSString *emailBody = @"Comment ........";
            [mailer setMessageBody:emailBody isHTML:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentModalViewController:mailer animated:YES];
            });
        });
        
        dispatch_release(queuemail);
        
        }else
        {
            [self presentModalViewController:mailer animated:YES];
        }
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Set up a mail account in Settings." delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}

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
    mailer = nil;
}

-(IBAction)purcharseCanvas:(id)sender
{
    PurcharseCanvasViewController *purchaseViewController = [[PurcharseCanvasViewController alloc] initWithNibName:@"PurcharseCanvasViewController" bundle:nil];
    
    [self saveImageToFile:@"tjkoi.png" input:imageToSave];
    
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

-(UIImage *)thumnailImageFromImageView: (UIImage *)inputImage
{
    float w = imageToSave.size.width;
    float h = imageToSave.size.height;
    float greater = w;
    if(h>w) greater = h;
    if(greater > kSizeToPost) greater = kSizeToPost;
    if(w > h)
    {
        h = ((1.0)*h/w)*greater;
        w = greater;
    }else
    {
        w = (1.0 *w/h)*greater;
        h = greater;
    }
    
    //NSLog(@"%f x %f", w, h);
    
    UIImageView *imvToRender = [[UIImageView alloc] initWithImage:inputImage];
    [imvToRender setFrame:CGRectMake(0.0, 0.0, w, h)];
    [imvToRender setContentMode:UIViewContentModeScaleToFill];
    
    return [self imageCaptureSave:imvToRender];
}

-(void)showContent:(BOOL)show
{
    self.emailButton.hidden = show;
    self.purchaseButton.hidden = show;
    self.saveButton.hidden = show;
    self.btnFB.hidden = (!show);
    self.btnTW.hidden = (!show);
    self.btnFB_before.hidden = show;
    self.btnTW_before.hidden = show;
    font1.hidden = show;
    //font2.hidden = (!show);
}

-(IBAction)saveAsImage:(id)sender
{
    //imageToSave = [self imageCaptureSave:tempView];
    
    self.emailButton.hidden = YES;
    self.purchaseButton.hidden = YES;
    self.saveButton.hidden = YES;
    self.btnFB.hidden = NO;
    self.btnTW.hidden = NO;
    self.btnFB_before.hidden = YES;
    self.btnTW_before.hidden = YES;
    font1.hidden =YES;
    font2.hidden = NO;
    //[self showContent:YES];
    
    btnbackView.hidden = NO;
    btnPreView.hidden = YES;
    btnOpt.hidden = YES;
    self.sproutToImage.image = imageToSave;

    //Save image to asset library
    /*
    CGPoint pointCenter = [self.sproutToImage center];
    if(tempView.bounds.size.width < self.sproutToImage.bounds.size.width)
    {
        [self.sproutToImage setFrame:tempView.frame];
        self.sproutToImage.center = pointCenter;
    }
     */
    
    [self saveToLibrary:imageToSave];
    self.sproutToImage.hidden = NO;
    [self viewPhoto];
}

-(IBAction)printPreview:(id)sender
{
    preview = !preview ;
    if(preview)
    {
        [self showContent:YES];
        float height = 410;
        
        float frameWidth = height * (kA4Width * 1.0f/kA4Heigh) - 20.f;
        
        printPreview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 46,frameWidth , height)];
        printPreview.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        printPreview.layer.borderColor = [UIColor blackColor].CGColor;
        printPreview.layer.borderWidth = 1.f;
        CGFloat centery = printPreview.center.y;
        CGFloat centerx = 320.f / 2;
        CGPoint newcenter = CGPointMake(centerx, centery);
        
        printPreview.center = newcenter;
        
        UIImage *printImage = imageToSave;
        
        height = printPreview.frame.size.height-20;
        frameWidth = printPreview.frame.size.width - 20;
        
        UIImageView *a4;
        if(printImage.size.width > printImage.size.height)
        {
            height = printPreview.frame.size.width - 20;
            frameWidth = printPreview.frame.size.height-20;
        }
    
        a4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, height)];

        [a4 setContentMode:UIViewContentModeScaleAspectFit];
        a4.center = CGPointMake(printPreview.frame.size.width / 2.f, printPreview.frame.size.height /2.f);
    
        [printPreview addSubview:a4];
    
       
        if(printImage.size.width > printImage.size.height)
        {
            CGAffineTransform transform = 
            CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90));
            a4.transform = transform;
        }
        
        a4.image = printImage;
        [self.view addSubview:printPreview];
    }else
    {
        [printPreview removeFromSuperview];
        [self showContent:NO];
    }
}

-(void)viewPhoto
{
    if(scrollView == nil)
    {
    scrollView = [[UIScrollView alloc] initWithFrame:self.sproutToImage.frame];
    [scrollView setScrollEnabled: YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setMaximumZoomScale:5.f];
    [scrollView setMinimumZoomScale:1.0f];
    [self.sproutToImage setFrame:CGRectMake(0.0, 0.0, scrollView.bounds.size.width, scrollView.bounds.size.height)];
    [scrollView addSubview:self.sproutToImage];
    scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    }else
    {
        scrollView.hidden = NO;
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.sproutToImage;
}

-(void)postTwitteriOS4 : (UIImage *)imageInput
{
    twitpicEngine = (GSTwitPicEngine *)[GSTwitPicEngine twitpicEngineWithDelegate:self];
    
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
        
        //[twitpicEngine setAccessToken:[_engine getAccessToken]];
        //[twitpicEngine uploadPicture:imageInput withMessage:@"Post sprout from my iPhone"];
        NSLog(@"POST");
    }
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


-(IBAction)shareViaSocialNetwork:(id)sender
{
    UIImage *postImage = [self thumnailImageFromImageView:imageToSave];
    UIButton *shareButton = (UIButton *)sender;
    
    //POST ON TWITTER
    if(shareButton.tag == 1)
    {
        /*
        NSString *reqSysVer = @"5.0";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
        {
            [self postTwitter:postImage];
        }else{
            tempViewPost = [[UIView alloc] initWithFrame:self.view.frame];
            tempViewPost.backgroundColor = [UIColor blackColor];
            tempViewPost.alpha = 0.5f;
            __block UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indicator.center = tempViewPost.center;
            //indicator.color = [UIColor blackColor];
            indicator.hidesWhenStopped = YES;
            [tempViewPost addSubview:indicator];
            [indicator startAnimating];
            [self.view addSubview:tempViewPost];
            
            [self postTwitteriOS4 : postImage];
            
        }
         */
        /*
        tempViewPost = [[UIView alloc] initWithFrame:self.view.frame];
        tempViewPost.backgroundColor = [UIColor blackColor];
        tempViewPost.alpha = 0.5f;
        __block UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = tempViewPost.center;
        //indicator.color = [UIColor blackColor];
        indicator.hidesWhenStopped = YES;
        [tempViewPost addSubview:indicator];
        [indicator startAnimating];
        [self.view addSubview:tempViewPost];
         */
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        //HUD.backgroundColor = [UIColor blackColor];
        HUD.delegate = self;
        HUD.labelText = @"Sharing...";
        [HUD show:YES];
        
        [self postTwitteriOS4:imageToSave];
    }
    //POST ON FACEBOOK
    else if(shareButton.tag == 2)
    {
        /*
        tempViewPost = [[UIView alloc] initWithFrame:self.view.frame];
        tempViewPost.backgroundColor = [UIColor blackColor];
        tempViewPost.alpha = 0.8f;
        __block UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.center = tempViewPost.center;
        //indicator.color = [UIColor blackColor];
        indicator.hidesWhenStopped = YES;
        [tempViewPost addSubview:indicator];
        [indicator startAnimating];
        [self.view addSubview:tempViewPost];
         */
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        //HUD.backgroundColor = [UIColor blackColor];
        HUD.delegate = self;
        HUD.labelText = @"Sharing...";
        [HUD show:YES];
        [[FBSession sessionOpen] closeAndClearTokenInformation];
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
                                        UIImage *imgToPost = postImage;
                                        FBRequest *photoUploadRequest = [FBRequest requestForUploadPhoto:imgToPost];
                                        [photoUploadRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                            if(error == nil)
                                            {
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful shared" message:@"Sprout was posted on your facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                [alert show];
                                            }else
                                            {
                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Please check again network connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                [alert show];
                                            }
                                            /*
                                            if(tempViewPost != nil)
                                            {
                                                //[indicator stopAnimating];
                                                [tempViewPost removeFromSuperview];
                                                tempViewPost = nil;
                                            }*/
                                            [self hudWasHidden:HUD];
                                            
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

#pragma mark SA_OAuthTwitterEngineDelegate 

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
    UIImage *postImage = [self thumnailImageFromImageView:imageToSave];
    
    [twitpicEngine setAccessToken:[_engine getAccessToken]];
    [twitpicEngine uploadPicture:postImage withMessage:@"Post sprout from my iPhone"];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
//    if(tempViewPost != nil)
//    {
//        [tempViewPost removeFromSuperview];
//        tempViewPost = nil;
//    }
    
    [self hudWasHidden:HUD];
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
//    if(tempViewPost != nil)
//    {
//        [tempViewPost removeFromSuperview];
//        tempViewPost = nil;
//    }
    
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful shared" message:@"Photo was posted on your twitter." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
//    if(tempViewPost != nil)
//    {
//        [tempViewPost removeFromSuperview];
//        tempViewPost = nil;
//    }
    
    [self hudWasHidden:HUD];
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
    
//    if(tempViewPost != nil)
//    {
//        [tempViewPost removeFromSuperview];
//        tempViewPost = nil;
//    }
    
    [self hudWasHidden:HUD];
    NSLog(@"TwitPic failed to upload: %@", error);
    
    if ([[error objectForKey:@"request"] responseStatusCode] == 401) {
        //        UIAlertViewQuick(@"Authentication failed", [error objectForKey:@"errorDescription"], @"OK");
    }    
}

#pragma mark
#pragma HUD delegate
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark
#pragma save image to file

-(NSString *)dataPathFile:(NSString *)fileName
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    
    NSLog(@"%@", documentDirectory);
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

-(UIImage *)loadImageFromFile: (NSString *)fileName
{
    UIImage *iFF = [UIImage imageWithContentsOfFile:[self dataPathFile:fileName]];
    //NSLog(@"%@", [self dataPathFile:fileName]);
    return iFF;
}
-(void)saveImageToFile : (NSString *)fileName input: (UIImage *)inputImage
{
    NSString *path = [self dataPathFile:fileName];    
    [UIImagePNGRepresentation(inputImage) writeToFile:path atomically:YES];
    NSLog(@"Saved");
    //return [UIImage imageWithContentsOfFile:path];
}



@end
