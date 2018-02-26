//
//  SPSpeedTestManagerDelegate.h
//  SpeedTest
//
//  Created by Dmtech on 20.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSpeedTestManagerProtocol.h"
#import "SPSpeedTestManagerDelegate.h"
#import "SPSpeedTestProtocol.h"

@protocol SPSpeedTestManagerDelegate<NSObject>

-(void)testStateChanged:(id<SPSpeedTestProtocol>)test state:(SPSpeedTestState)testState;
-(void)testLatencyChanged:(double)latency;

@end
