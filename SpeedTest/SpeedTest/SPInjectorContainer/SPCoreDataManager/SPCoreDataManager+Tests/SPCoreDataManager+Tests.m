//
//  SPCoreDataManager+Tests.m
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPCoreDataManager+Tests.h"
#import "SPCoreDataManager+Operations.h"
#import "SPSpeedTest+CoreDataProperties.h"
#import "SPMantleHelper.h"
#import "SPTestModel.h"

@implementation SPCoreDataManager(Tests)

-(void)addTestToDataBase:(SPTestModel *)test withCompletion:(SPCoreDataStackDeleteOperationCompletion)completion {
    [self performWriteInBackground:^id(BOOL *success) {
        NSManagedObjectContext *context = [self getThreadContext];
        SPSpeedTest *managedTest = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([SPSpeedTest class]) inManagedObjectContext:context];
        
        managedTest.info = jsonStringForMantleWithModel(test);
        managedTest.testDate = test.testDate;
        
        return nil;
    } completion:^(BOOL success, id data) {
        completion(YES);
    }];
}


-(NSFetchRequest *)wholeHistoryFetchRequest {
    NSFetchRequest *testHistoryFetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([SPSpeedTest class])];
    testHistoryFetchRequest.returnsObjectsAsFaults = NO;
    [testHistoryFetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@keypath([SPSpeedTest new], testDate) ascending:NO]]];
    return testHistoryFetchRequest;
}

@end
