//
//  ConfirmPurchaseViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ConfirmPurchaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ConfirmPurchaseViewController
{
    MFMailComposeViewController *mailer;
    UIAlertView *conditionAlert;
}

@synthesize accept;
@synthesize acceptView;
@synthesize product;

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

-(NSString *)dataPathFile:(NSString *)fileName
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    
    NSLog(@"%@", documentDirectory);
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.acceptView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.acceptView.layer.borderWidth = 1.f;
    
    if ([MFMailComposeViewController canSendMail])
    {
        if(mailer == nil)
        {
        //queue = dispatch_get_global_queue(0, 0);
        
        //dispatch_async(queue, ^{
            mailer = [[MFMailComposeViewController alloc]init];
            
            mailer.mailComposeDelegate = self;
            [mailer setTitle:@"PRINT"];
            [mailer setSubject:@"Request printing a canvas"];
            NSString *serviceMail =  @"congnguyen@cnc.com.vn";
            NSArray *toRecipients = [NSArray arrayWithObjects:serviceMail, nil];
            [mailer setToRecipients:toRecipients];
            
            //[toRecipients release];
            NSData *imageData = [NSData dataWithContentsOfFile:[self dataPathFile:@"tjkoi.png"]];
            [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mycoolsprout.png"];
            
            NSString *emailBody = [NSString stringWithFormat:@"Size of canvas : %@", self.product] ;
            [mailer setMessageBody:emailBody isHTML:NO];
            
            [imageData release];
            NSLog(@"%i",[imageData retainCount]);
            
       // });
        
        //dispatch_release(queue);
        }

    }
    
    accept = NO;
    [self touchCheck];
}

-(void)dealloc
{
    NSLog(@"HERE");
    [acceptView release];
    acceptView = nil;
     
    [product release];
    product = nil;
    
    [conditionAlert release];
    conditionAlert = nil;
    
    if(!mailer)
    {
        [mailer release];
        mailer = nil;
    }
        
    [super dealloc];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.acceptView = nil;
    self.product    = nil;
    HUD = nil;
    conditionAlert = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    //[self hudWasHidden:HUD];
    [super viewDidDisappear:YES];
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

-(IBAction)confirmPurchase:(id)sender
{
    if(accept)
    {
        [MKStoreManager setDelegate:self];
        [[MKStoreManager sharedManager] buyFeature:self.product];
        
        [self showHUDwithTitle:@"Loading ...."];
        NSLog(@"Product: %@", self.product);
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"You must acept for term." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void)showHUDwithTitle: (NSString*)title
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = title;
    [HUD show:YES];

}

-(void)sendMailToSupport
{
    //[self hudWasHidden:HUD];
    if ([MFMailComposeViewController canSendMail])
    {
        [self presentModalViewController:mailer animated:YES];
        //Send email programingly
        /*
        UIBarButtonItem *sendBtn = mailer.navigationBar.topItem.rightBarButtonItem;
        id targ = sendBtn.target;
        [targ performSelector:sendBtn.action withObject:sendBtn];
        [sendBtn release];
        sendBtn = nil;
         */
    }
    else
    {
        //[self hudWasHidden:HUD];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}


-(void)alertCancel
{
    //[self hudWasHidden:HUD];
    if(conditionAlert == nil)
    {
        conditionAlert = [[UIAlertView alloc] initWithTitle:@"Notice!" message:@"You must sent email to finish buying a canvas." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        conditionAlert.delegate = self;
    }
    [conditionAlert show];
    NSLog(@"Cancel");
}
-(void)alertSaved
{
    //[self hudWasHidden:HUD];
     if(conditionAlert == nil)
     {
         conditionAlert = [[UIAlertView alloc] initWithTitle:@"Notice!" message:@"You must sent email to finish buying a canvas." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         conditionAlert.delegate = self;
     }
    [conditionAlert show];
    NSLog(@"Saved");
}
-(void)alertSent
{
    [self hudWasHidden:HUD];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Successful!" message:@"You have bought a canvas successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.delegate = self;
    [alert show];
    [alert release]; 
    NSLog(@"OK");
}

#pragma mark
#pragma UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView != conditionAlert)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self presentModalViewController:mailer animated:YES];
    }
}


-(void)alertFailed
{
    [self hudWasHidden:HUD];
    NSLog(@"Failed");
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



#pragma IPA delegate
-(void)productFetchComplete
{
    NSLog(@"ProductFetchComplete");
}

-(void)transactionCanceled
{
    [self hudWasHidden:HUD];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:@"Buy canvas faile." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    NSLog(@"Cancel");
}

-(void)productPurchased:(NSString *)productId
{
    NSLog(@"OKMEN");
    //[self showHUDwithTitle:@"Sending email\nto request ...."];
    [self sendMailToSupport];
    
}

-(IBAction)checkAccept:(id)sender
{
    
}

#pragma Touch in Check box

-(void) touchCheck
{
    self.accept = !(self.accept);
    if(accept)
    {
        //display tick
        self.acceptView.image = [UIImage imageNamed:@"checked"];
        [self.acceptView setContentMode:UIViewContentModeScaleAspectFit];
    }else
    {
        self.acceptView.image = nil;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //if touch in check box
    CGPoint activePoint = [[touches anyObject] locationInView:self.view];
    
    CGRect frameCheckBox = [self.acceptView frame];
    
    if(((activePoint.x > frameCheckBox.origin.x)
        &&(activePoint.x < frameCheckBox.origin.x + frameCheckBox.size.width)
        &&(activePoint.y > frameCheckBox.origin.y)
        &&(activePoint.y < frameCheckBox.origin.y + frameCheckBox.size.height)))
    {
        [self performSelector:@selector(touchCheck)];
    }
}

#pragma --
#pragma HUD delegate
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    [hud release];
    hud = nil;
}



@end
