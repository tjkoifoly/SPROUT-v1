//
//  UploadToSproutViewController.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sprout.h"

@interface UploadToSproutViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImage *imageInput;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *urlImage;

@property (strong, nonatomic) NSMutableArray *listSprout;
@property (strong, nonatomic) IBOutlet UITableView *table;

-(IBAction)goToHome:(id)sender;
-(IBAction)createNewSprout:(id)sender;

@end
