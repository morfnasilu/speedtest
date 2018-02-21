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
@synthesize avarageSpeed = _avarageSpeed;
@synthesize pickSpeed = _pickSpeed;
@synthesize chunkSize = _chunkSize;

- (instancetype)initWithInjection:(id<SPSpeedThroughputTestInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
    }
    return self;
}

-(void)runTest {
//    NSArray<NSString *> *filesLink = @[@"http://speedtest-brest.tech.mts.by:8080/download?nocache=1558360a-3e11-437d-9329-68c45c61ba48&size=25000000",
//                                       @"http://speedtest-brest.tech.mts.by:8080/download?nocache=1806d867-3bc8-4443-84b4-71821b003f8d&size=25000000",
//                                       @"http://speedtest-brest.tech.mts.by:8080/download?nocache=0f1b6b24-fc54-47e8-b6f7-a1ffc706dd68&size=25000000",
//                                       @"http://speedtest-brest.tech.mts.by:8080/download?nocache=d35c5824-4a24-4614-8e91-2737fe0159d6&size=25000000"];
    NSArray<NSString *> *filesLink = @[@"http://speedtest-brest.tech.mts.by:8080/download?nocache=1558360a-3e11-437d-9329-68c45c61ba48&size=25000000",
                                       @"http://speedtest-brest.tech.mts.by:8080/download?nocache=1806d867-3bc8-4443-84b4-71821b003f8d&size=25000000",
                                       @"http://speedtest-brest.tech.mts.by:8080/download?nocache=0f1b6b24-fc54-47e8-b6f7-a1ffc706dd68&size=25000000",
                                       @"http://speedtest-brest.tech.mts.by:8080/download?nocache=d35c5824-4a24-4614-8e91-2737fe0159d6&size=25000000"];
    [self addDownloadTasksWithLinkArray:filesLink];
}


-(void)addDownloadTasksWithLinkArray:(NSArray<NSString *> *)links {
    __weak SPSpeedThroughputTest *weakSelf = self;
    
    __block NSInteger tasksCount = 0;

    weakSelf.testState = SPSpeedTestRunning;
    
    [links enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.injection.transferManager addDownloadTaskWithURL:[NSURL URLWithString:obj] handler:^(long downloadedLastChunkSize, long expectedSize, long downloadedSize, NSError *error) {
            weakSelf.doneSize += downloadedLastChunkSize;
            weakSelf.chunkSize += downloadedLastChunkSize;
            if (downloadedSize >= expectedSize) {
                tasksCount++;
            }
            if (tasksCount >= links.count) {
                [weakSelf cancelTest];
            }
        }];
    }];
}


-(void)cancelTest {
    self.doneSize = 0;
    self.speed = 0;
    self.avarageSpeed = 0;
    self.pickSpeed = 0;
    self.chunkSize = 0;
    self.testState = SPSpeedTestComplete;
}

@end
