//
//  Sprout.h
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/6/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNCAppDelegate.h"

@interface Sprout : NSObject

+(NSArray *) loadAllSprout;
+(BOOL)createSprout: (NSString *)sName : (NSInteger)sizeRow: (NSInteger) sizeCol;
+(BOOL)createReminder: (NSString *)desc :(NSString *)location: (NSDate *)startTime: (NSString *)duration;
+(BOOL)checkReminder: (NSString *)desc;
+(NSArray *)getReminders;

+(NSManagedObject *) sproutForName: (NSString *)sName;
+(BOOL) anySproutForName: (NSString *)sName;
+(NSManagedObject *)imageInSprout: (NSString *)sName: (NSInteger)tag;
+(NSArray *)imagesOfSrpout: (NSManagedObject *)sprout;
+(BOOL)deleteObject : (NSManagedObject *)delObj;
+(BOOL)save;
+(BOOL)sproutFinished:(NSManagedObject *)sprout;
+(BOOL)optimizeSprout:(NSString *)sName withCol: (int)col andRow: (int)row;

@end
