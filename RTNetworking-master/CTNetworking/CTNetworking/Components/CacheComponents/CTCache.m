//
//  CTCache.m
//  RTNetworking
//
//  Created by casa on 14-5-26.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTCache.h"
#import "NSDictionary+CTNetworkingMethods.h"
#import "CTNetworkingConfigurationManager.h"
@interface CTCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation CTCache

#pragma mark - getters and setters
- (NSCache *)cache
{
    if (_cache == nil) {
        _cache = [[NSCache alloc] init];
        /// 设置 cache 的过期时间  默认保存在 Configuration 里
        _cache.countLimit = [CTNetworkingConfigurationManager sharedInstance].cacheCountLimit;
    }
    return _cache;
}

#pragma mark - life cycle
/// cache 应该是单例的
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CTCache *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTCache alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public method
- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                   requestParams:(NSDictionary *)requestParams
{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams
{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key
{
    /// 缓存的是 CTCachedObject，这个在 data 的基础上添加了时间检测。如果超时，那么就返回nil，表示没有合法的cache
    CTCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key
{
    CTCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject == nil) {
        cachedObject = [[CTCachedObject alloc] init];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
}

- (void)deleteCacheWithKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}

- (void)clean
{
    [self.cache removeAllObjects];
}

- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName requestParams:(NSDictionary *)requestParams
{
    return [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams CT_urlParamsStringSignature:NO]];
}

#pragma mark - private method
@end
