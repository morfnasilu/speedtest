//
//  SPTransferManager.m
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPTransferManager.h"
#import "SPTransferManagerDownloadTask.h"

@interface SPTransferManager()<NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate> {
    NSURLSession *_session;
    NSMutableArray<NSURLSessionTask *> *_activeTasks;
    NSMutableDictionary *_handlers;
}

@property (nonatomic, strong) id<SPTransferManagerInjection>injection;

@end


@implementation SPTransferManager

-(instancetype)initWithInjection:(id<SPTransferManagerInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
        _activeTasks = [NSMutableArray new];
        _handlers = [NSMutableDictionary new];
        
        [self setupSession];
    }
    return self;
}


-(void)setupSession {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration  defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 40;
    _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
}


-(void)addDownloadTaskWithURL:(NSURL *)url handler:(SPTransferManagerDownloadingHandler)handler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLSessionTask *dataTask = (SPTransferManagerDownloadTask *)[_session downloadTaskWithURL:url];
    
    [_activeTasks addObject:dataTask];
    [_handlers setObject:handler forKey:@(dataTask.taskIdentifier)];
    
    [dataTask resume];
}


-(void)addUploadTaskWithURL:(NSURL *)url uploadData:(NSData *)data handler:(SPTransferManagerUploadingHandler)handler {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSURLSessionTask *dataTask = (SPTransferManagerDownloadTask *)[_session uploadTaskWithRequest:request fromData:data];
    
    [_activeTasks addObject:dataTask];
    [_handlers setObject:handler forKey:@(dataTask.taskIdentifier)];
    
    [dataTask resume];
}


-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {

}


-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {

}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
}


-(void)URLSession:(NSURLSession *)session
             task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskIdentifier == %d", task.taskIdentifier];
    NSArray<NSURLSessionTask *> *filteredArray = [[NSArray arrayWithArray:_activeTasks] filteredArrayUsingPredicate:predicate];
    if (filteredArray.count) {
        if (error) {
            SPTransferManagerDownloadingHandler neededHandler = [_handlers objectForKey:@(filteredArray.firstObject.taskIdentifier)];
            neededHandler(0, 0, 0, error);
        }
        [_activeTasks removeObjectsInArray:filteredArray];
        [_handlers removeObjectForKey:@(filteredArray.firstObject.taskIdentifier)];
    }
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    int i = 0;
    i++;
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"");
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskIdentifier == %d", downloadTask.taskIdentifier];
    NSArray<NSURLSessionTask *> *filteredArray = [[NSArray arrayWithArray:_activeTasks] filteredArrayUsingPredicate:predicate];
    if (filteredArray.count) {
        SPTransferManagerDownloadingHandler neededHandler = [_handlers objectForKey:@(filteredArray.firstObject.taskIdentifier)];
        neededHandler((long)bytesWritten, (long)totalBytesExpectedToWrite, (long)totalBytesWritten, nil);
    }
}


-(void)cancelAllTasks {
    [_activeTasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [_activeTasks removeAllObjects];
    [_handlers removeAllObjects];
}

@end
