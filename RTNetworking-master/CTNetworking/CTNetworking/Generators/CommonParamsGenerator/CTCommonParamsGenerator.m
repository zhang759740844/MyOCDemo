//
//  AXPublicURLParamsGenerator.m
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTCommonParamsGenerator.h"
#import "NSDictionary+CTNetworkingMethods.h"

/// 这里是自己配置的，添加一些每次都要传的参数。上面对应普通的请求，下面的对应于 logger 请求
@implementation CTCommonParamsGenerator

+ (NSDictionary *)commonParamsDictionary
{
    return @{
             };
}

+ (NSDictionary *)commonParamsDictionaryForLog
{
    return @{
             };
}

@end
