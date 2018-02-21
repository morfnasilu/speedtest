//
//  SPTransferMangerProtocol.h
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SPTransferMangerHandler) (long downloadedLastChunkSize, long expectedSize, long downloadedSize, NSError *error);

@protocol SPTransferMangerProtocol<NSObject>

-(void)addDownloadTaskWithURL:(NSURL *)url handler:(SPTransferMangerHandler)handler;

-(void)cancelAllTasks;

@end
