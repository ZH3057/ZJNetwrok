//
//  ZJRequestProxy.h
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/11.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJRequestProxy : NSObject

+ (BOOL)isReachable;
+ (NSNumber *)request:(NSURLRequest *)request successHandler:(void(^)(NSURLResponse *response, id responseObject))successHandler failHandler:(void(^)(NSURLResponse *response, NSError *error))failHandler;
+ (void)cancelRequestWithRequestId:(NSNumber *)requestId;
+ (void)cancelRequestWithRequestIdList:(NSArray<NSNumber *> *)requestIdList;

@end

NS_ASSUME_NONNULL_END
