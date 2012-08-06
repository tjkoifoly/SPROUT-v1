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

+(void)createSprout: (NSString *)sName : (NSInteger)sizeRow: (NSInteger) sizeCol
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSManagedObject *newSproutObject = [NSEntityDescription insertNewObjectForEntityForName:@"Sprouts" inManagedObjectContext:context];
    [newSproutObject setValue:sName forKey:@"name"];
    [newSproutObject setValue:[NSNumber numberWithInt:sizeRow ] forKey:@"rowSize"];
    [newSproutObject setValue:[NSNumber numberWithInt:sizeCol] forKey:@"colSize"];    
    
    for(int i = 0; i< sizeRow * sizeCol ; i++)
    {
        NSManagedObject *imageOfSprout = [NSEntityDescription insertNewObjectForEntityForName:@"Images" inManagedObjectContext:context];
        [imageOfSprout setValue:@"URL" forKey:@"url"];
        [imageOfSprout setValue:[NSNumber numberWithInt:i] forKey:@"tag"];
        [imageOfSprout setValue:newSproutObject forKey:@"imageToSprout"];
    }
    
    [context save:&error];

}

+(NSManagedObject *) sproutForName: (NSString *)sName
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Sprouts" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", sName];
    
    NSArray *sprouts = [context executeFetchRequest:request error:&error];
    
    return [sprouts objectAtIndex:0];
}

+(NSManagedObject *)imageInSprout: (NSString *)sName: (NSInteger)tag
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Sprouts" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", sName];
    
    NSArray *sprouts = [context executeFetchRequest:request error:&error];
    
    NSManagedObject * s = [sprouts objectAtIndex:0];
    
    NSFetchRequest *requestImage = [[NSFetchRequest alloc] init];
    requestImage.entity = [NSEntityDescription entityForName:@"Images" inManagedObjectContext:context];
    requestImage.predicate = [NSPredicate predicateWithFormat:@"imageToSprouts = %@ , tag = %i", s, tag];
    
    
    NSArray *images = [context executeFetchRequest:request error:&error];

    return [images objectAtIndex:0];

}

@end
