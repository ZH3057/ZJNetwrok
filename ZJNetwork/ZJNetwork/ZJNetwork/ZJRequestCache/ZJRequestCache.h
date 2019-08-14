//
//  ZJRequestCache.h
//  ZJNetwork
//
//  Created by Jun Zhou on 2019/8/12.
//  Copyright © 2019 Jun Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJRequestCache : NSObject

+ (id)fetchMemoryCacheWithQueryPath:(NSString *)queryPath;
+ (void)saveMemoryCacheWithQueryPath:(NSString *)queryPath;

+ (id)fetchDiskCacheWithQueryPath:(NSString *)queryPath;
+ (void)saveDiskCacheWithQueryPath:(NSString *)queryPath;

+ (void)clearMemoryCacheAll;
+ (void)clearDiskCacheAll;
+ (void)clearCacheAll;

@end

NS_ASSUME_NONNULL_END
