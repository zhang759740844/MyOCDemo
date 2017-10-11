//
//  NSDictionary+CTNetworkingMethods.h
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CTNetworkingMethods)

- (NSString *)CT_urlParamsStringSignature:(BOOL)isForSignature;
- (NSString *)CT_jsonString;
///这个其实就是把URL带的参数里的特殊字符转义了一下。在签名的时候用的是未转义的字符串，不签名直接作为URL使用的时候要转义一下。

///这是安居客特殊的签名逻辑，其实跟框架本身无关，各家公司有各家公司不同的做法。
- (NSArray *)CT_transformedUrlParamsArraySignature:(BOOL)isForSignature;

@end
