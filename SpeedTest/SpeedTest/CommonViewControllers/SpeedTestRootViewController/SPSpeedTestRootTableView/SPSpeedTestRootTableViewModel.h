//
//  SPSpeedTestRootTableViewModel.h
//  SpeedTest
//
//  Created by Dmtech on 26.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SPSpeedTestRootTableViewModelRowType) {
    SPSpeedTestRootTableViewModelRowTypeLatency,
    SPSpeedTestRootTableViewModelRowTypeThroughput,
    SPSpeedTestRootTableViewModelRowTypeFTP,
    SPSpeedTestRootTableViewModelRowTypeWeb,
    SPSpeedTestRootTableViewModelRowTypeYouTube,
    SPSpeedTestRootTableViewModelRowTypeCount
};

@interface SPSpeedTestRootTableViewModel : NSObject

@end
