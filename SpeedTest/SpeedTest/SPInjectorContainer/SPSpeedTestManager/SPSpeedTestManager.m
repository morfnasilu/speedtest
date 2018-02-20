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

static const NSTimeInterval SPSpeedTestManagerTimeInterval = 0.3;

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

-(void)runTestWithType:(SPSpeedTestManagerStrategy)strategy delegate:(id<SPSpeedTestManagerDelegate>)delegate {
    _delegate = delegate;
    id<SPSpeedTestProtocol> neededTest;
    switch (strategy) {
        case SPSpeedTestManagerStrategySimple:
            neededTest = self.injection.throughputTest;
            break;
        case SPSpeedTestManagerStrategyFTP:
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
    [neededTest runTest];
    __weak SPSpeedTestManager *weakSelf = self;
    if (!self.testTimer) {
        self.startTestDateInterval = [NSDate date].timeIntervalSince1970;
        self.testTimer = [NSTimer scheduledTimerWithTimeInterval:SPSpeedTestManagerTimeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
            [weakSelf calculateProgressForTest:neededTest];
        }];
    }
}


-(void)calculateProgressForTest:(id<SPSpeedTestProtocol>)test {
    NSTimeInterval timeFrame = [NSDate date].timeIntervalSince1970 - self.startTestDateInterval;
    test.speed = test.doneSize / timeFrame;
    if (_delegate) {
        [_delegate testStateChanged:test state:test.testState];
    }
    if (test.testState == SPSpeedTestComplete) {
        [self.testTimer invalidate];
        self.testTimer = nil;
    }
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

@end
