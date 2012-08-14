//
//  SendEmailViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "SendEmailViewController.h"

@implementation SendEmailViewController

@synthesize imageToSend;

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
    //Check device can send mail
   
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageToSend        = nil;
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

-(IBAction)send:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        mailer.navigationItem.rightBarButtonItem.title = @"OK";
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Your sprout to send"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:nil];
        [mailer setToRecipients:toRecipients];
        
        UIImage *myImage = self.imageToSend;
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"MyCoolSprout"];
        
        NSString *emailBody = @"Comment ........";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:mailer animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Your device doesn't support the composer sheet" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
}

-(IBAction)resignKeyboard:(id)sender
{
    [self resignFirstResponder];
}




@end
