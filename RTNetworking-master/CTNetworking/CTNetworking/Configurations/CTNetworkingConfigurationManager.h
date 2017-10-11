//
//  CTNetworkingConfigurationManager.h
//  CTNetworking
//
//  Created by Corotata on 2017/4/10.
//  Copyright © 2017年 Long Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTNetworkingConfigurationManager : NSObject

+ (instancetype)sharedInstance;

/// 是否有网络连接
@property (nonatomic, assign, readonly) BOOL isReachable;

/// 是否缓存
@property (nonatomic, assign) BOOL shouldCache;
/// 是否线上环境
@property (nonatomic, assign) BOOL serviceIsOnline;
/// 请求超时时间
@property (nonatomic, assign) NSTimeInterval apiNetworkingTimeoutSeconds;
/// cache 超时时间
@property (nonatomic, assign) NSTimeInterval cacheOutdateTimeSeconds;
/// cache 数量
@property (nonatomic, assign) NSInteger cacheCountLimit;

//默认值为NO，当值为YES时，HTTP请求除了GET请求，其他的请求都会将参数放到HTTPBody中，如下所示
//request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
@property (nonatomic, assign) BOOL shouldSetParamsInHTTPBodyButGET;


@end
