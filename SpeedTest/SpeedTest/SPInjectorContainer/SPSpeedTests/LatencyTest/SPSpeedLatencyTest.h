//
//  SPSpeedLatencyTest.h
//  SpeedTest
//
//  Created by Dmtech on 23.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSpeedTestProtocol.h"

@protocol SPSpeedLatencyTestInjection<NSObject>

@end


@interface SPSpeedLatencyTest : NSObject<SPSpeedTestProtocol>

- (instancetype)init __attribute__((unavailable("dont use init, use initWithInjection")));

- (instancetype)initWithInjection:(id<SPSpeedLatencyTestInjection>)injection;

@end
