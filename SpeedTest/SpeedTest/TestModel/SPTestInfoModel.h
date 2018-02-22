//
//  SPTestInfoModel.h
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSUInteger, SPTestInfoModelType) {
    SPTestInfoModelTypeDonwloading,
    SPTestInfoModelTypeUploading
};

@interface SPTestInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) long testPickSpeed;
@property (nonatomic, assign) long testAverageSpeed;
@property (nonatomic, assign) long testBytesCount;
@property (nonatomic, assign) SPTestInfoModelType testInfoType;

@end
