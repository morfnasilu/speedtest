//
//  SPTransferManagerTask.h
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPTransferManagerDownloadTask : NSURLSessionDownloadTask

@property (nonatomic, assign) long transferManagerTaskSize;
@property (nonatomic, assign) long transferManagerTaskDownloadedSize;
@property (nonatomic, strong) NSMutableData *dataToDownload;

@end
