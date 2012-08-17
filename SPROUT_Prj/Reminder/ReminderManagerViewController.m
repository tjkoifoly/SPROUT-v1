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
@synthesize editButton;

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

-(IBAction)deleteAll:(id)sender
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self reloadTable];
}

-(void) reloadTable
{
    self.listNotifications = [NSMutableArray arrayWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]] ;
    [table reloadData];
}

-(IBAction)toggleEdit:(id)sender
{
    [self.table setEditing:!self.table.editing animated:YES];
    if (self.table.editing) 
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    else
        [self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
}

-(void)backtoPreviousView
{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listNotifications = [NSMutableArray arrayWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]] ;
    
    self.navigationController.navigationBarHidden = NO;
    //Back Button
    UIButton *backButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0,-5,60,30);
    [backButton addTarget:self action:@selector(backtoPreviousView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton =YES;
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEdit:)];
    
    if(listNotifications.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"You have no reminder." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.table          = nil;
    self.listNotifications = nil;
    self.editButton     = nil;
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

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILocalNotification *notifcation = [self.listNotifications objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] cancelLocalNotification:notifcation];
    [self.listNotifications removeObjectAtIndex:indexPath.row];
    //[self reloadTable];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
