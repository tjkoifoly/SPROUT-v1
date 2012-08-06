//
//  ConfirmPurchaseViewController.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/3/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "ConfirmPurchaseViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ConfirmPurchaseViewController

@synthesize accept;
@synthesize acceptView;

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

    self.acceptView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.acceptView.layer.borderWidth = 1.f;
    
    accept = YES;
    [self touchCheck];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    self.acceptView = nil;
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

-(IBAction)confirmPurchase:(id)sender
{
    
}

-(IBAction)checkAccept:(id)sender
{
    
}

#pragma Touch in Check box

-(void) touchCheck
{
    self.accept = !(self.accept);
    if(accept)
    {
        //display tick
        self.acceptView.image = [UIImage imageNamed:@"checked"];
        [self.acceptView setContentMode:UIViewContentModeScaleAspectFit];
    }else
    {
        self.acceptView.image = nil;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //if touch in check box
    CGPoint activePoint = [[touches anyObject] locationInView:self.view];
    
    CGRect frameCheckBox = [self.acceptView frame];
    
    if(((activePoint.x > frameCheckBox.origin.x)
        &&(activePoint.x < frameCheckBox.origin.x + frameCheckBox.size.width)
        &&(activePoint.y > frameCheckBox.origin.y)
        &&(activePoint.y < frameCheckBox.origin.y + frameCheckBox.size.height)))
    {
        [self performSelector:@selector(touchCheck)];
    }
}




@end
