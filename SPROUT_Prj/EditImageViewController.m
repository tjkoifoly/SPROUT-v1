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
#import "FiltersView.h"

#define DEG2RAD (M_PI/180.0f)
#define kFile @"FOLY.png"

@implementation EditImageViewController
{
    BOOL change;
    BOOL cropChange;
    BOOL rotChange;
    BOOL colorChange;
    BOOL filterChange;
    
    NSInteger rotate;
    CIContext *context;
    CIFilter *filter;
    CIImage *beginImage;
}


@synthesize imageToEdit;
@synthesize frameForEdit;
@synthesize areForEdit;
@synthesize delegate;
@synthesize preoviousImage;
@synthesize urlOfImage;

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
    self.frameForEdit.image = self.imageToEdit;
    NSLog(@"Orientation = %@", self.imageToEdit.imageOrientation);
    change          = NO;
    rotChange       = NO;
    cropChange      = NO;
    colorChange     = NO;
    filterChange    = NO;
    rotate          = 0; 

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageToEdit            = nil;
    self.frameForEdit           = nil;
    self.areForEdit             = nil;
    self.delegate               = nil;
    self.preoviousImage         = nil;
    self.urlOfImage             = nil;
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
    if(rotChange || colorChange || filterChange || cropChange)
    {
        change = YES;
    }
    
    if(change)
    {
        UIImage *img = [self.areForEdit saveImage];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        __block NSString *urlString;
        
        [library writeImageToSavedPhotosAlbum:img.CGImage orientation:(ALAssetOrientation)img.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             urlString = [assetURL absoluteString];
             self.urlOfImage = urlString;
             
             [self.delegate saveImage:self withImage:img andURL:urlOfImage];
             
             [self.navigationController popViewControllerAnimated:YES];
             
             [library assetForURL:assetURL resultBlock:^(ALAsset *asset )
              {
                  NSLog(@"we have our ALAsset!");
              } 
                     failureBlock:^(NSError *error )
              {
                  NSLog(@"Error loading asset");
              }];
         }];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(IBAction)exportImage:(id)sender
{
    ExportSproutViewController *exportSproutViewController = [[ExportSproutViewController alloc] initWithNibName:@"ExportSproutViewController" bundle:nil];
    
    [self.navigationController pushViewController:exportSproutViewController animated:YES];
}

-(NSString *)dataPathFile
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    
    NSLog(@"%@", documentDirectory);
    
    return [documentDirectory stringByAppendingPathComponent:kFile];
}

-(IBAction)changeColor:(id)sender
{
    /*
    //Save image to file get path
    NSString *path = [self dataPathFile];
    
    NSLog(@"Saved");
    UIImage *img = [self.areForEdit saveImage];
    [UIImagePNGRepresentation(img) writeToFile:path atomically:YES];
    */
    preoviousImage = [self.areForEdit saveImage];
    
    StyleColorView *styleView;
    NSArray *nibObjects;
    nibObjects = [[NSBundle mainBundle]loadNibNamed:@"StyleColorView" owner:self options:nil];
    
    for(id currentObject in nibObjects)
    {
        styleView = (StyleColorView *)currentObject;
    }
    
    //styleView.backgroundColor = [UIColor clearColor];
    styleView.frame = CGRectMake(0.0f, 360.f, 320.f, 100.f);
    styleView.delegate = self;
    [styleView loadViewController];
    [self.view addSubview:styleView];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:
                           preoviousImage];
    
    filter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey,inputImage, @"inputAngle", [NSNumber numberWithFloat:0.0], nil];
    
    context = [CIContext contextWithOptions:nil];
}

-(IBAction)cropImage:(id)sender
{
    preoviousImage = [self.areForEdit saveImage];
    [self.areForEdit createAreaToCrop];
    StyleCropView *styleView;
    NSArray *nibObjects;
    nibObjects = [[NSBundle mainBundle]loadNibNamed:@"StyleCropView" owner:self options:nil];
    
    for(id currentObject in nibObjects)
    {
        styleView = (StyleCropView *)currentObject;
    }
    
    styleView.frame = CGRectMake(0.0f, 380.f, 320.f, 80.f);
    styleView.delegate = self;
    [self.view addSubview:styleView];

}

-(IBAction)changeEffect:(id)sender
{
    
    
    FiltersView *filterView;
    NSArray *nibObjects;
    nibObjects = [[NSBundle mainBundle] loadNibNamed:@"FiltersView" owner:self options:nil];
    filterView = (FiltersView *)[nibObjects objectAtIndex:0];
    
    filterView.frame = CGRectMake(0.0f, 380.f, 320.f, 80.f);
    filterView.delegate = self;
    [self.view addSubview:filterView];
}

#pragma Filter delegate
-(void)closeFilter:(FiltersView *)view
{
    [view removeFromSuperview];
    filter = nil;
    context = nil;
}

