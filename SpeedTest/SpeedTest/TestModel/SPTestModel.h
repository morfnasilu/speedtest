//
//  SPTestInfoModel.h
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Mantle/Mantle.h>

@class SPTestInfoModel;

typedef NS_ENUM(NSUInteger, SPTestModelType) {
    SPTestModelTypeThroughputType,
    SSPTestModelTypeFTPType,
    SPTestModelTypeVideoType,
    SPTestModelTypeVoiceType,
    SPTestModelTypeWebType
};

@interface SPTestModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) SPTestInfoModel *downloadingTestInfo;
@property (nonatomic, strong) SPTestInfoModel *uploadingTestInfo;
@property (nonatomic, strong) NSDate *testDate;
@property (nonatomic, assign) SPTestModelType testType;

@property (nonatomic, assign) long testPing;

@end
