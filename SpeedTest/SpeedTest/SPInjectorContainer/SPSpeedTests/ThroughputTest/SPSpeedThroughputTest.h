//
//  SPSpeedThroughputTest.h
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSpeedTestProtocol.h"

@protocol SPTransferManagerProtocol;
@protocol SPTransferMangerProtocol;
@protocol SPDataGeneratorProtocol;

@protocol SPSpeedThroughputTestInjection<NSObject>

- (id<SPTransferManagerProtocol>)transferManager;
- (id<SPDataGeneratorProtocol>)dataGenerator;
- (id<SPSpeedTestProtocol>)latencyTest;

@end

@interface SPSpeedThroughputTest : NSObject<SPSpeedTestProtocol>

- (instancetype)init __attribute__((unavailable("dont use init, use initWithInjection")));

- (instancetype)initWithInjection:(id<SPSpeedThroughputTestInjection>)injection;

@end
