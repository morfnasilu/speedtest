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
#import "SPFTPTransferManager.h"
#import "SPFTPThroughputTest.h"
#import "SPCoreDataManager.h"
#import "SPCoreDataManager+Tests.h"
#import "SPInjections.h"
#import "SPSpeedLatencyTest.h"

@interface SPInjectorContainer : NSObject<SPUIManagerInjection,
                                          SPTransferManagerInjection,
                                          SPSpeedThroughputTestInjection,
                                          SPSpeedTestManagerProtocol,
                                          SPDataGeneratorProtocol,
                                          SPFTPTransferManagerInjection,
                                          SPFTPThroughputTestInjection,
                                          SPCoreDataInjection,
                                          SPSpeedTestHistoryInjection,
                                          SPSpeedLatencyTestInjection>

- (id<SPUIManagerProtocol>)uiManager;
- (id<SPTransferManagerProtocol>)transferManager;
- (id<SPTransferManagerProtocol>)ftpTransferManager;
- (id<SPSpeedTestProtocol>)throughputTest;
- (id<SPSpeedTestProtocol>)ftpThroughputTest;
- (id<SPSpeedTestProtocol>)latencyTest;
- (id<SPSpeedTestManagerProtocol>)speedTestManager;
- (id<SPDataGeneratorProtocol>)dataGenerator;
- (id<SPCoreDataManagerProtocol, SPCoreDataManagerTestsProtocol>)coreDataManager;

@end

SPInjectorContainer *injectorContainer();
