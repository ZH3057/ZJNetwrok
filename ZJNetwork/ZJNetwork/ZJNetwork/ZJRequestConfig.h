//
//  ZJRequestConfig.h
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/11.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJRequestConfig : NSObject

+ (NSString *)reforomRequestPath:(NSString *)requestPath;
+ (NSDictionary *)reformParameters:(NSDictionary *)paramenters;

+ (NSString *)requestInfoStringForRequest:(NSURLRequest *)request requestPath:(NSString *)requestPath parameters:(NSDictionary *)parameters;
+ (NSString *)responseInfoStringForResponse:(NSHTTPURLResponse * __nullable)response responseObject:(id __nullable)responseObject request:(NSURLRequest *)request error:(NSError * __nullable)error;

@end

NS_ASSUME_NONNULL_END
