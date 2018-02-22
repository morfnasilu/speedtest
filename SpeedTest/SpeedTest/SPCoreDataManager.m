//
//  PCCoreDataManager.m
//  PEN
//
//  Created by Dmtech on 14.09.17.
//  Copyright © 2017 DarkMatterAB. All rights reserved.
//

#import "SPCoreDataManager.h"
#import "SPCoreDataManager+Operations.h"

@interface SPCoreDataManager () {
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectContext *_maintContext;
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_backgroundContext;
}

@end


@implementation SPCoreDataManager

- (instancetype)initWithInjection:(id<SPCoreDataInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
    }
    return self;
}


- (void)initDataBaseWithComletion:(SPCoreDataStackInitOperationCompletion)competion {
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SpeedTestDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    NSString *dbPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *newPath = [dbPath stringByAppendingPathComponent:@"speedTest.db"];
    NSURL *dbURL= [NSURL fileURLWithPath:newPath];
    NSError *error = nil;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:options error:&error]) {
        
        NSLog(@"Error adding the persistent store.");
        competion(NO);
        return;
    }
//    _maintContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [_maintContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
    _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_backgroundContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    [_backgroundContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
    competion(YES);
}


-(void)mocDidSaveNotification:(NSNotification *)notification {
    NSManagedObjectContext *savedContext = [notification object];
    // ignore change notifications for the main MOC
    if ([self mainManagedObjectContext] == savedContext) {
        return;
    }
    
    if ([self backgroundManagedObjectContext].persistentStoreCoordinator != savedContext.persistentStoreCoordinator) {
        // that's another database
        return;
    }
    NSArray *objects = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
    for (NSManagedObject *object in objects) {
        [[[self backgroundManagedObjectContext] objectWithID:[object objectID]] willAccessValueForKey:nil];
    }
    
    [[self backgroundManagedObjectContext] performBlock:^{
        NSLog(@"backgroundManagedObjectContext  notification %@", notification);
        [[self backgroundManagedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
//        NSError *error = nil;
//        if (![[self backgroundManagedObjectContext] save:&error]) {
//            NSLog(@"error merging changes %@, %@", error, [error userInfo]);
//        }
    }];
//    [[self mainManagedObjectContext] performBlockAndWait:^{
//        [[self mainManagedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
//        [[self mainManagedObjectContext] processPendingChanges];
//    }];
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)mainManagedObjectContext {
    return _maintContext;
}


- (NSManagedObjectContext *)backgroundManagedObjectContext {
    return _backgroundContext;
}


- (void)deleteDatabase {
    [self performWriteInBackground:^id(BOOL *success) {
        NSArray *allEntities = _managedObjectModel.entities;
        for (NSEntityDescription *entityDescription in allEntities) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
            fetchRequest.includesPropertyValues = NO;
            fetchRequest.includesSubentities = NO;
            fetchRequest.returnsObjectsAsFaults = YES;
            NSError *error;
            NSArray *items = [[self getThreadContext] executeFetchRequest:fetchRequest error:&error];
            if (error) {
                //NSLog(@"Error requesting items from Core Data: %@", [error localizedDescription]);
            }
            for (NSManagedObject *managedObject in items) {
                [[self getThreadContext] deleteObject:managedObject];
            }
        }
        return nil;
    } completion:^(BOOL success, id data) {
        
    }];
}

@end
