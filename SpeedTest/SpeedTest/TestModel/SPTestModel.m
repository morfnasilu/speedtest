//
//  SPTestInfoModel.m
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPTestModel.h"
#import "SPTestInfoModel.h"

@implementation SPTestModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
              @keypath(SPTestModel.new, downloadingTestInfo) : @keypath(SPTestModel.new, downloadingTestInfo),
              @keypath(SPTestModel.new, uploadingTestInfo)   : @keypath(SPTestModel.new, uploadingTestInfo),
              @keypath(SPTestModel.new, testDate)            : @keypath(SPTestModel.new, testDate),
              @keypath(SPTestModel.new, testType)            : @keypath(SPTestModel.new, testType),
              @keypath(SPTestModel.new, testPing)            : @keypath(SPTestModel.new, testPing)
              };
}

-(void)setNilValueForKey:(NSString *)key {
    if ([key isEqualToString:@keypath(SPTestModel.new, testPing)]) {
        self.testPing = 0;
    }
    else if ([key isEqualToString:@keypath(SPTestModel.new, testType)]) {
        self.testType = 0;
    }
    else {
        [super setNilValueForKey:key];
    }
}


+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

+ (NSValueTransformer *)testDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}


+ (NSValueTransformer *)downloadingTestInfoTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SPTestInfoModel class]];
}


+ (NSValueTransformer *)uploadingTestInfoTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SPTestInfoModel class]];
}

@end
