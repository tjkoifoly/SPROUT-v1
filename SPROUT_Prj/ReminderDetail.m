//
//  ReminderDetail.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/21/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ReminderDetail.h"
#import <QuartzCore/QuartzCore.h>

@implementation ReminderDetail

@synthesize txtDesc;
@synthesize txtLocation;
@synthesize txtStartTime;
@synthesize txtDuration;
@synthesize txtNextTime;
@synthesize remind;
@synthesize notification;
@synthesize icon;

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
    self.navigationItem.title = @"Reminder Detail";
    txtDesc.layer.borderWidth = 1.0f;
    txtDesc.layer.borderColor = [UIColor grayColor].CGColor;
    txtDesc.layer.cornerRadius = 8;
    txtDesc.clipsToBounds = YES;
    
    txtDesc.text = @"Description";
    
    txtLocation.layer.borderWidth = 1.0f;
    txtLocation.layer.borderColor = [UIColor grayColor].CGColor;
    txtLocation.layer.cornerRadius = 8;
    txtLocation.clipsToBounds = YES;
    
    txtLocation.text = @"Location";
    
    txtDuration.layer.borderWidth = 1.0f;
    txtDuration.layer.borderColor = [UIColor grayColor].CGColor;
    txtDuration.layer.cornerRadius = 8;
    txtDuration.clipsToBounds = YES;
    
    txtStartTime.layer.borderWidth = 1.0f;
    txtStartTime.layer.borderColor = [UIColor grayColor].CGColor;
    txtStartTime.layer.cornerRadius = 8;
    txtStartTime.clipsToBounds = YES;
    
    txtNextTime.layer.borderWidth = 1.0f;
    txtNextTime.layer.borderColor = [UIColor grayColor].CGColor;
    txtNextTime.layer.cornerRadius = 8;
    txtNextTime.clipsToBounds = YES;
    
    txtDesc.text = [self.remind valueForKey:@"discription"];
    txtLocation.text = [self.remind valueForKey:@"location"];
    txtDuration.text = [self.remind valueForKey:@"duration"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    NSString *date = [dateFormatter stringFromDate:[self.remind valueForKey:@"startTime"]];
    txtStartTime.text = date;
    
    txtNextTime.text = notification;
    if([notification isEqualToString:@"Finished"]){
        self.icon.image = [UIImage imageNamed:@"alrm4"];
        txtNextTime.textColor = [UIColor redColor];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.txtLocation    = nil;
    self.txtDesc        = nil;
    self.txtDuration    = nil;
    self.txtNextTime    = nil;
    self.txtStartTime   = nil;
    self.remind         = nil;
    self.notification   = nil;
    self.icon           = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
