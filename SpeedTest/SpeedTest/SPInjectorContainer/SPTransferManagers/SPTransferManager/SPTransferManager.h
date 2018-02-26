//
//  SPTransferManager.h
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTransferManagerProtocol.h"

@protocol SPTransferManagerInjection<NSObject>

@end

@interface SPTransferManager : NSObject<SPTransferManagerProtocol>

- (instancetype)init __attribute__((unavailable("dont use init, use initWithInjection")));

- (instancetype)initWithInjection:(id<SPTransferManagerInjection>)injection;

@end
