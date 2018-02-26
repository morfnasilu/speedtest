//
//  SPSpeedLatencyTest.m
//  SpeedTest
//
//  Created by Dmtech on 23.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPSpeedLatencyTest.h"

static NSString *kSPSpeedLatencyTestHost =  @"google.com";
static const NSInteger kSPSpeedLatencyTestTryingCount = 10;

@interface SPSpeedLatencyTest()<GBPingDelegate> {
    GBPing *_ping;
    NSInteger _latencyTestCount;
    NSTimeInterval _latencyTestDuration;
    NSMutableArray<GBPingSummary *> *_pingSummarys;
}

@property (nonatomic, strong) id<SPSpeedLatencyTestInjection>injection;

@end


@implementation SPSpeedLatencyTest

@synthesize testType = _testType;
@synthesize latency = _latency;

- (instancetype)initWithInjection:(id<SPSpeedLatencyTestInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
        _pingSummarys = [NSMutableArray new];
    }
    return self;
}


-(void)runDownloadTest {
    [self runLatencyTestToHost:kSPSpeedLatencyTestHost];
}


-(void)runLatencyTestToHost:(NSString *)host {
    if (!_ping) {
        _ping = [[GBPing alloc] init];
        _ping.delegate = self;
        _ping.host = kSPSpeedLatencyTestHost;
        _ping.timeout = 1.0;
        _ping.pingPeriod = 1.0;
    }
    [_ping setupWithBlock:^(BOOL success, NSError *error) { //necessary to resolve hostname
        if (success) {
            [_ping startPinging];
        }
        else {
            NSLog(@"failed to start");
        }
    }];
}


-(void)increaseLatencytestCount {
    _latencyTestCount++;
}


-(void)calculateTestIfNeeded {
    if (_latencyTestCount >= kSPSpeedLatencyTestTryingCount) {
        [self calculateAverangeLatency];
        [self cancelTest];
    }
    else {
        [self increaseLatencytestCount];
    }
}


-(void)calculateAverangeLatency {
    __block double pingSum = 0;
    [_pingSummarys enumerateObjectsUsingBlock:^(GBPingSummary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        pingSum += obj.rtt;
    }];
    double summarysCount = [NSNumber numberWithUnsignedInteger:_pingSummarys.count].doubleValue;
    self.latency = pingSum / summarysCount;
}


-(void)ping:(GBPing *)pinger didFailWithError:(NSError *)error {
   [self calculateTestIfNeeded];
}


-(void)ping:(GBPing *)pinger didSendPingWithSummary:(GBPingSummary *)summary {
    
}


-(void)ping:(GBPing *)pinger didFailToSendPingWithSummary:(GBPingSummary *)summary error:(NSError *)error {
    [self calculateTestIfNeeded];
}


-(void)ping:(GBPing *)pinger didTimeoutWithSummary:(GBPingSummary *)summary {
    [self calculateTestIfNeeded];
}


-(void)ping:(GBPing *)pinger didReceiveReplyWithSummary:(GBPingSummary *)summary {
    [_pingSummarys addObject:summary];
    [self calculateTestIfNeeded];
}


-(void)ping:(GBPing *)pinger didReceiveUnexpectedReplyWithSummary:(GBPingSummary *)summary {
    [self calculateTestIfNeeded];
}


-(void)runUploadTest {

}


-(BOOL)supportLatencyTest {
    return YES;
}


-(BOOL)supportDownloadTest {
    return NO;
}


-(BOOL)supportUploadTest {
    return NO;
}


-(void)cancelTest {
    [_pingSummarys removeAllObjects];
    [_ping stop];
    _latencyTestCount = 0;
}


@end
