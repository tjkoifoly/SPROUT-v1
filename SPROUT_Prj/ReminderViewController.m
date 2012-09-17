//
//  ReminderViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ReminderViewController.h"
#import "ReminderManagerViewController.h"
#import "Sprout.h"
#import "TakePhotoViewController.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import "TellAboutController.h"

@implementation ReminderViewController
{
    NSCalendarUnit unit;
    SKPSMTPMessage *testMsg;
}

@synthesize datePicker;
@synthesize alertLocation;
@synthesize alertDescription;
@synthesize alertSegmentControl;
@synthesize durationSegmentControl;
@synthesize alertTime;

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
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    self.alertTime = 0;
    unit = 0;
    //[self performSelector:@selector(customizeSegmentControl)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhoto)
                                                 name:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication]];
    
}

-(void)takePhoto
{
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    //NSArray *notificationsArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //NSLog(@"%@", notificationsArray );
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.datePicker             = nil;
    self.alertLocation          = nil;
    self.alertDescription       = nil;
    self.alertSegmentControl    = nil;
    self.durationSegmentControl = nil;
    testMsg                     = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBAction
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addReminder:(id)sender
{
    
}

-(IBAction)showListReminder:(id)sender
{
    //NSLog(@"DCM MMM");
    
    ReminderManagerViewController *reminderManager = [[ReminderManagerViewController alloc] initWithNibName:@"ReminderManagerViewController" bundle:nil];
    
    [self.navigationController pushViewController:reminderManager animated:YES];
}

-(IBAction)selectAlertInfo:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;

    NSInteger index = [segment selectedSegmentIndex];
    
    if (segment == self.alertSegmentControl) {
                
        switch (index) {
            case 0:
                alertTime = 0;
                break;
            case 1:
                alertTime = 15;
                break;
            case 2 :
                alertTime = 60;
                break;
            case 3:
                alertTime = 120;
                break;
            case 4:
                alertTime = 360;
                break;
                
            default:
                break;
        }
        NSLog(@"Alert Time changed to %i min", alertTime);

        
    }else if(segment == self.durationSegmentControl)
    {
        switch (index) {
            case 0:
                unit = 0;
                
                break;
            case 1:
                unit = NSHourCalendarUnit;
                break;
            case 2:
                unit = NSDayCalendarUnit;
                break;
            case 3:
                unit = NSWeekCalendarUnit;
                break;
            default:
                break;
        }
    }
    
}

-(IBAction)addNotification:(id)sender
{
    NSString *desc = alertDescription.text;
    
    if([desc isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"You should enter a description." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([Sprout checkReminder:desc] == YES)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"A reminder with description is really exists. You should enter other description." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString *duration  = [self.durationSegmentControl titleForSegmentAtIndex:[self.durationSegmentControl selectedSegmentIndex]];
    
    //NSDate *date = [NSDate dateWithTimeInterval:60.0*self.alertTime sinceDate:[datePicker date]];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    [Sprout  createReminder:desc: alertLocation.text :date :duration];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    //[localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:[datePicker countDownDuration]]];
     NSString *location = @"";
    if(![alertLocation.text isEqualToString:@""])
    {
       location = [NSString stringWithFormat:@" at location: %@", alertLocation.text];
    }
    [localNotification setFireDate:[NSDate dateWithTimeInterval:60.0*self.alertTime sinceDate:[datePicker date]]];
    [localNotification setAlertAction:@"Launch"];
    [localNotification setAlertBody:[NSString stringWithFormat:@"%@%@",desc, location]];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"SPROUT",@"APP",desc, @"DESC", nil];
    [localNotification setUserInfo:dict];
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [localNotification setHasAction:YES];
    localNotification.repeatInterval = unit;
    
    [localNotification setApplicationIconBadgeNumber:1];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Added a reminder succeed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    NSLog(@"Added a reminder succeed.");
}

-(IBAction)dissmissKeyboard:(id)sender
{
    [self resignFirstResponder];
}

-(IBAction)tellAboutApp:(id)sender
{
    NSLog(@"Tell");
    /*
    testMsg = [[SKPSMTPMessage alloc] init];
    testMsg.fromEmail = @"foly.v1.8.01@gmail.com";
    testMsg.toEmail = @"congnguyen@cnc.com.vn";
    testMsg.relayHost = @"smtp.gmail.com";
    
    testMsg.requiresAuth = YES;
    
    if (testMsg.requiresAuth) {
        testMsg.login = @"foly.v1.8.01@gmail.com";
        testMsg.pass = @"98752368";
    }
    
    testMsg.wantsSecure = YES;
    
    testMsg.subject = @"Tell about app";
    testMsg.delegate = self;
    
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               @"This is a tést messåge.",kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    NSString *vcfPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSData *vcfData = [NSData dataWithContentsOfFile:vcfPath];
    
    NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.jpg\"",kSKPSMTPPartContentTypeKey,
                             @"attachment;\r\n\tfilename=\"test.jpg\"",kSKPSMTPPartContentDispositionKey,[vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    testMsg.parts = [NSArray arrayWithObjects:plainPart,vcfPart,nil];
    
    [testMsg send];
 
    */
    TellAboutController *tellAboutController = [[TellAboutController alloc] initWithNibName:@"TellAboutController" bundle:nil];
    
    [self.navigationController pushViewController:tellAboutController animated:YES];
}

#pragma mark
#pragma SMTP Delegate

- (void)messageSent:(SKPSMTPMessage *)message
{
    NSLog(@"Yay! Message was sent!");
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    NSLog(@"%@",[NSString stringWithFormat:@"Darn! Error!\n%i: %@\n%@", [error code], [error localizedDescription], [error localizedRecoverySuggestion]]);
}

#pragma mark - custom UI

-(void)customizeSegmentControl
{
    UIImage *segmentSelected = 
    [[UIImage imageNamed:@"segment-sel.png"] 
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentUnselected = 
    [[UIImage imageNamed:@"segment-uns.png"] 
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    UIImage *segmentSelectedUnselected = 
    [UIImage imageNamed:@"seg-sel-uns.png"];
    UIImage *segUnselectedSelected = 
    [UIImage imageNamed:@"seg-uns-sel.png"];
    UIImage *segmentUnselectedUnselected = 
    [UIImage imageNamed:@"seg-uns-uns.png"];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected 
                                               forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected 
                                               forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected 
                                 forLeftSegmentState:UIControlStateNormal 
                                   rightSegmentState:UIControlStateNormal 
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected 
                                 forLeftSegmentState:UIControlStateSelected 
                                   rightSegmentState:UIControlStateNormal 
                                          barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] 
     setDividerImage:segUnselectedSelected 
     forLeftSegmentState:UIControlStateNormal 
     rightSegmentState:UIControlStateSelected 
     barMetrics:UIBarMetricsDefault];
}



@end
