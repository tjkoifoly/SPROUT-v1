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
#import "UIImage+Gaussian.h"
#import "UIImage+ImageColoring.h"
#import "UIImage+Contrast.h"

#define DEG2RAD (M_PI/180.0f)
#define kFile @"FOLY.png"

@interface EditImageViewController() {
    GPUImageVignetteFilter <GPUImageInput> *vignetteFilter;
    GPUImageSepiaFilter <GPUImageInput> *sepiaFilter;
    GPUImagePicture *stillImageSource;
}
@end

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
@synthesize editingIndicator;
@synthesize revertImage;

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

- (void)changeProcessImage: (int)type {
    UIImage *inputImage = preoviousImage;
    if (stillImageSource) {
        stillImageSource = nil;
    }
    stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    switch (type) {
        case 1:
            vignetteFilter = [[GPUImageVignetteFilter alloc] init];
            
            [stillImageSource addTarget:vignetteFilter];

            break;
        case 2:
            sepiaFilter = [[GPUImageSepiaFilter alloc] init];
            [stillImageSource addTarget:sepiaFilter];
            
        default:
            break;
    }
    }


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.frameForEdit.image = self.imageToEdit;
    //NSLog(@"Orientation = %@", self.imageToEdit.imageOrientation);
    change          = NO;
    rotChange       = NO;
    cropChange      = NO;
    colorChange     = NO;
    filterChange    = NO;
    rotate          = 0; 
    self.editingIndicator.hidden = YES;
    
    preoviousImage = imageToEdit;

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
    self.editingIndicator       = nil;
    filter                  = nil;
    context                 = nil;
    beginImage              = nil;
    self.revertImage        = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark IBAction

-(IBAction)revertNormal:(id)sender
{
    self.frameForEdit.image = self.imageToEdit;
    cropChange = NO;
    rotChange = NO;
    colorChange = NO;
    filterChange = NO;
    change = NO;
    
}

-(IBAction)goToHome:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    revertImage.hidden = YES;
    //Save image to file get path
    NSString *path = [self dataPathFile];
    NSLog(@"Saved");
    UIImage *img = [self.areForEdit saveImage];
    [UIImagePNGRepresentation(img) writeToFile:path atomically:YES];
    preoviousImage = [UIImage imageWithContentsOfFile:path];
    
    StyleColorView *styleView;
    NSArray *nibObjects;
    nibObjects = [[NSBundle mainBundle]loadNibNamed:@"StyleColorView" owner:self options:nil];
    
    for(id currentObject in nibObjects)
    {
        styleView = (StyleColorView *)currentObject;
    }
    
    //styleView.backgroundColor = [UIColor clearColor];
    styleView.frame = CGRectMake(0.0f, 375.f, 320.f, 85.f);
    styleView.delegate = self;
    [styleView loadViewController];
    [self.view addSubview:styleView];
    
    CIImage *inputImage = [[CIImage alloc] initWithImage:
                           preoviousImage];
    filter = [CIFilter filterWithName:@"CIHueAdjust"];
    [filter setDefaults];
    [filter setValue:inputImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:0.0] forKey:@"inputAngle"];
    
    context = [CIContext contextWithOptions:nil];
}

-(IBAction)cropImage:(id)sender
{
    revertImage.hidden = YES;
    preoviousImage = [self.areForEdit saveImage];
    [self.areForEdit createAreaToCrop];
    StyleCropView *styleView;
    NSArray *nibObjects;
    nibObjects = [[NSBundle mainBundle]loadNibNamed:@"StyleCropView" owner:self options:nil];
    
    for(id currentObject in nibObjects)
    {
        styleView = (StyleCropView *)currentObject;
    }
    
    styleView.frame = CGRectMake(0.0f, 375.f, 320.f, 85.f);
    styleView.delegate = self;
    [self.view addSubview:styleView];

}

-(UIImage *)getImageFromFile
{
    NSString *path = [self dataPathFile];
    
    NSLog(@"Saved");
    UIImage *img = [self.areForEdit saveImage];
    [UIImagePNGRepresentation(img) writeToFile:path atomically:YES];
     return [UIImage imageWithContentsOfFile:path];
}

-(IBAction)changeEffect:(id)sender
{
    revertImage.hidden = YES;
    preoviousImage = [self getImageFromFile];
    
    FiltersView *filterView;
    NSArray *nibObjects;
    nibObjects = [[NSBundle mainBundle] loadNibNamed:@"FiltersView" owner:self options:nil];
    filterView = (FiltersView *)[nibObjects objectAtIndex:0];
    
    filterView.frame = CGRectMake(0.0f, 375.f, 320.f, 85.f);
    filterView.delegate = self;
    [self.view addSubview:filterView];
}

#pragma Filter delegate
-(void)closeFilter:(FiltersView *)view
{
    [view removeFromSuperview];
    filter = nil;
    context = nil;
    self.revertImage.hidden = NO;
}

