//
//  SPUIManager.h
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPUIManagerProtocol.h"

@protocol SPUIManagerInjection<NSObject>

@end

@interface SPUIManager : NSObject<SPUIManagerProtocol>

- (instancetype)init __attribute__((unavailable("dont use init, use initWithInjection")));

- (instancetype)initWithInjection:(id<SPUIManagerInjection>)injection;


@end
