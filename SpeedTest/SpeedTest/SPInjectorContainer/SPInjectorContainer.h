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

@interface SPInjectorContainer : NSObject<SPUIManagerInjection,
                                          SPTransferManagerInjection,
                                          SPSpeedThroughputTestInjection,
                                          SPSpeedTestManagerProtocol,
                                          SPDataGeneratorProtocol,
                                          SPFTPTransferManagerInjection,
                                          SPFTPThroughputTestInjection>

- (id<SPUIManagerProtocol>)uiManager;
- (id<SPTransferManagerProtocol>)transferManager;
- (id<SPTransferManagerProtocol>)ftpTransferManager;
- (id<SPSpeedTestProtocol>)throughputTest;
- (id<SPSpeedTestProtocol>)ftpThroughputTest;
- (id<SPSpeedTestManagerProtocol>)speedTestManager;
- (id<SPDataGeneratorProtocol>)dataGenerator;

@end

SPInjectorContainer *injectorContainer();
