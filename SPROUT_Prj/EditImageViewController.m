//
//  EditImageViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "EditImageViewController.h"
#import "ExportSproutViewController.h"
#import "StyleColorView.h"

@implementation EditImageViewController

@synthesize imageToEdit;
@synthesize frameForEdit;
@synthesize areForEdit;
@synthesize frontViewChangeColor;

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
    
    //self.areForEdit.backgroundColor = [UIColor colorWithPatternImage:self.imageToEdit];
    //self.frameForEdit.alpha = 0.0f;
    //self.frameForEdit.backgroundColor = [UIColor clearColor];
    self.frameForEdit.image = self.imageToEdit;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageToEdit = nil;
    self.frameForEdit = nil;
    self.areForEdit = nil;
    self.frontViewChangeColor = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma IBAction

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)save:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)exportImage:(id)sender
{
    ExportSproutViewController *exportSproutViewController = [[ExportSproutViewController alloc] initWithNibName:@"ExportSproutViewController" bundle:nil];
    
    [self.navigationController pushViewController:exportSproutViewController animated:YES];
}

-(IBAction)changeColor:(id)sender
{
    StyleColorView *styleView;
    NSArray *nibObjects;
    nibObjects = [[NSBundle mainBundle]loadNibNamed:@"StyleColorView" owner:self options:nil];
    
    for(id currentObject in nibObjects)
    {
        styleView = (StyleColorView *)currentObject;
    }
    
    styleView.backgroundColor = [UIColor clearColor];
    styleView.delegate = self;
    [styleView loadViewController];
    [self.view addSubview:styleView];
}

-(IBAction)cropImage:(id)sender
{
    
}

-(IBAction)changeEffect:(id)sender
{
    
}

-(IBAction)rotateImage:(id)sender
{
    
}

-(void)changeColor:(StyleColorView *)view valueRed:(CGFloat)red valueGreen:(CGFloat)green valueBlue:(CGFloat)blue
{
    NSLog(@"Red: %f Green : %f Blue: %f", red, green, blue);
    self.frontViewChangeColor.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
}


@end
