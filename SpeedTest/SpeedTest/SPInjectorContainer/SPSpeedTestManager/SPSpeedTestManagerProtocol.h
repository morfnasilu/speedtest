//
//  SPSpeedTestManagerProtocol.h
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPSpeedTestManagerDelegate;

typedef NS_ENUM(NSUInteger, SPSpeedTestManagerStrategy) {
    SPSpeedTestManagerStrategySimple,
    SPSpeedTestManagerStrategyFTP,
    SPSpeedTestManagerStrategyYouTube,
    SPSpeedTestManagerStrategyVoice,
    SPSpeedTestManagerStrategyWeb
};

@protocol SPSpeedTestManagerProtocol<NSObject>

-(void)runTestWithType:(SPSpeedTestManagerStrategy)strategy delegate:(id<SPSpeedTestManagerDelegate>)delegate;
-(void)cancelTestWithType:(SPSpeedTestManagerStrategy)strategy;

@end