-(void)filterApply:(FiltersView *)view typeFilter:(NSInteger)type
{
    preoviousImage = [self.areForEdit saveImage];
    switch (type) {
        case 1:
            NSLog(@"NORMAL");
            self.frameForEdit.image = preoviousImage;
            break;
        case 2:
        {
            CIImage *inputImage = [[CIImage alloc] initWithImage:
                                   preoviousImage];
            filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,inputImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
            context = [CIContext contextWithOptions:nil];
            CIImage *outputImage = [filter outputImage];
            
            CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
            UIImage *newImg = [UIImage imageWithCGImage:cgimg];
            self.frameForEdit.image = newImg;
            CGImageRelease(cgimg);
        }
            break;
        case 3:
            break;
        case 4:
        {
            /*
            CIImage *inputImage = [[CIImage alloc] initWithImage:
                                   preoviousImage];
            filter = [CIFilter filterWithName:@"CIBoxBlur" keysAndValues:kCIInputImageKey,inputImage, nil];
            [filter setDefaults];
            [filter setValue:[NSNumber numberWithFloat:50.] forKey:@"inputRadius"];
            context = [CIContext contextWithOptions:nil];
            CIImage *outputImage = [filter outputImage];
            
            CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
            UIImage *newImg = [UIImage imageWithCGImage:cgimg];
            self.frameForEdit.image = newImg;
            CGImageRelease(cgimg);
             */
             
        }
            break;
        case 5:
        {
            CIImage *inputImage = [[CIImage alloc] initWithImage:
                                   preoviousImage];
            filter = [CIFilter filterWithName:@"CIVignette" keysAndValues:kCIInputImageKey,inputImage, nil];
            [filter setDefaults];
            [filter setValue:[NSNumber numberWithFloat:5.] forKey:@"inputIntensity"];
            context = [CIContext contextWithOptions:nil];
            CIImage *outputImage = [filter outputImage];
            
            CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
            UIImage *newImg = [UIImage imageWithCGImage:cgimg];
            self.frameForEdit.image = newImg;
            CGImageRelease(cgimg);
        }
            break;
        default:
            break;
    }
}

#pragma CROPCONTROL delegate
-(IBAction)rotateImage:(id)sender
{
    rotate = 90;
    rotChange = YES;
    
     UIImageView *imgRotate = [[UIImageView alloc]  initWithFrame:self.frameForEdit.frame];
    imgRotate.image = [self.areForEdit saveImage];
    [self.areForEdit addSubview:imgRotate];
    imgRotate.transform = CGAffineTransformMakeRotation(rotate/180.f *M_PI);
    
    self.frameForEdit.image = [self.areForEdit saveImage];
    [imgRotate removeFromSuperview];
}

-(void)closeFrame:(StyleCropView *)view
{
    [view removeFromSuperview];
    [self.areForEdit removeAreaToCropFromView];
}

-(void)cropImageInFrame:(StyleCropView *)view
{
    UIImage *imageCropped = [self.areForEdit cropImage];
    self.frameForEdit.image = imageCropped;
    cropChange = YES;
}

-(void)resizeFrame:(StyleCropView *)view :(CGFloat)value
{
    [self.areForEdit resizeArea:value];
}

-(void)undoImage:(StyleCropView *)view
{
    self.frameForEdit.image = self.preoviousImage;
    cropChange = NO;
}

#pragma ChangeColor

-(void)changeSatuation:(StyleColorView *)view withValue:(CGFloat)valueS
{
    colorChange = YES;
    UIImage *i = [self situationChangetoValue:valueS withFilter:filter andContext:context ];
    self.frameForEdit.image = i;
}

-(void)changeHue:(StyleColorView *)view withValue:(CGFloat)valueH
{
    colorChange = YES;
    
    UIImage *i = [self hueChangetoValue:valueH withFilter:filter andContext:context];
    self.frameForEdit.image = i;
}

-(UIImage *)hueChangetoValue: (CGFloat)value withFilter: (CIFilter *)filterx andContext: (CIContext *)contextx
{
    // CIImage on which we apply effect
    //CIImage *inputImage = [[CIImage alloc] initWithImage:
      //                     imageInput];
    // CIFilter CIHueAdjust
    
    //[filterx setValue:inputImage forKey:@"inputImage"];
    [filterx setValue:[NSNumber numberWithFloat: value]
                 forKey:@"inputAngle"];
    // CIImage with effect
    CIImage *outputImage = [filterx outputImage];
    // define context
    
    CGImageRef cgimg = [contextx createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return newImg;
}

-(UIImage *)situationChangetoValue: (CGFloat)value withFilter: (CIFilter *)filterx andContext: (CIContext *)contextx
{
    [filterx setValue:[NSNumber numberWithFloat: value]
               forKey:@"inputSaturation"];
    CIImage *outputImage = [filterx outputImage];
    CGImageRef cgimg = [contextx createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return newImg;
}

-(void)closeStyle:(StyleColorView *)view
{
    [view removeFromSuperview];
    filter = nil;
    context = nil;
}

-(void)changeSystemColor:(StyleColorView *)view to:(NSInteger)indexColor
{
    switch (indexColor) {
        case 0:
        {
            NSLog(@"HUE");
            CIImage *inputImage = [[CIImage alloc] initWithImage:
                                   [self.areForEdit saveImage]];
            
            filter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey,inputImage, @"inputAngle", [NSNumber numberWithFloat:0.0], nil];
            
            context = [CIContext contextWithOptions:nil];
        }
            break;
        case 1:
        {
            NSLog(@"SITUATION");
            
             CIImage *inputImage = [[CIImage alloc] initWithImage:
             [self.areForEdit saveImage]];
             
            filter = [CIFilter filterWithName:@"CIColorControls"];
            [filter setValue:inputImage forKey:@"inputImage"];
            [filter setValue: [NSNumber numberWithFloat:1.0] forKey:@"inputSaturation"];
            [filter setValue: [NSNumber numberWithFloat:0.0] forKey:@"inputBrightness"];
            [filter setValue: [NSNumber numberWithFloat:1.0] forKey:@"inputContrast"];
             
             context = [CIContext contextWithOptions:nil];
             
        }
            break;
            
        default:
            break;
    }
}
@end
