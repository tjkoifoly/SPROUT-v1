//
//  PurcharseCanvasViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "PurcharseCanvasViewController.h"
#import "ConfirmPurchaseViewController.h"

@implementation PurcharseCanvasViewController

@synthesize delegate;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.delegate = nil;
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

-(IBAction)chooseCanvas:(id)sender
{
    ConfirmPurchaseViewController *confirmViewController = [[ConfirmPurchaseViewController alloc] initWithNibName:@"ConfirmPurchaseViewController" bundle:nil];
    
    
    
    UIButton *buttonCanvas = (UIButton*)sender;
    NSInteger tagCanvas = [buttonCanvas tag];
    NSString *productName;
    switch (tagCanvas) {
        case 1:
            productName = @"Item_0";
            break;
        case 2:
            productName = @"Item_1";
            break;
        case 3:
            productName = @"Item_2";
            break;
        case 4:
            productName = @"Item_3";
            break;
        default:
            break;
    }
    confirmViewController.product = productName;
    self.delegate = [[self.navigationController viewControllers] objectAtIndex:0];
    [self.delegate gotoConfirm:self toView:confirmViewController];
    
    //[self.navigationController pushViewController:confirmViewController animated:YES];
}





@end
