//
//  ReminderManagerViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/17/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ReminderManagerViewController.h"

@implementation ReminderManagerViewController

@synthesize table;
@synthesize listNotifications;

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

-(IBAction)backPrevious:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)deleteAll:(id)sender
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    self.listNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    [table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.table          = nil;
    self.listNotifications = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listNotifications count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UILocalNotification *notifcation = [self.listNotifications objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [notifcation alertBody];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    [[cell detailTextLabel] setText:[dateFormatter stringFromDate:notifcation.fireDate]];
    
    return cell;
}

@end
