//
//  SPTestInfoModel.m
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPTestInfoModel.h"

@implementation SPTestInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
              @keypath(SPTestInfoModel.new, testPickSpeed)    : @keypath(SPTestInfoModel.new, testPickSpeed),
              @keypath(SPTestInfoModel.new, testAverageSpeed) : @keypath(SPTestInfoModel.new, testAverageSpeed),
              @keypath(SPTestInfoModel.new, testBytesCount)   : @keypath(SPTestInfoModel.new, testBytesCount),
              @keypath(SPTestInfoModel.new, testInfoType)     : @keypath(SPTestInfoModel.new, testInfoType)
              };
}

-(void)setNilValueForKey:(NSString *)key {
    if ([key isEqualToString:@keypath(SPTestInfoModel.new, testPickSpeed)]) {
        self.testPickSpeed = 0;
    }
    else if ([key isEqualToString:@keypath(SPTestInfoModel.new, testAverageSpeed)]) {
        self.testAverageSpeed = 0;
    }
    if ([key isEqualToString:@keypath(SPTestInfoModel.new, testBytesCount)]) {
        self.testBytesCount = 0;
    }
    else if ([key isEqualToString:@keypath(SPTestInfoModel.new, testInfoType)]) {
        self.testInfoType = 0;
    }
    else {
        [super setNilValueForKey:key];
    }
}

@end
