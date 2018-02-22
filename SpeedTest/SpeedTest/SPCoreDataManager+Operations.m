//
//  PCCoreDataManager+Operations.m
//  PEN
//
//  Created by Dmtech on 14.09.17.
//  Copyright © 2017 DarkMatterAB. All rights reserved.
//

#import "SPCoreDataManager+Operations.h"
#import "SPCoreDataManager.h"

static NSString *const kSPCurrentContextThreadDictionaryKey = @"SPCCurrentThreadContext";

@interface SPDatabaseOperationInfo : NSObject

@property (nonatomic, assign) NSTimeInterval startedTimestamp;
@property (nonatomic, assign) BOOL isWriting;

@end

@implementation SPDatabaseOperationInfo
@end

@implementation SPCoreDataManager (Operations)

- (NSManagedObjectContext *)getThreadContext {
    NSManagedObjectContext *context = [self getThreadContextPrivately];
    return context;
}


- (BOOL)saveThreadContext {
    NSManagedObjectContext *moc = [self getThreadContext];
    NSError *error;
    return [moc save:&error];
}


- (void)setThreadContext:(NSManagedObjectContext *)context {
    if (!context) {
        return;
    }
    NSThread *currentThread = [NSThread currentThread];
    [[currentThread threadDictionary] setValue:context forKey:kSPCurrentContextThreadDictionaryKey];
}


- (NSManagedObjectContext *)getThreadContextPrivately {
    NSThread *currentThread = [NSThread currentThread];
    return [currentThread threadDictionary][kSPCurrentContextThreadDictionaryKey];
}


- (void)performReadInBackground:(SPCoreDataStackOperationBlock)readerBlock completion:(SPCoreDataCompletionBlock)completion {
    [self performOperationInBackground:readerBlock isWriting:NO isSync:NO withInfo:[self operationForContextWithWriting:NO] completion:completion];
}


- (void)performChangeInBackground:(SPCoreDataStackOperationBlock)updaterBlock completion:(SPCoreDataCompletionBlock)completion {
    [self performOperationInBackground:updaterBlock isWriting:YES isSync:NO withInfo:[self operationForContextWithWriting:YES] completion:completion];
}


- (void)performWriteInBackground:(SPCoreDataStackOperationBlock)writingBlock completion:(SPCoreDataCompletionBlock)completion {
    [self performOperationInBackground:writingBlock isWriting:YES isSync:NO withInfo:[self operationForContextWithWriting:YES] completion:completion];
}


- (id)performWriteSynchronous:(SPCoreDataStackOperationBlock)writingBlock success:(BOOL *)success {
    if ([self getThreadContext]) {
        return writingBlock(success);
    }
    else {
        __block id result = nil;
        [self performOperationInBackground:writingBlock
                                 isWriting:YES
                                    isSync:YES
                                  withInfo:[self operationForContextWithWriting:NO]
                                completion:^(BOOL completionSuccess, id data) {
                                    if (success != NULL) {
                                        *success = completionSuccess;
                                    }
                                    if (completionSuccess) {
                                        result = data;
                                    }
                                }];
        return result;
    }
    return nil;
}


- (id)performReadSynchronous:(SPCoreDataStackOperationBlock)readerBlock success:(BOOL *)success {
    if ([self getThreadContext]) {
        return readerBlock(success);
    }
    else {
        __block id result = nil;
        [self performOperationInBackground:readerBlock
                                 isWriting:NO
                                    isSync:YES
                                  withInfo:[self operationForContextWithWriting:NO]
                                completion:^(BOOL completionSuccess, id data) {
                                    if (success != NULL) {
                                        *success = completionSuccess;
                                    }
                                    if (completionSuccess) {
                                        result = data;
                                    }
                                }];
        return result;
    }
    return nil;
}


-(void)performOperationInBackground:(SPCoreDataStackOperationBlock)operationBlock isWriting:(BOOL)isWriting isSync:(BOOL)isSync withInfo:(SPDatabaseOperationInfo *)info completion:(SPCoreDataCompletionBlock)completion {
    
    dispatch_queue_t executionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_block_t blockToDispatch = ^{
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [context setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
        [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [context performBlockAndWait:^{
            context.userInfo[kSPCurrentContextThreadDictionaryKey] = info;
            @autoreleasepool {
                BOOL success = YES;
                [self setThreadContext:context];
                id result = operationBlock(&success);
                if (isWriting) {
                    NSError *error;
                    [context save:&error];
                    if (completion) {
                        completion(success , result);
                    }
                }
                else {
                    if (completion) {
                        completion(success , result);
                    }
                }
            }
        }];
    };
    if (isSync) {
        dispatch_sync(executionQueue, blockToDispatch);
    }
    else {
        dispatch_async(executionQueue, blockToDispatch);
    }
}


-(SPDatabaseOperationInfo *)operationForContextWithWriting:(BOOL)isWriting {
    SPDatabaseOperationInfo * info = [SPDatabaseOperationInfo new];
    info.isWriting = isWriting;
    info.startedTimestamp = [NSDate timeIntervalSinceReferenceDate];
    return info;
}
@end
