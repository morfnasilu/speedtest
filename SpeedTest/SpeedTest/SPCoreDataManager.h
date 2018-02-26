//
//  PCCoreDataManager.h
//  PEN
//
//  Created by Dmtech on 14.09.17.
//  Copyright © 2017 DarkMatterAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPCoreDataManagerProtocol.h"

@protocol SPCoreDataInjection<NSObject>

@end

@interface SPCoreDataManager : NSObject<SPCoreDataManagerProtocol>

- (instancetype)init __attribute__((unavailable("dont use init, use initWithInjection")));

- (instancetype)initWithInjection:(id<SPCoreDataInjection>)injection;

@property (nonatomic, strong) id<SPCoreDataInjection> injection;

@end
