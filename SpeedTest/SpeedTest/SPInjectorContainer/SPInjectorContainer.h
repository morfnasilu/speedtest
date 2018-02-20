//
//  SPInjectorContainer.h
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPUIManager.h"
#import "SPTransferManager.h"
#import "SPSpeedThroughputTest.h"
#import "SPSpeedTestManager.h"

@interface SPInjectorContainer : NSObject<SPUIManagerInjection,
                                          SPTransferManagerInjection,
                                          SPSpeedThroughputTestInjection,
                                          SPSpeedTestManagerProtocol>

- (id<SPUIManagerProtocol>)uiManager;
- (id<SPTransferMangerProtocol>)transferManager;
- (id<SPSpeedTestProtocol>)throughputTest;
- (id<SPSpeedTestManagerProtocol>)speedTestManager;

@end

SPInjectorContainer *injectorContainer();
