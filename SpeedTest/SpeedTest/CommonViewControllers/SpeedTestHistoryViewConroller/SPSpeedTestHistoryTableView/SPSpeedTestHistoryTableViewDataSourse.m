//
//  SPSpeedTestHistoryTableViewDataSourse.m
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPSpeedTestHistoryTableViewDataSourse.h"
#import "SPSpeedTestHistoryDataController.h"
#import "SPInjectorContainer.h"
#import "SPTestModel.h"
#import "SPSpeedTestHistoryTableViewCell.h"
#import "SPTestInfoModel.h"

@interface SPSpeedTestHistoryTableViewDataSourse()<SPTestsHistoryDataSourseControllerDelegate> {
    SPSpeedTestHistoryDataController *_dataController;
    __weak UITableView *_tableView;
}

@end


@implementation SPSpeedTestHistoryTableViewDataSourse

-(instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        _dataController = [[SPSpeedTestHistoryDataController alloc] initWithInjection:injectorContainer()];
        _dataController.delegate = self;
        _tableView = tableView;
        _dataController.delegate = self;
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataController objectsCount];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPTestModel *speedTestModel = [_dataController testModelAtIndex:indexPath];
    SPSpeedTestHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SPSpeedTestHistoryTableViewCell class])];
    
    NSString *testTypeText = nil;
    switch (speedTestModel.testType) {
        case SPTestModelTypeThroughputType:
            testTypeText = NSLocalizedString(@"Throughput test", @"Throughput test");
            break;
        case SSPTestModelTypeFTPType:
            testTypeText = NSLocalizedString(@"FTP test", @"FTP test");
            break;
        case SPTestModelTypeVideoType:
            testTypeText = NSLocalizedString(@"Video test", @"Video test");
            break;
        case SPTestModelTypeVoiceType:
            testTypeText = NSLocalizedString(@"Voice test", @"Voice test");
            break;
        case SPTestModelTypeWebType:
            testTypeText = NSLocalizedString(@"Web test", @"Web test");
            break;
        default:
            break;
    }
    cell.testTypeLabel.text = testTypeText;
    
    NSByteCountFormatter *formatter = [NSByteCountFormatter new];
    formatter.includesUnit = NO;
    cell.testAverageSpeedLabel.text = [formatter stringFromByteCount:speedTestModel.downloadingTestInfo.testAverageSpeed];
    return cell;
    

}

#pragma mark DataSourseDelegate

- (void)controllerDidChangeObject:(id)anObject
                      atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
                     newIndexPath:(NSIndexPath *)newIndexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                break;
            case NSFetchedResultsChangeDelete:
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                break;
            case NSFetchedResultsChangeUpdate:
                if ([_tableView.indexPathsForVisibleRows containsObject:indexPath]) {
                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                break;
            case NSFetchedResultsChangeMove:
                [_tableView deleteRowsAtIndexPaths:[NSArray
                                                        arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [_tableView insertRowsAtIndexPaths:[NSArray
                                                        arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
        }
    });
}

- (void)controllerDidChangeContentWithFetchedObjectsCount:(NSInteger)fetchedObjectsCount {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView endUpdates];
    });
}

- (void)controllerWillChangeContent {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView beginUpdates];
    });
}


- (void)controllerWasInit {
    dispatch_async(dispatch_get_main_queue(), ^{
         [_tableView reloadData];
    });
   
}


-(void)dealloc {
    
}
@end
