//
//  UploadToSproutViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "UploadToSproutViewController.h"
#import "CellSproutCustomView.h"
#import "DragToSproutViewController.h"
#import "SelectGridSizeViewController.h"

@implementation UploadToSproutViewController

@synthesize listSprout;
@synthesize table;
@synthesize imageView ;
@synthesize imageInput;
@synthesize urlImage;

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
    //UPDATE Data:
    //NSMutableArray *allSprouts = [[NSMutableArray alloc] initWithArray:[Sprout loadAllSprout]];
    //self.listSprout = allSprouts;
    //UPDATE View
    [table setBackgroundColor:[UIColor clearColor]];
    table.separatorColor=[UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.imageView.image = imageInput;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSMutableArray *allSprouts = [[NSMutableArray alloc] initWithArray:[Sprout loadAllSprout]];
    self.listSprout = allSprouts;
    [table reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.listSprout = nil;
    self.table = nil;
    self.imageView = nil;
    self.imageInput = nil;
    self.urlImage = nil;
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
    
    [cell.sproutInfo addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.sproutInfo.tag = indexPath.row ;

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
    NSLog(@"%i", button.tag);
    
    DragToSproutViewController *dragToSproutController = [[DragToSproutViewController alloc] initWithNibName:@"DragToSproutViewController" bundle:nil];

    dragToSproutController.imageInput = self.imageInput;
    dragToSproutController.sprout = [self.listSprout objectAtIndex:button.tag];
    dragToSproutController.urlImage = self.urlImage;
    
    [self.navigationController pushViewController:dragToSproutController animated:YES];
}

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)createNewSprout:(id)sender
{
    SelectGridSizeViewController *newSrpoutController = [[SelectGridSizeViewController alloc] initWithNibName:@"SelectGridSizeViewController" bundle:nil];
    [self.navigationController pushViewController:newSrpoutController animated:YES];
}




@end
