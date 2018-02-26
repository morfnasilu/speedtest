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
    SPSpeedTestManagerStrategyLatency,
    SPSpeedTestManagerStrategySimple,
    SPSpeedTestManagerStrategyFTP,
    SPSpeedTestManagerStrategyYouTube,
    SPSpeedTestManagerStrategyVoice,
    SPSpeedTestManagerStrategyWeb
};


typedef NS_ENUM(NSUInteger, SPSpeedTestManagerTestType) {
    SPSpeedTestManagerTestTypeDownloading,
    SPSpeedTestManagerTestTypeUploading
};

@protocol SPSpeedTestManagerProtocol<NSObject>

-(void)runTestWithType:(SPSpeedTestManagerStrategy)strategy
              testType:(SPSpeedTestManagerTestType)testType
              delegate:(id<SPSpeedTestManagerDelegate>)delegate;
-(void)runLatencyTestWithURL:(NSString *)url
                    delegate:(id<SPSpeedTestManagerDelegate>)delegate;

-(void)cancelTestWithType:(SPSpeedTestManagerStrategy)strategy;

@end
