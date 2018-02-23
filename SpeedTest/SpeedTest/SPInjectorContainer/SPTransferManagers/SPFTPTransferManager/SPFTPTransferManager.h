//
//  SPFTPTransferManager.h
//  SpeedTest
//
//  Created by Pavel Skovorodko on 2/22/18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTransferManagerProtocol.h"

@protocol SPDataGeneratorProtocol;

@protocol SPFTPTransferManagerInjection <NSObject>

- (id<SPDataGeneratorProtocol>)dataGenerator;

@end

@interface SPFTPTransferManager : NSObject <SPTransferManagerProtocol>

- (instancetype)init __attribute__((unavailable("dont use init, use initWithInjection")));

- (instancetype)initWithInjection:(id<SPFTPTransferManagerInjection>)injection;

@end
