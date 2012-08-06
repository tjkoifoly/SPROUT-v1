//
//  Sprout.m
//  SPROUT_Prj
//
//  Created by Nguyen Chi Cong on 8/6/12.
//  Copyright (c) 2012 BKHN. All rights reserved.
//

#import "Sprout.h"

@implementation Sprout

+(NSArray *) loadAllSprout
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Sprouts" inManagedObjectContext:context];
    NSArray *sprouts = [context executeFetchRequest:request error:&error];

    return sprouts;
    
}

@end
