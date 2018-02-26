//
//  SPFTPThroughputTest.h
//  SpeedTest
//
//  Created by Pavel Skovorodko on 2/22/18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPFTPThroughputTest.h"
#import "SPFTPTransferManager.h"
#import "LxFTPRequest.h"
#import "SPDataGenerator.h"

static NSString *const kFullDownloadURLString = @"ftp://speedtest.tele2.net/100MB.zip";
static NSString *const kFullUploadURLString = @"ftp://speedtest.tele2.net/upload/SPUploadedData";
static NSInteger const kUploadDataLength = 1000000000;

@interface SPFTPThroughputTest()

@property (nonatomic, strong) id<SPFTPThroughputTestInjection>injection;

@end

@implementation SPFTPThroughputTest

@synthesize testState = _testState;
@synthesize doneSize = _doneSize;
@synthesize speed = _speed;
@synthesize avarageSpeed = _avarageSpeed;
@synthesize pickSpeed = _pickSpeed;
@synthesize chunkSize = _chunkSize;
@synthesize testType = _testType;
@synthesize latency = _latency;

#pragma mark - Init & Config

- (instancetype)initWithInjection:(id<SPFTPThroughputTestInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
    }
    return self;
}

#pragma mark - SPSpeedTestProtocol

- (void)runDownloadTest {
    NSArray<NSString *> *filesLink = @[kFullDownloadURLString];
    [self addDownloadTasksWithLinkArray:filesLink];
}

- (void)runUploadTest {
    NSArray<NSString *> *filesLink = @[kFullUploadURLString, kFullUploadURLString, kFullUploadURLString];
    
    // TODO: replace with method for NSData or add number of requests parameter
    [self addUploadTasksWithLinkArray:filesLink];
}

- (void)cancelTest {
    self.doneSize = 0;
    self.speed = 0;
    self.avarageSpeed = 0;
    self.pickSpeed = 0;
    self.chunkSize = 0;
    self.testState = SPSpeedTestComplete;
    
    [self.injection.ftpTransferManager cancelAllTasks];
}

#pragma mark - Add tasks

- (void)addDownloadTasksWithLinkArray:(NSArray<NSString *> *)links {
    
    __weak SPFTPThroughputTest *weakSelf = self;
    
    __block NSInteger tasksCount = 0;
    
    weakSelf.testState = SPSpeedTestRunning;
    
    [links enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf.injection.ftpTransferManager addDownloadTaskWithURL:[NSURL URLWithString:obj] handler:^(long downloadedLastChunkSize, long expectedSize, long downloadedSize, NSError *error) {
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
     
- (void)addUploadTasksWithLinkArray:(NSArray<NSString *> *)links {
    __weak SPFTPThroughputTest *weakSelf = self;
    
    __block NSInteger tasksCount = 0;
    
    weakSelf.testState = SPSpeedTestRunning;
    
    [links enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.injection.ftpTransferManager addUploadTaskWithURL:[NSURL URLWithString:obj] uploadData:[self.injection.dataGenerator generateDataWithLength:kUploadDataLength] handler:^(long downloadedLastChunkSize, long expectedSize, long downloadedSize, NSError *error) {
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


-(BOOL)supportLatencyTest {
    return NO;
}


-(BOOL)supportDownloadTest {
    return YES;
}


-(BOOL)supportUploadTest {
    return YES;
}

@end
