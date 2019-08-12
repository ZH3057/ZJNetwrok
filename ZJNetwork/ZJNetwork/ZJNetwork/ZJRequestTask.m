//
//  ZJRequestTask.m
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/11.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import "ZJRequestTask.h"
#import "ZJRequestProxy.h"
#import "ZJRequestConfig.h"

@interface ZJRequestTask ()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *requestIdList;

@property (nonatomic, strong) AFJSONRequestSerializer *requestSerializer;

@property (nonatomic, copy, readwrite) NSString *requestInfoString;
@property (nonatomic, copy, readwrite) NSString *responseInfoString;

@end


@implementation ZJRequestTask

static NSMutableArray *recordRequestTaskList;

void ZJStoreRequestTask(ZJRequestTask * requestTask) {
    if (!requestTask) return;
    if (!recordRequestTaskList) {
        recordRequestTaskList = NSMutableArray.array;
    }
    [recordRequestTaskList addObject:requestTask];
}

void ZJRemoveRequestTask(ZJRequestTask * requestTask) {
    if (!requestTask) return;
    if (!recordRequestTaskList) {
        recordRequestTaskList = NSMutableArray.array;
    }
    [recordRequestTaskList removeObject:requestTask];
}

- (NSMutableArray<NSNumber *> *)requestIdList {
    if (!_requestIdList) {
        _requestIdList = NSMutableArray.array;
    }
    return _requestIdList;
}

- (AFJSONRequestSerializer *)requestSerializer {
    if (!_requestSerializer) {
        _requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return _requestSerializer;
}

- (void)cancelRequestWithRequestId:(NSInteger)requestId {
    [ZJRequestProxy cancelRequestWithRequestId:@(requestId)];
}

- (void)cancelRequestAll {
    [ZJRequestProxy cancelRequestWithRequestIdList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (NSNumber *)fetchDataWithPath:(NSString * __nonnull)requetPath {
    return [self fetchDataWithPath:requetPath parameters:nil];
}
- (NSNumber *)fetchDataWithPath:(NSString * __nonnull)requetPath parameters:(NSDictionary * __nullable)parameters {
    
    ZJStoreRequestTask(self);
    
    NSNumber *requestId = @0;
    id responseObject = nil;
    
    if (self.cachePolicy & ZJRequestCachePolicyMemory) {
        responseObject = nil;
    }
    
    if (!responseObject && self.cachePolicy & ZJRequestCachePolicyDisk) {
        responseObject = nil;
    }
    
    if (responseObject) {
        
        self.requestInfoString = @"Request Load cached data";
        self.responseInfoString = @"Response Load cached data";;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestTask:successWithResponse:responseObject:)]) {
            [self.delegate requestTask:self successWithResponse:nil responseObject:responseObject];
        }
        
        ZJRemoveRequestTask(self);
        
        return requestId;
    }
    

    NSString *method = @"GET";
    switch (self.method) {
        case ZJRequestMethod_GET: {
            method = @"GET";
        } break;
            
        case ZJRequestMethod_POST: {
            method = @"POST";
        } break;
        
    }
    
    NSString *URLString = [ZJRequestConfig reforomRequestPath:requetPath];
    NSDictionary *params = [ZJRequestConfig reformParameters:parameters];
    
    NSMutableURLRequest *mutableRequest = [self.requestSerializer requestWithMethod:method URLString:URLString parameters:params error:nil];
    
    self.requestInfoString = [ZJRequestConfig requestInfoStringForRequest:mutableRequest requestPath:requetPath parameters:parameters];
    
    __weak typeof(self) weakSelf = self;
    requestId = [ZJRequestProxy request:mutableRequest successHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject) {
        
        weakSelf.responseInfoString = [ZJRequestConfig responseInfoStringForResponse:(NSHTTPURLResponse *)response responseObject:responseObject request:mutableRequest error:nil];
        
        if (weakSelf.cachePolicy & ZJRequestCachePolicyMemory) {
        
        }
        
        if (weakSelf.cachePolicy & ZJRequestCachePolicyDisk) {
        
        }
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestTask:successWithResponse:responseObject:)]) {
            [weakSelf.delegate requestTask:weakSelf successWithResponse:response responseObject:responseObject];
        }
        
        ZJRemoveRequestTask(weakSelf);
        
    } failHandler:^(NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        
        weakSelf.responseInfoString = [ZJRequestConfig responseInfoStringForResponse:(NSHTTPURLResponse *)response responseObject:nil request:mutableRequest error:error];
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestTask:failWithResponse:error:)]) {
            [weakSelf.delegate requestTask:weakSelf failWithResponse:response error:error];
        }
        
        ZJRemoveRequestTask(weakSelf);
        
    }];
    
    return requestId;
}

- (void)dealloc {
    NSLog(@"ZJRequestTask delloc");
}

@end
