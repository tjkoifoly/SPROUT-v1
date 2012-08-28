//
//  ReminderManagerViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/17/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ReminderManagerViewController.h"
#import "ReminderDetail.h"
#import "Sprout.h"

@implementation ReminderManagerViewController

@synthesize table;
@synthesize listNotifications;
@synthesize editButton;
@synthesize listReminders;

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
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listNotifications = [NSMutableArray arrayWithArray:[[UIApplication sharedApplication] scheduledLocalNotifications]];
    
    self.listReminders = [[NSMutableArray alloc] initWithArray: [Sprout getReminders]];
    
    self.navigationItem.title = @"Reminder";
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NOTICE" message:@"All reminder are really finished." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(UILocalNotification *)checkFinished: (NSString *)desc
{
    for(UILocalNotification *n in listNotifications)
    {
        //NSLog(@"%@",[n.userInfo valueForKey:@"DESC"]);
        
        if([[n.userInfo valueForKey:@"DESC"] isEqualToString:desc])
        {
            return n;
        }
    }
    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.table          = nil;
    self.listNotifications = nil;
    self.editButton     = nil;
    self.listReminders  = nil;
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
    return [listReminders count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        NSArray *nibObjects;
        nibObjects = [[NSBundle mainBundle]loadNibNamed:@"ReminderCell" owner:self options:nil];
        
        for(id currentObject in nibObjects)
        {
            cell = (ReminderCell *)currentObject;
        }
    }
    
    cell.desc.text = [[listReminders objectAtIndex:indexPath.row] valueForKey:@"discription"];
    UILocalNotification *noti = [self checkFinished:cell.desc.text];
    cell.notifi = noti;
    if(noti == nil)
    {
        cell.date.text = @"Finished";
        cell.icon.image = [UIImage imageNamed:@"arlm1"];
    }else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];
        [[cell date] setText:[dateFormatter stringFromDate:noti.fireDate]];
        cell.icon.image = [UIImage imageNamed:@"arlm2"];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UILocalNotification *notifcation = [self.listReminders objectAtIndex:indexPath.row];
    
     */
    NSManagedObject *remindObj = [self.listReminders objectAtIndex:indexPath.row];
    [self.listReminders removeObjectAtIndex:indexPath.row];
    [Sprout deleteObject:remindObj];
    
    UILocalNotification *n = [(ReminderCell *)[tableView cellForRowAtIndexPath:indexPath] notifi];
    if(n != nil)
    {
        [listNotifications removeObject:n];
        [[UIApplication sharedApplication] cancelLocalNotification:n];
    }

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"PASS");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ReminderDetail *reminderDetail = [[ReminderDetail alloc] initWithNibName:@"ReminderDetail" bundle:nil];
    reminderDetail.remind = [self.listReminders objectAtIndex:indexPath.row];
    reminderDetail.notification = [[(ReminderCell *)[tableView cellForRowAtIndexPath:indexPath] date] text];
    
    [self.navigationController pushViewController:reminderDetail animated:YES];
}

@end
