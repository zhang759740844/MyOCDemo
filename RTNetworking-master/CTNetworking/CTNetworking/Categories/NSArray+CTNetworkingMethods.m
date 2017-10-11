//
//  NSArray+CTNetworkingMethods.m
//  RTNetworking
//
//  Created by casa on 14-5-13.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "NSArray+CTNetworkingMethods.h"

@implementation NSArray (CTNetworkingMethods)

/** 字母排序之后形成的参数字符串 */
/// 形成 xxx&xxx&xxx&xxx 的参数形式
- (NSString *)CT_paramsString
{
    NSMutableString *paramString = [[NSMutableString alloc] init];
    /// 先排序
    NSArray *sortedParams = [self sortedArrayUsingSelector:@selector(compare:)];
    /// 一个个添加
    [sortedParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([paramString length] == 0) {
            [paramString appendFormat:@"%@", obj];
        } else {
            [paramString appendFormat:@"&%@", obj];
        }
    }];
    
    return paramString;
}

/** 数组变json */
- (NSString *)CT_jsonString
{
    /// 这里的 option 只有这一种枚举。通过数组->NSData->字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
