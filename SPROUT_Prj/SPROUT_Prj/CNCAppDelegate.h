//
//  CNCAppDelegate.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/2/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class MainViewController;
@class HiddenNavigationController;
@class LoadingViewController;

@interface CNCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) HiddenNavigationController *navigationController;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) LoadingViewController *startViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
