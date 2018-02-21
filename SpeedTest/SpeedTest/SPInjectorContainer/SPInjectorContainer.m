//
//  SPInjectorContainer.m
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPInjectorContainer.h"
#import "SPSpeedThroughputTest.h"

@implementation SPInjectorContainer

- (id<SPUIManagerProtocol>)uiManager {
    static id<SPUIManagerProtocol> uiManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uiManager = [[SPUIManager alloc] initWithInjection:self];
    });
    return uiManager;
}


- (id<SPTransferMangerProtocol>)transferManager {
    static id<SPTransferMangerProtocol> transferManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transferManager = [[SPTransferManager alloc] initWithInjection:self];
    });
    return transferManager;
}


- (id<SPSpeedTestProtocol>)throughputTest {
    static id<SPSpeedTestProtocol> throughputTest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        throughputTest = [[SPSpeedThroughputTest alloc] initWithInjection:self];
    });
    return throughputTest;
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

@end

SPInjectorContainer *injectorContainer() {
    static SPInjectorContainer * injectorContainer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        injectorContainer = [[SPInjectorContainer alloc] init];
        
    });
    return injectorContainer;
}
