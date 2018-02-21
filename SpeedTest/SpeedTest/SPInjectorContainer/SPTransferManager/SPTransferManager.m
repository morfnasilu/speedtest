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


-(void)addDownloadTaskWithURL:(NSURL *)url handler:(SPTransferMangerHandler)handler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLSessionTask *dataTask = (SPTransferManagerDownloadTask *)[_session downloadTaskWithURL:url];
    
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
            SPTransferMangerHandler neededHandler = [_handlers objectForKey:@(filteredArray.firstObject.taskIdentifier)];
            neededHandler(0, 0, 0, error);
        }
        [_activeTasks removeObjectsInArray:filteredArray];
        [_handlers removeObjectForKey:@(filteredArray.firstObject.taskIdentifier)];
    }
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
        SPTransferMangerHandler neededHandler = [_handlers objectForKey:@(filteredArray.firstObject.taskIdentifier)];
        neededHandler(bytesWritten, totalBytesExpectedToWrite, totalBytesWritten, nil);
    }
}

@end
