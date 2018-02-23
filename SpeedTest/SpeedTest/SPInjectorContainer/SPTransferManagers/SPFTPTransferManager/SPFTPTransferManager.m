//
//  SPFTPTransferManager.m
//  SpeedTest
//
//  Created by Pavel Skovorodko on 2/22/18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPFTPTransferManager.h"
#import "SPInjectorContainer.h"
#import "LxFTPRequest.h"

static NSInteger const kUploadDataLength = 1000000000;

@interface SPFTPTransferManager()

@property (nonatomic, strong) id <SPFTPTransferManagerInjection> injection;

@property (nonatomic, strong) NSArray <LxFTPRequest *> *activeRequestsArray;

@end

@implementation SPFTPTransferManager

#pragma Setup & Init

- (instancetype)initWithInjection:(id<SPFTPTransferManagerInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
        self.activeRequestsArray = @[];
    }
    return self;
}

#pragma mark - SPTransferManagerProtocol

- (void)addDownloadTaskWithURL:(NSURL *)url handler:(SPTransferMangerHandler)handler {
    
    LxFTPRequest *downloadRequest = [LxFTPRequest downloadRequest];
    
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"/"];
    NSString *fullStringPath = [stringPath stringByAppendingString:[NSString stringWithFormat:@"SPDownloadedData%ld", self.activeRequestsArray.count]];
    downloadRequest.localFileURL = [NSURL fileURLWithPath:fullStringPath isDirectory:NO];
    downloadRequest.serverURL = url;
    downloadRequest.username = nil;
    downloadRequest.password = nil;
    
    downloadRequest.progressAction = ^(NSInteger chunkSize, NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
        handler(chunkSize, totalSize, finishedSize, nil);
    };
    
    downloadRequest.successAction = ^(Class resultClass, id result) {
        __weak SPFTPTransferManager *weakSelf = self;
        [weakSelf removeFileAtPath:fullStringPath];
    };
    
    downloadRequest.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString *errorMessage) {
        
        NSError *nError = [NSError errorWithDomain:[NSString stringWithFormat:@"%ld", domain]
                                              code:error
                                          userInfo:@{NSUnderlyingErrorKey:errorMessage}];
        handler(0, 0, 0, nError);
    };
    
    [self addRequestToArray:downloadRequest];
    [downloadRequest start];
}

- (void)addUploadTaskWithURL:(NSURL *)url handler:(SPTransferMangerHandler)handler {
    
    LxFTPRequest *uploadRequest = [LxFTPRequest uploadRequest];
    uploadRequest.serverURL = [url URLByAppendingPathExtension:[NSString stringWithFormat:@"%ld", self.activeRequestsArray.count]];
    uploadRequest.localData = [self.injection.dataGenerator generateDataWithLength:kUploadDataLength];
    uploadRequest.username = nil;
    uploadRequest.password = nil;
    
    uploadRequest.progressAction = ^(NSInteger chunkSize, NSInteger totalSize, NSInteger finishedSize, CGFloat finishedPercent) {
        handler(chunkSize, totalSize, finishedSize, nil);
    };
    
    uploadRequest.failAction = ^(CFStreamErrorDomain domain, NSInteger error, NSString *errorMessage) {
        
        NSError *nError = [NSError errorWithDomain:[NSString stringWithFormat:@"%ld", domain]
                                              code:error
                                          userInfo:@{NSUnderlyingErrorKey:errorMessage}];
        handler(0, 0, 0, nError);
    };
    
    [self addRequestToArray:uploadRequest];
    [uploadRequest start];
}

- (void)cancelAllTasks {
    [self.activeRequestsArray enumerateObjectsUsingBlock:^(LxFTPRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj stop];
    }];
    self.activeRequestsArray = nil;
}

#pragma mark - Utils

- (void)removeFileAtPath:(NSString *)path {
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
}

- (void)addRequestToArray:(LxFTPRequest *)request {
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:self.activeRequestsArray];
    [mutableArray addObject:request];
    self.activeRequestsArray = [mutableArray copy];
}

@end
