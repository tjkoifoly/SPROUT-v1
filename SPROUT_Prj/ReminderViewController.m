//
//  ReminderViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ReminderViewController.h"
#import "ReminderManagerViewController.h"

@implementation ReminderViewController
{
    NSCalendarUnit unit;
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
    
    self.alertTime = 0;
    unit = 0;
    
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
    if([alertDescription.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"You should enter a description." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    //[localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:[datePicker countDownDuration]]];
     NSString *location = @"";
    if(![alertLocation.text isEqualToString:@""])
    {
       location = [NSString stringWithFormat:@" at location: %@", alertLocation.text];
    }
    [localNotification setFireDate:[NSDate dateWithTimeInterval:60.0*self.alertTime sinceDate:[datePicker date]]];
    [localNotification setAlertAction:@"Launch"];
    [localNotification setAlertBody:[NSString stringWithFormat:@"%@%@",[alertDescription text], location]];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [localNotification setHasAction:YES];
    localNotification.repeatInterval = unit;
    
    [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] +1 ];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Added a reminder succeed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"Added a reminder succeed.");
}

-(IBAction)dissmissKeyboard:(id)sender
{
    [self resignFirstResponder];
}






@end
