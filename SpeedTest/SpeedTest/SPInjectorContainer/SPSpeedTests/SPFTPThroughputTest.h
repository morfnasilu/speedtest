//
//  SPFTPThroughputTest.h
//  SpeedTest
//
//  Created by Pavel Skovorodko on 2/22/18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPSpeedTestProtocol.h"

@protocol SPTransferManagerProtocol;

@protocol SPFTPThroughputTestInjection <NSObject>

- (id<SPTransferManagerProtocol>)ftpTransferManager;

@end

@interface SPFTPThroughputTest : NSObject <SPSpeedTestProtocol>

- (instancetype)init __attribute__((unavailable("dont use init, use initWithInjection")));

- (instancetype)initWithInjection:(id<SPFTPThroughputTestInjection>)injection;

@end
