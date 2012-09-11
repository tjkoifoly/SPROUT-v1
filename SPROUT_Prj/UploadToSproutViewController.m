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
{
    NSIndexPath *pathDelete;
}

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
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    table.backgroundColor = [UIColor clearColor];
    
    self.imageView.image = imageInput;
    imageView.layer.borderWidth = 1.f;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
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
    
    pathDelete = nil;
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

-(NSString *)dataPathFile:(NSString *)fileName
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    
    NSLog(@"%@", documentDirectory);
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
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
    NSString *sName = [[sproutObject valueForKey:@"name"] stringByReplacingOccurrencesOfString:@"/" withString:@""];
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




@end
