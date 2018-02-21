//
//  PSDataGenerator.m
//  SpeedTest
//
//  Created by Pavel Skovorodko on 2/21/18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPDataGenerator.h"

@implementation SPDataGenerator

- (NSData *)generateDataWithLength:(NSUInteger)length {
    return [[NSMutableData dataWithLength:length] copy];
}

@end
