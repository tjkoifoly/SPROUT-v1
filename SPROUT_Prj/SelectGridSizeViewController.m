//
//  SelectGridSizeViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "SelectGridSizeViewController.h"
#import "CreateSproutViewController.h"

@implementation SelectGridSizeViewController

@synthesize rowPicker;
@synthesize colPicker;
@synthesize rowPickerData;
@synthesize colPickerData;

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
    
    NSArray *a1 = [[NSArray alloc] initWithObjects:@"6",@"7",@"8",@"9",@"10", @"11",@"12", nil];
    self.rowPickerData = a1;
    
     
    NSArray *a2 = [[NSArray alloc] initWithObjects:@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    self.colPickerData = a2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.rowPicker = nil;
    self.colPicker = nil;
    self.rowPickerData = nil;
    self.colPickerData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Picker delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == rowPicker)
    {
        return [rowPickerData count];
    }else if(pickerView == colPicker)
    {
        return [colPickerData count];
    }
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView == rowPicker)
    {
        return [rowPickerData objectAtIndex:row];
    }else if(pickerView == colPicker)
    {
        return [colPickerData objectAtIndex:row];
    }
    return nil;
}


#pragma IBAction

-(IBAction)create:(id)sender
{
    NSInteger rowSprout = [self.rowPicker selectedRowInComponent:0];
    
     NSInteger colSprout = [self.colPicker selectedRowInComponent:0];
    NSInteger rowValue = [[rowPickerData objectAtIndex:rowSprout] intValue];
    NSInteger colValue = [[colPickerData objectAtIndex:colSprout] intValue];
    
    NSLog(@"Size = %i X %i", rowValue, colValue);
    
    CreateSproutViewController *createSproutViewController = [[CreateSproutViewController alloc] initWithNibName:@"CreateSproutViewController" bundle:nil];
    
    [self.navigationController pushViewController:createSproutViewController animated:YES];
}

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
