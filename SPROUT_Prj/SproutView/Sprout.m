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

+(BOOL)createReminder: (NSString *)desc :(NSString *)location: (NSDate *)startTime: (NSString *)duration
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSManagedObject *newReminder = [NSEntityDescription insertNewObjectForEntityForName:@"Reminders" inManagedObjectContext:context];
    [newReminder setValue:desc forKey:@"discription"];
    [newReminder setValue:location forKey:@"location"];
    [newReminder setValue:startTime forKey:@"startTime"];
    [newReminder setValue:duration forKey:@"duration"];
    
    if([context save:&error]) return YES;
    return NO;
}

+(NSArray *)getReminders
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Reminders" inManagedObjectContext:context];
    NSArray *reminders = [context executeFetchRequest:request error:&error];
    
    return reminders;
}

+(BOOL)checkReminder:(NSString *)desc
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Reminders" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"discription = %@", desc];
    
    NSArray *sprouts = [context executeFetchRequest:request error:&error];
    
    if (sprouts.count > 0)
    {
        return YES;
    }else
    {
        return NO;
    }

}


+(BOOL)createSprout: (NSString *)sName : (NSInteger)sizeRow: (NSInteger) sizeCol
{
    if([Sprout anySproutForName:sName] == NO)
    {
        CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError *error;
    
        NSManagedObject *newSproutObject = [NSEntityDescription insertNewObjectForEntityForName:@"Sprouts" inManagedObjectContext:context];
        [newSproutObject setValue:sName forKey:@"name"];
        [newSproutObject setValue:[NSNumber numberWithInt: sizeRow ] forKey:@"rowSize"];
        [newSproutObject setValue:[NSNumber numberWithInt:sizeCol] forKey:@"colSize"];    
    
        for(int i = 0; i< sizeRow * sizeCol ; i++)
        {
            NSManagedObject *imageOfSprout = [NSEntityDescription insertNewObjectForEntityForName:@"Images" inManagedObjectContext:context];
            [imageOfSprout setValue:@"URL" forKey:@"url"];
            [imageOfSprout setValue:[NSNumber numberWithInt:i]  forKey:@"tag"];
            [imageOfSprout setValue:newSproutObject forKey:@"imageToSprout"];
        }
    
        if([context save:&error]) return YES;
    }else
    {
    }
    return NO;
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

+(BOOL) anySproutForName: (NSString *)sName
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Sprouts" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", sName];
    
    NSArray *sprouts = [context executeFetchRequest:request error:&error];
    
    if (sprouts.count > 0)
    {
        return YES;
    }else
    {
        return NO;
    }
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

+(NSArray *)imagesOfSrpout: (NSManagedObject *)sprout
{
    NSSet *imagesSet = [sprout valueForKey:@"sproutToImages"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag" ascending:YES];
    NSArray *imagesArray = [[imagesSet allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return imagesArray;
}

+(BOOL)deleteObject : (NSManagedObject *)delObj
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    
    [context deleteObject:delObj];
    return [context save:&error];
}
+(BOOL)save
{
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    return [context save:&error];
}

+(BOOL)sproutFinished: (NSManagedObject *)sprout
{
    NSSet *imagesSet = [sprout valueForKey:@"sproutToImages"];
    NSArray *imagesArray = [imagesSet allObjects] ;
    for(id i in imagesArray)
    {
        if([[i valueForKey:@"url"] isEqual:@"URL"])
        {
            return NO;
        }
    }
    return YES;
}

+(BOOL)optimizeSprout:(NSString *)sName withCol: (int)col andRow: (int)row
{
    NSManagedObject *s = [Sprout sproutForName:sName];
    if(col == [[s valueForKey:@"colSize"] intValue])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh Yeah" message:@"Sprout is best match A4" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    [s setValue:[NSNumber numberWithInt:col] forKey:@"colSize"];
    [s setValue:[NSNumber numberWithInt:row] forKey:@"rowSize"];
    CNCAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    return [context save:&error];
}


@end
