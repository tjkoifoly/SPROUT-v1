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
#import "UIImageView+loadImage.h"

#define kSize 200
#define kMaxSize 2000
#define kSizeToPost 600

@implementation ExportSproutViewController
{
    UIImage *imageToSave;
    __block UIView *tempView;
    BOOL saved;
    __block UIView *tView;
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

-(void)loadData
{
    
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
    
    NSInteger standardSize = kSize;
    int row = sproutScroll.rowSize;
    int col = sproutScroll.colSize;
    if( row > 10 || col > 10)
    {
        int greater = row;
        if(col > row) greater = col;
        standardSize = kMaxSize/greater;
    } 
    
    NSLog(@"%i", standardSize);
    
    tempView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0, col * standardSize, row *standardSize)];
    tempView.layer.borderColor = [UIColor whiteColor].CGColor;
    tempView.layer.borderWidth = 2.0f;
    
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
        [imvX setFrame:CGRectMake(y*standardSize, x*standardSize, standardSize, standardSize)];
        imvX.layer.borderColor = [UIColor whiteColor].CGColor;
        imvX.layer.borderWidth = 1.f;
        [imvX loadImageFromLibAssetURL:[(DragDropImageView *)ix url]];
        // [(UIImageView *)ix loadImageFromLibAssetURL:[(DragDropImageView *)ix url]];
        [tempView addSubview:imvX];
        imvX = nil;
            
        });
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(saved == NO)
    {
        imageToSave = [self imageCaptureSave:tempView];
        tempView = nil;
        saved = YES;
        NSLog(@"SAVED.");
        [tView removeFromSuperview];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
         [self loadData];
    });
   
    NSLog(@"LOADING...");
        
    //Render sprout to image
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
{/*
    SendEmailViewController *sendEmailViewController = [[SendEmailViewController alloc] initWithNibName:@"SendEmailViewController" bundle:nil];

    sendEmailViewController.imageToSend = imageToSave;
    [self.navigationController pushViewController:sendEmailViewController animated:YES];
  */
    
    UIImage *mailImage = [self thumnailImageFromImageView:imageToSave];
    
    if ([MFMailComposeViewController canSendMail])
    {
        __block MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        //mailer.navigationItem.rightBarButtonItem.title = @"OK";
        mailer.mailComposeDelegate = self;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

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
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Mail cancelled: you cancelled the operation and no email message was queued." delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
            break;
        case MFMailComposeResultSaved:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Mail saved: you saved the email message in the drafts folder." delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            alert = nil;
            
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
        }
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Mail send: the email message is queued in the outbox. It is ready to send." delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            alert = nil;
            
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
        }
            break;
        case MFMailComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Mail failed: the email message was not saved or queued, possibly due to an error." delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            alert = nil;

            
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

-(IBAction)saveAsImage:(id)sender
{
    //imageToSave = [self imageCaptureSave:tempView];
    
    self.emailButton.hidden = YES;
    self.purchaseButton.hidden = YES;
    self.saveButton.hidden = YES;
    
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
    
}

-(IBAction)shareViaSocialNetwork:(id)sender
{
    UIImage *postImage = [self thumnailImageFromImageView:imageToSave];
    UIButton *shareButton = (UIButton *)sender;
    
    //POST ON TWITTER
    if(shareButton.tag == 1)
    {
        if([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc]init];
            [tweetSheet setInitialText:@"You can write tittle for picture to post Twitter !"];
            
            //Set image in HERE
            [tweetSheet addImage:postImage];
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
                                        UIImage *imgToPost = postImage;
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
