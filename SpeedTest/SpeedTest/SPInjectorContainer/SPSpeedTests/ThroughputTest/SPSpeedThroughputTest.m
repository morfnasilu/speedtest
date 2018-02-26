//
//  SPSpeedThroughputTest.m
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPSpeedThroughputTest.h"
#import "SPTransferManager.h"
#import "SPDataGenerator.h"
#import "SPSpeedLatencyTest.h"

static const NSString *kSPSpeedThroughputTestURL =  @"http://Reika.local/upload.php";
static const NSInteger kSPSpeedThroughputFilesCount = 10;
static const NSInteger kSPSpeedThroughputFileDefaultFileSize = 3000000;

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
@synthesize testType = _testType;
@synthesize latency = _latency;

- (instancetype)initWithInjection:(id<SPSpeedThroughputTestInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
    }
    return self;
}


-(BOOL)supportLatencyTest {
    return YES;
}


-(BOOL)supportDownloadTest {
    return YES;
}


-(BOOL)supportUploadTest {
    return YES;
}


-(void)runDownloadTest {
    NSArray<NSString *> *filesLink = @[@"http://speedtest-brest.tech.mts.by:8080/download?nocache=1558360a-3e11-437d-9329-68c45c61ba48&size=25000000",
                                       @"http://speedtest-brest.tech.mts.by:8080/download?nocache=1806d867-3bc8-4443-84b4-71821b003f8d&size=25000000",
                                       @"http://speedtest-brest.tech.mts.by:8080/download?nocache=0f1b6b24-fc54-47e8-b6f7-a1ffc706dd68&size=25000000",
                                       @"http://speedtest-brest.tech.mts.by:8080/download?nocache=d35c5824-4a24-4614-8e91-2737fe0159d6&size=25000000"];
    
    __weak SPSpeedThroughputTest *weakSelf = self;
    [RACObserve(self.injection.latencyTest, latency) subscribeNext:^(NSNumber *value) {
        if ([value  doubleValue]) {
            weakSelf.latency = value.doubleValue;
            [weakSelf addDownloadTasksWithLinkArray:filesLink];
        }
    }];
    [self.injection.latencyTest runLatencyTestToHost:@"speedtest-brest.tech.mts.by"];
}


-(void)runUploadTest {
    NSMutableArray<NSData *> *datasArray = [NSMutableArray new];
    for (int i = 0;i < kSPSpeedThroughputFilesCount; i++) {
        [datasArray addObject:[self.injection.dataGenerator generateDataWithLength:kSPSpeedThroughputFileDefaultFileSize]];
    }
    [self addUploadTasksWithDatasArray:datasArray];
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
                weakSelf.testState = SPSpeedTestComplete;
            }
        }];
    }];
}


-(void)addUploadTasksWithDatasArray:(NSArray<NSData *> *)datasArray {
    __weak SPSpeedThroughputTest *weakSelf = self;
    
    __block NSInteger tasksCount = 0;
    
    weakSelf.testState = SPSpeedTestRunning;
    
    NSString *name = [[[[NSUUID UUID] UUIDString] substringToIndex:5] lowercaseString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?name=%@", kSPSpeedThroughputTestURL, name]];
    [datasArray enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.injection.transferManager addUploadTaskWithURL:url uploadData:obj handler:^(long uploadedChunkSize, long expectedSize, long uploadedSize, NSError *error) {
            int i = 0;
            i++;
        }];
    }];
}


-(void)cancelTest {
    self.doneSize = 0;
    self.speed = 0;
    self.avarageSpeed = 0;
    self.pickSpeed = 0;
    self.chunkSize = 0;
    
    [self.injection.transferManager cancelAllTasks];
}

@end
