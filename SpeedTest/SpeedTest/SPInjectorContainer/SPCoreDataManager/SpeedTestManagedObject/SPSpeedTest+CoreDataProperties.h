//
//  SPSpeedTest+CoreDataProperties.h
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//
//

#import "SPSpeedTest+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SPSpeedTest (CoreDataProperties)

+ (NSFetchRequest<SPSpeedTest *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *testDate;
@property (nullable, nonatomic, copy) NSString *info;

@end

NS_ASSUME_NONNULL_END
