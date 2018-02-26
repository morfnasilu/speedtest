//
//  PCCoreDataManagerProtocol.h
//  PEN
//
//  Created by Dmtech on 14.09.17.
//  Copyright © 2017 DarkMatterAB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SPCoreDataStackOperationCompletion)(BOOL success, MTLModel *object);
typedef void (^SPCoreDataStackInitOperationCompletion)(BOOL success);
typedef void (^SPCoreDataStackSavingOperationCompletion)(BOOL success, NSArray *mtls);
typedef void (^SPCoreDataStackReadOperationCompletion)(BOOL success, NSArray *mtls);
typedef void (^SPCoreDataStackDeleteOperationCompletion)(BOOL success);
typedef void (^SPCoreDataGetEntitiesCountCompletion)(BOOL success, NSNumber* number);

@protocol SPCoreDataManagerProtocol

- (void)initDataBaseWithComletion:(SPCoreDataStackInitOperationCompletion)competion;

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

- (NSManagedObjectContext *)mainManagedObjectContext;
- (NSManagedObjectContext *)backgroundManagedObjectContext;

- (void)deleteDatabase;

@end
