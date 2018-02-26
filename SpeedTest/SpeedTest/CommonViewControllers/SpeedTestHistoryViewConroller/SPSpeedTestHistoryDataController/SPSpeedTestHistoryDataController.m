//
//  SPSpeedTestHistoryDataController.m
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPSpeedTestHistoryDataController.h"
#import "SPCoreDataManager.h"
#import "SPCoreDataManager+Tests.h"
#import "SPTestModel.h"
#import "SPInjections.h"
#import "SPSpeedTest+CoreDataProperties.h"

static NSInteger const kSpeedTestHistoryBatchLimit = 20;

@interface SPSpeedTestHistoryDataController()<NSFetchedResultsControllerDelegate> {
    NSMutableArray<SPTestModel *> *_speedTestHistory;
}

@property (nonatomic, strong) id<SPSpeedTestHistoryInjection> injection;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;
@end


@implementation SPSpeedTestHistoryDataController

-(instancetype)initWithInjection:(id<SPSpeedTestHistoryInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
        _speedTestHistory = [NSMutableArray new];
        [self setupFetchController];
    }
    return self;
}


-(void)setupFetchController {
    if (_fetchedResultsController) {
        return;
    }
    self.fetchRequest = [self.injection.coreDataManager wholeHistoryFetchRequest];
    self.fetchRequest.fetchBatchSize = kSpeedTestHistoryBatchLimit;
    self.fetchRequest.returnsObjectsAsFaults = YES;
    self.fetchedResultsController =  [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                             managedObjectContext:[self.injection.coreDataManager backgroundManagedObjectContext]
                                                                               sectionNameKeyPath:nil
                                                                                        cacheName:nil];
    self.fetchedResultsController.delegate = self;
    [self performFetch];
}


-(void)performFetch {
    NSManagedObjectContext *backgroundContext = [_injection.coreDataManager backgroundManagedObjectContext];
    [backgroundContext performBlock:^{
        NSError *error;
        if (![_fetchedResultsController performFetch:&error]) {
            NSLog(@"FetchResultController: Something went wrong, error: %@", [error debugDescription]);
        }
        NSArray<SPSpeedTest *> *managedTests = _fetchedResultsController.fetchedObjects;
        [managedTests enumerateObjectsUsingBlock:^(SPSpeedTest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_speedTestHistory addObject:[self testModelFromManagedObject:obj]];
        }];
        [self.delegate controllerWasInit];
    }];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (type == NSFetchedResultsChangeInsert) {
        SPSpeedTest *managedTest = [_fetchedResultsController objectAtIndexPath:newIndexPath];
        NSLog(@"NSFetchedResultsChangeInsert");
        [_speedTestHistory insertObject:[self testModelFromManagedObject:managedTest] atIndex:newIndexPath.row];
    }
    else if (type == NSFetchedResultsChangeDelete) {
        NSLog(@"NSFetchedResultsChangeDelete");
        [_speedTestHistory removeObjectAtIndex:indexPath.row];
    }
    else if (type == NSFetchedResultsChangeUpdate) {
        SPSpeedTest *managedTest = [_fetchedResultsController objectAtIndexPath:newIndexPath];
        NSLog(@"NSFetchedResultsChangeUpdate");
        if (_speedTestHistory.count > indexPath.row) {
            [_speedTestHistory replaceObjectAtIndex:indexPath.row withObject:[self testModelFromManagedObject:managedTest]];
        }
    }
    else if (type == NSFetchedResultsChangeMove) {
        SPTestModel *conversation = [_speedTestHistory objectAtIndex:indexPath.row];
        NSLog(@"NSFetchedResultsChangeMove");
        [_speedTestHistory removeObjectAtIndex:indexPath.row];
        [_speedTestHistory insertObject:conversation atIndex:newIndexPath.row];
    }
    if (self.delegate) {
        [self.delegate controllerDidChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    }
}


-(SPTestModel *)testModelFromManagedObject:(SPSpeedTest *)managedObject {
    NSError *adapterError;
    
    NSData *data = [managedObject.info dataUsingEncoding:NSUTF8StringEncoding];
    NSError *parseError;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    
    SPTestModel *mantleTest = [MTLJSONAdapter modelOfClass:[SPTestModel class] fromJSONDictionary:jsonDict error:&adapterError];
    
    return mantleTest;
}


-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if (self.delegate) {
        [self.delegate controllerWillChangeContent];
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (self.delegate) {
        [self.delegate controllerDidChangeContentWithFetchedObjectsCount:controller.fetchedObjects.count];
    }
}


-(NSInteger)objectsCount {
    return _speedTestHistory.count;
}


-(SPTestModel *)testModelAtIndex:(NSIndexPath *)indexPath {
    return _speedTestHistory[indexPath.row];
}

@end
