//
//  SPSpeedTestHistoryDataController.h
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPTestModel;

@protocol SPTestsHistoryDataSourseControllerDelegate

- (void)controllerDidChangeObject:(id)anObject
                      atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
                     newIndexPath:(NSIndexPath *)newIndexPath;

- (void)controllerDidChangeContentWithFetchedObjectsCount:(NSInteger)fetchedObjectsCount;

- (void)controllerWillChangeContent;

- (void)controllerWasInit;

@end

@protocol SPSpeedTestHistoryInjection;

@interface SPSpeedTestHistoryDataController : NSObject

-(instancetype)initWithInjection:(id<SPSpeedTestHistoryInjection>)injection;

@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id<SPTestsHistoryDataSourseControllerDelegate> delegate;

-(NSInteger)objectsCount;
-(SPTestModel *)testModelAtIndex:(NSIndexPath *)indexPath;

@end
