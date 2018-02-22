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
#import "SPDataGenerator.h"
#import "SPCoreDataManager.h"
#import "SPCoreDataManager+Tests.h"
#import "SPInjections.h"

@interface SPInjectorContainer : NSObject<SPUIManagerInjection,
                                          SPTransferManagerInjection,
                                          SPSpeedThroughputTestInjection,
                                          SPSpeedTestManagerProtocol,
                                          SPDataGeneratorProtocol,
                                          SPCoreDataInjection,
                                          SPSpeedTestHistoryInjection>

- (id<SPUIManagerProtocol>)uiManager;
- (id<SPTransferMangerProtocol>)transferManager;
- (id<SPSpeedTestProtocol>)throughputTest;
- (id<SPSpeedTestManagerProtocol>)speedTestManager;
- (id<SPDataGeneratorProtocol>)dataGenerator;
- (id<SPCoreDataManagerProtocol, SPCoreDataManagerTestsProtocol>)coreDataManager;

@end

SPInjectorContainer *injectorContainer();
