//
//  SPSpeedTestManager.m
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPSpeedTestManager.h"
#import "SPSpeedTestManagerDelegate.h"
#import "SPSpeedTestProtocol.h"
#import "SPCoreDataManager.h"
#import "SPCoreDataManager+Tests.h"
#import "SPTestModel.h"
#import "SPTestInfoModel.h"
#import "SPSpeedLatencyTest.h"

static const NSTimeInterval SPSpeedTestManagerTimeInterval = 1.0;
static const NSTimeInterval SPSpeedTestManagerMaxTestTyme = 5.0;
static const NSTimeInterval SPSpeedTestManagerBitsInByte = 8;

@interface SPSpeedTestManager() {
    
}

@property (nonatomic, strong) id<SPSpeedTestManagerInjection> injection;
@property (nonatomic, weak) id<SPSpeedTestManagerDelegate> delegate;
@property (nonatomic, strong) NSTimer *testTimer;
@property (nonatomic, assign) NSTimeInterval startTestDateInterval;

@end


@implementation SPSpeedTestManager

- (instancetype)initWithInjection:(id<SPSpeedTestManagerInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
    }
    return self;
}


-(void)runLatencyTestWithURL:(NSString *)url
                    delegate:(id<SPSpeedTestManagerDelegate>)delegate {
    _delegate = delegate;
    id<SPSpeedTestProtocol> latencyTest = self.injection.latencyTest;
    [latencyTest runLatencyTestToHost:[NSURL URLWithString:url].host];
    __weak SPSpeedTestManager *weakSelf = self;
    [RACObserve(latencyTest, latency) subscribeNext:^(NSNumber *value) {
        if ([value  doubleValue]) {
            [weakSelf.delegate testLatencyChanged:[value doubleValue]];
        }
    }];
}


-(void)runTestWithType:(SPSpeedTestManagerStrategy)strategy testType:(SPSpeedTestManagerTestType)testType delegate:(id<SPSpeedTestManagerDelegate>)delegate {
    _delegate = delegate;
    id<SPSpeedTestProtocol> neededTest;
    switch (strategy) {
        case SPSpeedTestManagerStrategyLatency:
            neededTest = self.injection.latencyTest;
            break;
        case SPSpeedTestManagerStrategySimple:
            neededTest = self.injection.throughputTest;
            break;
        case SPSpeedTestManagerStrategyFTP:
            neededTest = self.injection.ftpThroughputTest;
            break;
        case SPSpeedTestManagerStrategyYouTube:
            break;
        case SPSpeedTestManagerStrategyVoice:
            break;
        case SPSpeedTestManagerStrategyWeb:
            break;
        default:
            break;
    }
    if (!neededTest) {
        return;
    }
    neededTest.testType = testType;
    testType == SPSpeedTestManagerTestTypeDownloading ? [neededTest runDownloadTest] : [neededTest runUploadTest];
    __weak SPSpeedTestManager *weakSelf = self;
    if (!self.testTimer) {
        if ([neededTest supportLatencyTest]) {
            [RACObserve(neededTest, latency) subscribeNext:^(NSNumber *value) {
                if ([value  doubleValue]) {
                    weakSelf.startTestDateInterval = [NSDate date].timeIntervalSince1970;
                    weakSelf.testTimer = [NSTimer scheduledTimerWithTimeInterval:SPSpeedTestManagerTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
                        [weakSelf calculateProgressForTest:neededTest];
                    }];
                }
            }];
        }
        else {
            self.startTestDateInterval = [NSDate date].timeIntervalSince1970;
            self.testTimer = [NSTimer scheduledTimerWithTimeInterval:SPSpeedTestManagerTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
                [self calculateProgressForTest:neededTest];
            }];
        }
    }
}


-(void)calculateProgressForTest:(id<SPSpeedTestProtocol>)test {
    
    if ([test supportDownloadTest] || [test supportUploadTest]) {
        NSTimeInterval timeFrame = [NSDate date].timeIntervalSince1970 - self.startTestDateInterval;
        test.avarageSpeed = test.doneSize / timeFrame * SPSpeedTestManagerBitsInByte;
        test.speed = test.chunkSize / SPSpeedTestManagerTimeInterval * SPSpeedTestManagerBitsInByte;
        test.pickSpeed = MAX(test.pickSpeed, test.speed);
        
        test.chunkSize = 0;
        if (timeFrame >SPSpeedTestManagerMaxTestTyme) {
            test.testState = SPSpeedTestComplete;
            NSLog(@"Test complete by timer");
        }
        
        if (_delegate) {
            [_delegate testStateChanged:test state:test.testState];
        }
        if (test.testState == SPSpeedTestComplete) {
            [self.testTimer invalidate];
            self.testTimer = nil;
            [self saveTestToDatabase:test];
            [test cancelTest];
            
            if ([test supportUploadTest]) {
                [self runTestWithType:test.testType testType:SPSpeedTestManagerTestTypeUploading delegate:_delegate];
            }
        }
    }
}


-(void)saveTestToDatabase:(id<SPSpeedTestProtocol>)test {
    SPTestModel *testModel = [SPTestModel new];
    SPTestInfoModel *downloadingTestModel = [SPTestInfoModel new];
    downloadingTestModel.testInfoType = SPTestInfoModelTypeDonwloading;
    downloadingTestModel.testPickSpeed = test.pickSpeed;
    downloadingTestModel.testAverageSpeed = test.avarageSpeed;
    downloadingTestModel.testBytesCount = test.doneSize;
    
    testModel.downloadingTestInfo = downloadingTestModel;
    testModel.testDate = [NSDate date];
    
    [self.injection.coreDataManager addTestToDataBase:testModel withCompletion:^(BOOL success) {
        
    }];
}

-(void)setDelegate:(id<SPSpeedTestManagerDelegate>)delegate {
    if (!delegate) {
        _delegate = delegate;
        [self.testTimer invalidate];
        self.testTimer = nil;
    }
}


-(void)cancelTestWithType:(SPSpeedTestManagerStrategy)strategy {
    
}


-(void)dealloc {
    
}

@end
