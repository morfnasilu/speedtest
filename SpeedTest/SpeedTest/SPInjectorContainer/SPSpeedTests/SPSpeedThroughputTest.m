//
//  SPSpeedThroughputTest.m
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPSpeedThroughputTest.h"
#import "SPTransferManager.h"

@interface SPSpeedThroughputTest() {

}

@property (nonatomic, strong) id<SPSpeedThroughputTestInjection>injection;

@end

@implementation SPSpeedThroughputTest

@synthesize testState = _testState;
@synthesize doneSize = _doneSize;
@synthesize speed = _speed;

- (instancetype)initWithInjection:(id<SPSpeedThroughputTestInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
    }
    return self;
}

-(void)runTest {
    NSArray<NSString *> *filesLink = @[@"https://upload.wikimedia.org/wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg",
                                       @"http://www.satsignal.eu/wxsat/msg-1-fc-40.jpg",
                                       @"https://upload.wikimedia.org/wikipedia/commons/2/28/%27Calypso%27_Panorama_of_Spirit%27s_View_from_%27Troy%27.jpg"];
//    NSArray<NSString *> *filesLink = @[@"https://upload.wikimedia.org/wikipedia/commons/f/ff/Pizigani_1367_Chart_10MB.jpg"];
    [self addDownloadTasksWithLinkArray:filesLink];
}


-(void)addDownloadTasksWithLinkArray:(NSArray<NSString *> *)links {
    __weak SPSpeedThroughputTest *weakSelf = self;
    
    __block NSInteger tasksCount = 0;
    __block NSInteger availableTasks = links.count;
    
    weakSelf.testState = SPSpeedTestRunning;
    
    [links enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.injection.transferManager addDownloadTaskWithURL:[NSURL URLWithString:obj] handler:^(long downloadedLastChunkSize, long expectedSize, long downloadedSize, NSError *error) {
            weakSelf.doneSize += downloadedLastChunkSize;
            if (downloadedSize >= expectedSize) {
                tasksCount++;
            }
            if (tasksCount >= links.count) {
                weakSelf.testState = SPSpeedTestComplete;
            }
        }];
    }];
}
-(void)cancelTest {
    
}

@end
