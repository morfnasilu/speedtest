//
//  SPSpeedTestManager.h
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSpeedTestManagerProtocol.h"

@protocol SPTransferManagerProtocol;
@protocol SPFTPTransferManagerProtocol;
@protocol SPSpeedTestProtocol;
@protocol SPCoreDataManagerProtocol;
@protocol SPCoreDataManagerTestsProtocol;

@protocol SPSpeedTestManagerInjection<NSObject>

- (id<SPTransferManagerProtocol>)transferManager;
- (id<SPFTPTransferManagerProtocol>)ftpTransferManager;
- (id<SPSpeedTestProtocol>)throughputTest;
- (id<SPSpeedTestProtocol>)ftpThroughputTest;
- (id<SPCoreDataManagerProtocol, SPCoreDataManagerTestsProtocol>)coreDataManager;
- (id<SPSpeedTestProtocol>)latencyTest;

@end

@interface SPSpeedTestManager : NSObject<SPSpeedTestManagerProtocol>

- (instancetype)init __attribute__((unavailable("dont use init, use initWithInjection")));

- (instancetype)initWithInjection:(id<SPSpeedTestManagerInjection>)injection;

@end
