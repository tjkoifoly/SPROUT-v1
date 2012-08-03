//
//  SelectGridSizeViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectGridSizeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *rowPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *colPicker;

@property (strong, nonatomic) NSArray *rowPickerData;
@property (strong, nonatomic) NSArray *colPickerData;

-(IBAction)goToHome:(id)sender;
-(IBAction)create:(id)sender;

@end
