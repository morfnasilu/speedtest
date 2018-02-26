//
//  SPInjections.h
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPCoreDataManagerProtocol;
@protocol SPCoreDataManagerTestsProtocol;

@protocol SPSpeedTestHistoryInjection<NSObject>

- (id<SPCoreDataManagerProtocol, SPCoreDataManagerTestsProtocol>)coreDataManager;

@end
