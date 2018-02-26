//
//  SPTransferMangerProtocol.h
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SPTransferManagerDownloadingHandler) (long downloadedLastChunkSize, long expectedSize, long downloadedSize, NSError *error);
typedef void (^SPTransferManagerUploadingHandler) (long uploadedChunkSize, long expectedSize, long uploadedSize, NSError *error);

@protocol SPTransferManagerProtocol<NSObject>

-(void)addDownloadTaskWithURL:(NSURL *)url handler:(SPTransferManagerDownloadingHandler)handler;
-(void)addUploadTaskWithURL:(NSURL *)url uploadData:(NSData *)data handler:(SPTransferManagerUploadingHandler)handler;

-(void)cancelAllTasks;

@end
