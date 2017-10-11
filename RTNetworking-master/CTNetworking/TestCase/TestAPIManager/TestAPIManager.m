//
//  TestAPIManager.m
//  CTNetworking
//
//  Created by casa on 15/12/31.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestAPIManager.h"
#import "CTHTTPConst.h"
NSString * const kTestAPIManagerParamsKeyLatitude = @"kTestAPIManagerParamsKeyLatitude";
NSString * const kTestAPIManagerParamsKeyLongitude = @"kTestAPIManagerParamsKeyLongitude";

@interface TestAPIManager () <CTAPIManagerValidator>

@end

@implementation TestAPIManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        /// 设置自己就是验证器
        self.validator = self;
    }
    return self;
}

#pragma mark - CTAPIManager
/// 这个应该就是接口名了，
- (NSString *)methodName
{
    return @"geocode/regeo";
}

/// 服务类型，表示服务名和版本的，具体什么用不知
- (NSString *)serviceType
{
    return kCTServiceGDMapV3;
}

/// 用来标识请求类型是 get post 或者其他
- (CTAPIManagerRequestType)requestType
{
    return CTAPIManagerRequestTypeGet;
}

- (BOOL)shouldCache
{
    return YES;
}

/// 对 params 做处理，params 是 VC 中提供的。本方法中还添加了其他参数，如 key，output
- (NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];
    resultParams[@"key"] = [[CTServiceFactory sharedInstance] serviceWithIdentifier:kCTServiceGDMapV3].publicKey;
    resultParams[@"location"] = [NSString stringWithFormat:@"%@,%@", params[kTestAPIManagerParamsKeyLongitude], params[kTestAPIManagerParamsKeyLatitude]];
    resultParams[@"output"] = @"json";
    return resultParams;
}

/// 验证器，分别在调用接口前和调用之后回调，用以判断是否符合要求
#pragma mark - CTAPIManagerValidator
- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data
{
    return YES;
}

/// 对重要属性，判断是否为空的逻辑不要在 delegate 中判断，这种事应该由manager 做完。
- (BOOL)manager:(CTAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data
{
    if ([data[@"status"] isEqualToString:@"0"]) {
        return YES;
    }
    
    return YES;
}

@end