-(void)vignette: (UIImage*) im: (CGFloat)value
{
    [self.editingIndicator startAnimating];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        CIImage *inputImage = [[CIImage alloc] initWithImage:
                               im];
        filter = [CIFilter filterWithName:@"CIVignette"];
        [filter setDefaults];
        [filter setValue:inputImage forKey:@"inputImage"];
        [filter setValue:[NSNumber numberWithFloat:value] forKey:@"inputIntensity"];
        context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.frameForEdit.image = newImg;
            [self.editingIndicator stopAnimating];
            CGImageRelease(cgimg);
            filter = nil;
            context = nil;
        });
    });
    dispatch_release(queue);
}

-(void)sepia: (UIImage *)im:(CGFloat)value
{
    __block UIImage *newImg;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    [self.editingIndicator startAnimating];
    dispatch_async(queue, ^{
        CIImage *inputImage = [[CIImage alloc] initWithImage:
                               im];
        filter = [CIFilter filterWithName:@"CISepiaTone"];
        [filter setDefaults];
        [filter setValue:inputImage forKey:@"inputImage"];
        [filter setValue:[NSNumber numberWithFloat:value] forKey:@"inputIntensity"];
        context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        newImg = [UIImage imageWithCGImage:cgimg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.frameForEdit.image = newImg;
            [self.editingIndicator stopAnimating];
            CGImageRelease(cgimg);
            filter = nil;
            context = nil;
        });
    });
    dispatch_release(queue);
}

-(void)whitePoint: (UIImage *)im:(CIColor*)color
{
    __block UIImage *newImg;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    [self.editingIndicator startAnimating];
    dispatch_async(queue, ^{
        CIImage *inputImage = [[CIImage alloc] initWithImage:
                               im];
        filter = [CIFilter filterWithName:@"CIWhitePointAdjust"];
        [filter setValue:color forKey:@"inputColor"];
        [filter setValue:inputImage forKey:@"inputImage"];
        
        context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        newImg = [UIImage imageWithCGImage:cgimg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.frameForEdit.image = newImg;
            [self.editingIndicator stopAnimating];
            CGImageRelease(cgimg);
            filter = nil;
            context = nil;
        });
    });
    dispatch_release(queue);
    /*
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{});
    });
     */
}

-(void)satiation: (UIImage *)im: (CGFloat)satu:(CGFloat)brig:(CGFloat)constra
{
    __block UIImage *newImg;
    [self.editingIndicator startAnimating];
    dispatch_queue_t quque = dispatch_get_global_queue(0, 0);
    dispatch_async(quque, ^{
        CIImage *inputImage = [[CIImage alloc] initWithImage:
                               im];
        filter = [CIFilter filterWithName:@"CIColorControls"];
        [filter setValue:inputImage forKey:@"inputImage"];
        [filter setValue: [NSNumber numberWithFloat:satu] forKey:@"inputSaturation"];
        [filter setValue: [NSNumber numberWithFloat:brig] forKey:@"inputBrightness"];
        [filter setValue: [NSNumber numberWithFloat:constra] forKey:@"inputContrast"];
        context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        newImg = [UIImage imageWithCGImage:cgimg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.frameForEdit.image = newImg;
            [self.editingIndicator stopAnimating];
            CGImageRelease(cgimg);
            filter = nil;
            context = nil;
        });
    });
    dispatch_release(quque);
}

-(void)antiqueEffect: (UIImage *)im 
{
    [self.editingIndicator startAnimating];
    dispatch_queue_t quque = dispatch_get_global_queue(0, 0);
    dispatch_async(quque, ^{
        CIImage *inputImage = [[CIImage alloc] initWithImage:im];
        filter = [CIFilter filterWithName:@"CIColorControls"];
        [filter setValue:inputImage forKey:@"inputImage"];
        [filter setValue: [NSNumber numberWithFloat:0.95] forKey:@"inputSaturation"];
        [filter setValue: [NSNumber numberWithFloat:0.0] forKey:@"inputBrightness"];
        [filter setValue: [NSNumber numberWithFloat:0.98] forKey:@"inputContrast"];
        context = [CIContext contextWithOptions:nil];
        CIImage *outPutSatu = [filter outputImage];
        
        filter = [CIFilter filterWithName:@"CIWhitePointAdjust"];
        CIColor *color = [CIColor colorWithRed:124 green:121 blue:90 alpha:1.f];
        [filter setValue:color forKey:@"inputColor"];
        [filter setValue:outPutSatu forKey:@"inputImage"];
        CIImage *outPutWhitePoint = [filter outputImage];
        
        filter = [CIFilter filterWithName:@"CISepiaTone"];
        [filter setDefaults];
        [filter setValue:outPutWhitePoint forKey:@"inputImage"];
        [filter setValue:[NSNumber numberWithFloat:0.2] forKey:@"inputIntensity"];
        CIImage *outputSepia = [filter outputImage];
        
        filter = [CIFilter filterWithName:@"CIVignette"];
        [filter setDefaults];
        [filter setValue:outputSepia forKey:@"inputImage"];
        [filter setValue:[NSNumber numberWithFloat:4.] forKey:@"inputIntensity"];
        CIImage *outputImage = [filter outputImage];
        
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        
        newImg = [newImg imageWith3x3GaussianBlur];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.frameForEdit.image = newImg;
            [self.editingIndicator stopAnimating];
            CGImageRelease(cgimg);
            filter = nil;
            context = nil;
        });
        
    
    });
    dispatch_release(quque);
}

