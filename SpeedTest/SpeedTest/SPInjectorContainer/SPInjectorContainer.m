//
//  SPInjectorContainer.m
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPInjectorContainer.h"
#import "SPSpeedThroughputTest.h"
#import "SPFTPThroughputTest.h"

@implementation SPInjectorContainer

- (id<SPUIManagerProtocol>)uiManager {
    static id<SPUIManagerProtocol> uiManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uiManager = [[SPUIManager alloc] initWithInjection:self];
    });
    return uiManager;
}


- (id<SPTransferManagerProtocol>)transferManager {
    static id<SPTransferManagerProtocol> transferManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transferManager = [[SPTransferManager alloc] initWithInjection:self];
    });
    return transferManager;
}

- (id<SPTransferManagerProtocol>)ftpTransferManager {
    static id<SPTransferManagerProtocol> ftpTransferManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ftpTransferManager = [[SPFTPTransferManager alloc] initWithInjection:self];
    });
    return ftpTransferManager;
}

- (id<SPSpeedTestProtocol>)throughputTest {
    static id<SPSpeedTestProtocol> throughputTest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        throughputTest = [[SPSpeedThroughputTest alloc] initWithInjection:self];
    });
    return throughputTest;
}

- (id<SPSpeedTestProtocol>)ftpThroughputTest {
    static id<SPSpeedTestProtocol> ftpThroughputTest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ftpThroughputTest = [[SPFTPThroughputTest alloc] initWithInjection:self];
    });
    return ftpThroughputTest;
}

- (id<SPSpeedTestManagerProtocol>)speedTestManager {
    static id<SPSpeedTestManagerProtocol> speedTestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        speedTestManager = [[SPSpeedTestManager alloc] initWithInjection:self];
    });
    
    return speedTestManager;
}

- (id<SPDataGeneratorProtocol>)dataGenerator {
    static id<SPDataGeneratorProtocol> dataGenerator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataGenerator = [[SPDataGenerator alloc] init];
    });
    return dataGenerator;
}


- (id<SPCoreDataManagerProtocol, SPCoreDataManagerTestsProtocol>)coreDataManager {
    static id<SPCoreDataManagerProtocol> dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[SPCoreDataManager alloc] initWithInjection:self];
    });
    return dataManager;
}

@end

SPInjectorContainer *injectorContainer() {
    static SPInjectorContainer * injectorContainer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        injectorContainer = [[SPInjectorContainer alloc] init];
        
    });
    return injectorContainer;
}
