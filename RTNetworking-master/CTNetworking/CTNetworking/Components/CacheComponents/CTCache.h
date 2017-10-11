//
//  CTCache.h
//  RTNetworking
//
//  Created by casa on 14-5-26.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTCachedObject.h"

@interface CTCache : NSObject

+ (instancetype)sharedInstance;

/// 将 serviceIdentifier，methodName，requestParams 合成成一个 key
- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                                    methodName:(NSString *)methodName
                                 requestParams:(NSDictionary *)requestParams;



/// 获取 key 对应的 cache
- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                methodName:(NSString *)methodName
                             requestParams:(NSDictionary *)requestParams;

/// 保存 key 对应的 cache
- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams;

/// 删除 key 对应的 cache
- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams;


/// 正在的用 key 获取 cache 的方法
- (NSData *)fetchCachedDataWithKey:(NSString *)key;
- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key;
- (void)deleteCacheWithKey:(NSString *)key;
- (void)clean;

@end
