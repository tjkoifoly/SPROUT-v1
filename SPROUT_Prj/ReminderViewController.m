//
//  ReminderViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ReminderViewController.h"

@implementation ReminderViewController

@synthesize datePicker;
@synthesize alertLocation;
@synthesize alertDescription;
@synthesize alertSegmentControl;
@synthesize durationSegmentControl;
@synthesize alertTime;
@synthesize duration;

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
    self.duration = 0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.datePicker = nil;
    self.alertLocation = nil;
    self.alertDescription = nil;
    self.alertSegmentControl = nil;
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
                duration = 0;
                break;
            case 1:
                duration = 15;
                break;
            case 2:
                duration = 30;
                break;
            case 3:
                duration = 60;
                break;
            case 4:
                duration = 61;
                break;
                
            default:
                break;
        }
        
        if(duration < 60)
            NSLog(@"Duration changed to %i min", duration);
        else
            NSLog(@"Duration changed to allDay");
    }
    
}

-(IBAction)addNotification:(id)sender
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:[NSDate dateWithTimeIntervalSinceNow:[datePicker countDownDuration]]];
    
    [localNotification setAlertAction:@"Launch"];
    [localNotification setAlertBody:[NSString stringWithFormat:@"%@ - Loaction: %@",[alertDescription text], [alertLocation text]]];
    [localNotification setHasAction:YES];
    [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber] +1 ];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSLog(@"Added a reminder succeed.");
}

-(IBAction)dissmissKeyboard:(id)sender
{
    [self resignFirstResponder];
}






@end
