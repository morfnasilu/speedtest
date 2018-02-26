//
//  SPSpeedTestRootTableViewModel.m
//  SpeedTest
//
//  Created by Dmtech on 26.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPSpeedTestRootTableViewModel.h"

@interface SPSpeedTestRootTableViewModel() {
    NSMutableDictionary *_rowsData;
}

@end


@implementation SPSpeedTestRootTableViewModel

-(instancetype)init {
    if (self = [super init]) {
        _rowsData = [NSMutableDictionary new];
    }
    return self;
}


-(void)configRows {
    
}

@end
