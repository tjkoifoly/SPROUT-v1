//
//  ViewSproutViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ViewSproutViewController.h"
#import "CellSproutCustomView.h"
#import "SaveSproutViewController.h"
#import "CNCAppDelegate.h"
#import "Sprout.h"

@implementation ViewSproutViewController
{
    NSIndexPath *pathDelete;
}

@synthesize table;
@synthesize listSprout;

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
    //listSprout = [[NSArray alloc] initWithObjects:@"01/01/2012 - Hamish 0 to 6 months",@"23/03/2012 - Tomato plant",@"05/05/2012 - Changeing weither", @"12/7/2012 - Carton practice", nil]
    //UPDATE View
    [table setBackgroundColor:[UIColor clearColor]];
    table.separatorColor=[UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    listSprout = [[NSMutableArray alloc] initWithArray:[Sprout loadAllSprout]];
    [table reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.table = nil;
    self.listSprout = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma TableViewDelegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listSprout count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SproutCellIdentifier = @"SproutCellIdentifier";
    CellSproutCustomView *cell = [tableView dequeueReusableCellWithIdentifier:SproutCellIdentifier];
    
    if(cell == nil)
    {
        NSArray *nibObjects;
        nibObjects = [[NSBundle mainBundle]loadNibNamed:@"CellSproutCustomView" owner:self options:nil];
        
        for(id currentObject in nibObjects)
        {
            cell = (CellSproutCustomView *)currentObject;
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    cell.sproutInfoLabel.text = [[listSprout objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    cell.sproutInfo.tag = indexPath.row;
    
    [cell.sproutInfo addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //next to view
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    pathDelete = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"DELETE A SPROUT" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

-(void)deleteASproutInPath: (NSIndexPath*)indexPath
{
    id sproutObject = [listSprout objectAtIndex:indexPath.row];
    //Remove all temp image
    int size = [[sproutObject valueForKey:@"rowSize"] intValue]*[[sproutObject valueForKey:@"colSize"] intValue];
    int i;
    NSString *fileName = nil;
    NSString *sName = [sproutObject valueForKey:@"name"];
    NSFileManager *filemgr;
    
    filemgr = [NSFileManager defaultManager];
    for(i = 0; i< size; i++)
    {
        fileName = [NSString stringWithFormat:@"%@-atTag-%i",sName, i];
        if ([filemgr removeItemAtPath: [self dataPathFile:fileName] error: NULL]  == YES)
            NSLog (@"Remove successful");
    }
    //Remove image Object in sprout from database
    NSSet *imageSet = [sproutObject valueForKey:@"sproutToImages"];
    NSArray *imgArray = [imageSet allObjects];
    for(id imgObj in imgArray)
    {
        [Sprout deleteObject:imgObj];
    }
    
    //Remove sprout from database
    [listSprout removeObject:sproutObject];
    [Sprout deleteObject:sproutObject];
    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%i in Path : %@", buttonIndex, pathDelete);
    if(buttonIndex == 0)
        [self deleteASproutInPath:pathDelete];
    [self performSelector:@selector(reload) withObject:nil afterDelay:0.5f];
    
    pathDelete = nil;
}

-(void)reload
{
    [table reloadData];
}

-(NSString *)dataPathFile:(NSString *)fileName
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    
    NSLog(@"%@", documentDirectory);
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
}


-(void) buttonPressed :(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    
    SaveSproutViewController *displaySproutViewController = [[SaveSproutViewController alloc] initWithNibName:@"SaveSproutViewController" bundle:nil];
    id s = [self.listSprout objectAtIndex:tag];
    
    NSMutableArray *imgArray = [[NSMutableArray alloc]initWithArray:[Sprout imagesOfSrpout:s]];
    
    displaySproutViewController.imagesArray = imgArray;
    displaySproutViewController.sprout = s;
    
    [self.navigationController pushViewController:displaySproutViewController animated:YES];
}

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}





@end
