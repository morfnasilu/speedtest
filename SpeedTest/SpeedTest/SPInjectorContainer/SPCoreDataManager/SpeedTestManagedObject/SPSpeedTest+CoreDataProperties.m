//
//  SPSpeedTest+CoreDataProperties.m
//  SpeedTest
//
//  Created by Dmtech on 22.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//
//

#import "SPSpeedTest+CoreDataProperties.h"

@implementation SPSpeedTest (CoreDataProperties)

+ (NSFetchRequest<SPSpeedTest *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SPSpeedTest"];
}

@dynamic testDate;
@dynamic info;

@end
