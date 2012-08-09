//
//  SelectGridSizeViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "SelectGridSizeViewController.h"
#import "CreateSproutViewController.h"
#import "SproutScrollView.h"
#import "Sprout.h"

@implementation SelectGridSizeViewController
{
    double moveOrigin;
}

@synthesize rowPicker;
@synthesize colPicker;
@synthesize rowPickerData;
@synthesize colPickerData;
@synthesize nameField;
@synthesize sproutName;
@synthesize stayup;

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
    
    NSArray *a1 = [[NSArray alloc] initWithObjects:@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", @"11",@"12", @"13",@"14",@"15",nil];
    self.rowPickerData = a1;
    
     
    NSArray *a2 = [[NSArray alloc] initWithObjects:@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", @"11",@"12", @"13",@"14",@"15", nil];
    self.colPickerData = a2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.rowPicker = nil;
    self.colPicker = nil;
    self.rowPickerData = nil;
    self.colPickerData = nil;
    self.nameField = nil;
    self.sproutName = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.nameField.text = @"";
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
    if ([self.nameField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"WARNING:"
                              message: @"Please enter sprout name!"
                              delegate: nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil];
        [alert show];
        
        
        
        return;
    }else if([Sprout anySproutForName:self.nameField.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WARNING" message:@"Sprout with this name readly exist\nYou can use it" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];

        return;
    }

    
    NSInteger rowSprout = [self.rowPicker selectedRowInComponent:0];
    
     NSInteger colSprout = [self.colPicker selectedRowInComponent:0];
    NSInteger rowValue = [[rowPickerData objectAtIndex:rowSprout] intValue];
    NSInteger colValue = [[colPickerData objectAtIndex:colSprout] intValue];
    
    NSLog(@"Size = %i X %i", rowValue, colValue);
    
    CreateSproutViewController *createSproutViewController = [[CreateSproutViewController alloc] initWithNibName:@"CreateSproutViewController" bundle:nil];
    
    SproutScrollView *s = [[SproutScrollView alloc] initWithrowSize:rowValue andColSize:colValue];
    s.name = self.sproutName;
    createSproutViewController.sprout = s;
    
    [self.navigationController pushViewController:createSproutViewController animated:YES];
}

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)resignKeyboard:(id)sender
{
    [self resignFirstResponder];
}

-(void)setViewMoveUp: (BOOL) moveUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect rect = self.view.frame;
    if(moveUp)
    {
        if(stayup)
        {
            rect.origin.y -= moveOrigin;
        }
    }else
    {
        if(stayup == NO)
        {
            rect.origin.y += moveOrigin;
        }
    }
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    stayup = YES;
    moveOrigin = textField.frame.origin.y - 6*textField.frame.size.height;
    
    [self setViewMoveUp:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.sproutName = textField.text;
    stayup = NO;
    [self setViewMoveUp:NO];
    [textField resignFirstResponder];
}





@end
