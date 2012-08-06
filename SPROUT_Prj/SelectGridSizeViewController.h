//
//  SelectGridSizeViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SproutScrollView.h"

@interface SelectGridSizeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *rowPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *colPicker;

@property (strong, nonatomic) NSArray *rowPickerData;
@property (strong, nonatomic) NSArray *colPickerData;
@property (strong, nonatomic) NSString *sproutName;

@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (nonatomic) BOOL stayup;

-(IBAction)goToHome:(id)sender;
-(IBAction)create:(id)sender;
-(void)setViewMoveUp: (BOOL) moveUp;
-(IBAction)resignKeyboard:(id)sender;

@end
