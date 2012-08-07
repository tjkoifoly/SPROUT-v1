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
+(void)createSprout: (NSString *)sName : (NSInteger)sizeRow: (NSInteger) sizeCol;
+(NSManagedObject *) sproutForName: (NSString *)sName;
+(NSManagedObject *)imageInSprout: (NSString *)sName: (NSInteger)tag;
+(NSArray *)imagesOfSrpout: (NSManagedObject *)sprout;

@end