-(void)filterApply:(FiltersView *)view typeFilter:(NSInteger)type
{
    filterChange = YES;
    
    switch (type) {
        case 1:
            NSLog(@"NORMAL");
            filterChange = NO;
            
            self.frameForEdit.image = preoviousImage;
            break;
        case 2: //sepia
        {
            
            NSString *reqSysVer = @"5.0";
            NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
            
            if ([reqSysVer floatValue] > [currSysVer floatValue])
            {
//                UIImage *sImage = preoviousImage;
//                self.frameForEdit.image = [sImage sepia];
//                return;
                [self changeProcessImage:2];
                [stillImageSource processImage];
                self.frameForEdit.image = [sepiaFilter imageFromCurrentlyProcessedOutput];
                
            }
            [self sepia:preoviousImage:1.0];
        }
            break;
        case 3: //antique
        {
            NSString *reqSysVer = @"5.0";
            NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
            
            if ([reqSysVer floatValue] > [currSysVer floatValue])
            {
                UIImage *sImage = preoviousImage;
                sImage = [sImage imageWithContrast:95];
                self.frameForEdit.image = [sImage darkVignette];
                return;
            }
            
            [self antiqueEffect:preoviousImage];
        }
            break;
        case 4:
        {
            UIImage * i = [preoviousImage imageWith5x5GaussianBlur];
            self.frameForEdit.image = i;
             
        }
            break;
        case 5:  //
        {
            NSString *reqSysVer = @"5.0";
            NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
            
            if ([reqSysVer floatValue] > [currSysVer floatValue])
            {
                [self changeProcessImage: 1];
                [(GPUImageVignetteFilter *)vignetteFilter setVignetteStart:0.4];
                [(GPUImageVignetteFilter *)vignetteFilter setVignetteEnd:0.7];
                
                [stillImageSource processImage];
                
                self.frameForEdit.image = [vignetteFilter imageFromCurrentlyProcessedOutput];
                
//                UIImage *sImage = preoviousImage;
//                sImage = [sImage imageWithContrast:98 brightness:98];
//                self.frameForEdit.image = [sImage vignette];
                return;
            }
            
            [self vignette: preoviousImage: 5.0];
        }
            break;
        case 6:
        {
            NSString *reqSysVer = @"5.0";
            NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
            
            if ([reqSysVer floatValue] > [currSysVer floatValue])
            {
                UIImage *sImage = [preoviousImage imageByAdjustingHue:0 saturation:-100 lightness:0];
                self.frameForEdit.image = sImage;
                return;
            }
            
            [self satiation:preoviousImage:0.0 :0.0 :1.0];
        }
            break;
        default:
            break;
    }
    filter = nil;
    context = nil;
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
    self.revertImage.hidden = NO;
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
    self.revertImage.hidden = NO;
}

-(void)changeSystemColor:(StyleColorView *)view to:(NSInteger)indexColor
{
    
    NSString *reqSysVer = @"5.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        NSLog(@"IOS 5");
        UIImage *imFF = [self getImageFromFile];
        
        switch (indexColor) {
            case 0:
            {
                NSLog(@"HUE");
                CIImage *inputImage = [[CIImage alloc] initWithImage:imFF];
                
                filter = [CIFilter filterWithName:@"CIHueAdjust"];
                [filter setDefaults];
                [filter setValue:inputImage forKey:@"inputImage"];
                [filter setValue:[NSNumber numberWithFloat:0.0] forKey:@"inputAngle"];
                
                context = [CIContext contextWithOptions:nil];
            }
                break;
            case 1:
            {
                NSLog(@"SITUATION");
                CIImage *inputImage = [[CIImage alloc] initWithImage:
                                       imFF];
                
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

    }else
    {
        //preoviousImage = [self getImageFromFile];
    }
}

-(void)changeHUeIOS4:(CGFloat)hue withSatuation:(CGFloat)satu
{
    self.frameForEdit.image = [preoviousImage imageByAdjustingHue:hue saturation:satu lightness:0.0];
}

-(void)changeSatuationIOS4:(CGFloat)satu withHue:(CGFloat)hue
{
    self.frameForEdit.image = [preoviousImage imageByAdjustingHue:hue saturation:satu lightness:0.0];
}


@end
