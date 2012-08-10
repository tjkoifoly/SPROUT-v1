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
    listSprout = [Sprout loadAllSprout];
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

-(void) buttonPressed :(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    
    switch (tag) {
        case 0:
            NSLog(@"%i", tag);
            break;
        case 1:
            NSLog(@"%i", tag);
            break;
        case 2:
            NSLog(@"%i", tag);
            break;
        case 3:
            NSLog(@"%i", tag);
            break;

        case 4:
            NSLog(@"%i", tag);
            break;
            
        case 5:
            NSLog(@"%i", tag);
            break;
            
        default:
            break;
    }
    
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
