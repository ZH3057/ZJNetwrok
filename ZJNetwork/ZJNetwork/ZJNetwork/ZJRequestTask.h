//
//  ZJRequestTask.h
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/11.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZJRequestMethod) {
    ZJRequestMethod_GET,
    ZJRequestMethod_POST,
};

typedef NS_OPTIONS(NSUInteger, ZJRequestCachePolicy) {
    ZJRequestCachePolicyNoCache = 0,
    ZJRequestCachePolicyMemory = 1 << 0,
    ZJRequestCachePolicyDisk = 1 << 1,
};


@class ZJRequestTask;

@protocol ZJRequestTaskDelegate <NSObject>

@optional

- (void)requestTask:(ZJRequestTask * __nullable)requestTask successWithResponse:(NSURLResponse * __nullable)response responseObject:(id    __nullable)responseObject;
- (void)requestTask:(ZJRequestTask * __nullable)requestTask failWithResponse:(NSURLResponse * __nullable)response error:(NSError * __nullable)error;

@required

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZJRequestTask : NSObject

@property (nonatomic, weak) id<ZJRequestTaskDelegate> delegate;
@property (nonatomic, assign) ZJRequestMethod method;
@property (nonatomic, assign) ZJRequestCachePolicy cachePolicy;

@property (nonatomic, copy, readonly) NSString *requestInfoString;
@property (nonatomic, copy, readonly) NSString *responseInfoString;

- (void)cancelRequestWithRequestId:(NSInteger)requestId;

/**
 在控制器销毁的时候调用(dcontroller delloc中)
 */
- (void)cancelRequestAll;

- (NSNumber *)fetchDataWithPath:(NSString * __nonnull)requetPath;
- (NSNumber *)fetchDataWithPath:(NSString * __nonnull)requetPath parameters:(NSDictionary * __nullable)parameters;

@end

NS_ASSUME_NONNULL_END
