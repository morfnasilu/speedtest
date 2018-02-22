//
//  PCCoreDataOperationsProtocol.h
//  PEN
//
//  Created by Dmtech on 14.09.17.
//  Copyright © 2017 DarkMatterAB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^SPCoreDataStackOperationBlock)(BOOL *success);
typedef void (^SPCoreDataCompletionBlock)(BOOL success, id data);

@protocol SPCoreDataOperationsProtocol<NSObject>


- (void)performReadInBackground:(SPCoreDataStackOperationBlock)readerBlock completion:(SPCoreDataCompletionBlock)completion;
- (id)performReadSynchronous:(SPCoreDataStackOperationBlock)readerBlock success:(BOOL *)success;

- (void)performChangeInBackground:(SPCoreDataStackOperationBlock)updaterBlock completion:(SPCoreDataCompletionBlock)completion;

- (void)performWriteInBackground:(SPCoreDataStackOperationBlock)writingBlock completion:(SPCoreDataCompletionBlock)completion;
- (id)performWriteSynchronous:(SPCoreDataStackOperationBlock)writingBlock success:(BOOL *)success;

- (NSManagedObjectContext *)getThreadContext;

@end
