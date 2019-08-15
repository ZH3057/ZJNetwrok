//
//  ZJRequestProxy.m
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/11.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import "ZJRequestProxy.h"

@interface ZJRequestProxy ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableDictionary *requestTable;

@end


@implementation ZJRequestProxy


// MARK: - Init


static ZJRequestProxy * _instance = nil;

+ (ZJRequestProxy *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZJRequestProxy alloc] init];
    });
    return _instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

- (NSMutableDictionary *)requestTable {
    if (!_requestTable) {
        _requestTable = NSMutableDictionary.dictionary;
    }
    return _requestTable;
}

// MARK: - Tasks

+ (BOOL)isReachable {
    return [self shareInstance].sessionManager.reachabilityManager.isReachable;
}

+ (NSNumber *)request:(NSURLRequest *)request successHandler:(void(^)(NSURLResponse *response, id responseObject))successHandler failHandler:(void(^)(NSURLResponse *response, NSError *error))failHandler {
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    dataTask = [[self shareInstance].sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSNumber *requestId = @(dataTask.taskIdentifier);
        [[self shareInstance].requestTable removeObjectForKey:requestId];
        
        if (error) {
            !failHandler ?: failHandler(response, error);
        } else {
            !successHandler ?: successHandler(response, responseObject);
        }
    }];
    
    NSNumber *requestId = @(dataTask.taskIdentifier);
    [self shareInstance].requestTable[requestId] = dataTask;
    
    [dataTask resume];
    
    return requestId;
}

+ (void)cancelRequestWithRequestId:(NSNumber *)requestId {
    NSURLSessionDataTask *dataTask = [self shareInstance].requestTable[requestId];
    [dataTask cancel];
    [[self shareInstance].requestTable removeObjectForKey:requestId];
}

+ (void)cancelRequestWithRequestIdList:(NSArray<NSNumber *> *)requestIdList {
    [requestIdList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull requestId, NSUInteger idx, BOOL * _Nonnull stop) {
        [self cancelRequestWithRequestId:requestId];
    }];
}


@end
