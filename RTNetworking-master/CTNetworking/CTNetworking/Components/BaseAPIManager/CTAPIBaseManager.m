//
//  AJKBaseManager.m
//  casatwy2
//
//  Created by casa on 13-12-2.
//  Copyright (c) 2013年 casatwy inc. All rights reserved.
//

#import "CTAPIBaseManager.h"
#import "CTNetworking.h"
#import "CTCache.h"
#import "CTLogger.h"
#import "CTServiceFactory.h"
#import "CTApiProxy.h"
#import "CTNetworkingConfigurationManager.h"

#define AXCallAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
    __weak typeof(self) weakSelf = self;                                                        \
    REQUEST_ID = [[CTApiProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(CTURLResponse *response) {                                         \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf successedOnCallingAPI:response];                                            \
    } fail:^(CTURLResponse *response) {                                                         \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf failedOnCallingAPI:response withErrorType:CTAPIManagerErrorTypeDefault];    \
    }];                                                                                         \
    [self.requestIdList addObject:@(REQUEST_ID)];                                                   \
}



@interface CTAPIBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign) BOOL isNativeDataEmpty;

@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) CTAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (nonatomic, strong) CTCache *cache;

@end

@implementation CTAPIBaseManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        
        _fetchedRawData = nil;
        
        _errorMessage = nil;
        _errorType = CTAPIManagerErrorTypeDefault;
        
        /// 如果没有实现代理类的这些方法，确实应该报错。比如接口 url 是最基本的
        NSObject<CTAPIManager> *child = self.child;
        if ([self conformsToProtocol:@protocol(CTAPIManager)]) {
            child = (id <CTAPIManager>)self;
        } else {
            child = (id <CTAPIManager>)self;
            NSException *exception = [[NSException alloc] initWithName:@"CTAPIBaseManager提示" reason:[NSString stringWithFormat:@"%@没有遵循CTAPIManager协议",child] userInfo:nil];
            @throw exception;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - public methods
- (void)cancelAllRequests
{
    [[CTApiProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[CTApiProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (id)fetchDataWithReformer:(id<CTAPIManagerDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}

- (id)fetchFailedRequstMsg:(id<CTAPIManagerDataReformer>)reformer {
    
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:failedReform:)]) {
        
        resultData = [reformer manager:self failedReform:self.fetchedRawData];
    } else
        resultData = [self.fetchedRawData mutableCopy];
    return resultData;
}


#pragma mark - calling api
- (NSInteger)loadData
{
    /// 调用 paramSource(即 VC)中的 paramsForApi 方法 获得参数
    NSDictionary *params = [self.paramSource paramsForApi:self];
    /// 用 params 发送请求，返回一个 requestId
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params
{
    NSInteger requestId = 0;
    /// 设置参数
    NSDictionary *apiParams = [self reformParams:params];
    /// 询问 interceptor 是否调用
    if ([self shouldCallAPIWithParams:apiParams]) {
        /// 现在该到验证器验证的时候了，验证一般在 apimanager 的子类里
        if ([self.validator manager:self isCorrectWithParamsData:apiParams]) {
            /// 因为有一种需求较先展示保存在本地的数据，请求数据的数据下次使用。所以这里不 return 0，而是继续执行了下去。
            /// 所以本地数据不是用来缓存的，而是用来保存下次使用的
            /// 这里我觉得没有必要用 child 因为这个方法不是必须的，那么就直接由 baseAPIManager 代劳就行了。如果这里要用child，那么👇 self shouldCache 为什么 不用 child
            if ([self.child shouldLoadFromNative]) {
                [self loadDataFromNative];
            }
            
            // 先检查一下是否有缓存
            if ([self shouldCache] && [self hasCacheWithParams:apiParams]) {
                return 0;
            }
            
            // 实际的网络请求
            if ([self isReachable]) {
                self.isLoading = YES;
                switch (self.child.requestType)
                {
                    case CTAPIManagerRequestTypeGet:
                        AXCallAPI(GET, requestId);
                        break;
                    case CTAPIManagerRequestTypePost:
                        AXCallAPI(POST, requestId);
                        break;
                    case CTAPIManagerRequestTypePut:
                        AXCallAPI(PUT, requestId);
                        break;
                    case CTAPIManagerRequestTypeDelete:
                        AXCallAPI(DELETE, requestId);
                        break;
                    default:
                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kCTAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
                
            } else {
                [self failedOnCallingAPI:nil withErrorType:CTAPIManagerErrorTypeNoNetWork];
                return requestId;
            }
        } else {
            [self failedOnCallingAPI:nil withErrorType:CTAPIManagerErrorTypeParamsError];
            return requestId;
        }
    }
    return requestId;
}

#pragma mark - api callbacks
- (void)successedOnCallingAPI:(CTURLResponse *)response
{
    self.isLoading = NO;
    self.response = response;
    
    /// 这个并不对 response 是否有数据做验证，可能因为对于这种这次拿了下次展示的数据来说，有没有数据并不重要吧。
    if ([self.child shouldLoadFromNative]) {
        /// iscache 是 no 的时候，表示是从网络断获取的数据
        if (response.isCache == NO) {
            /// 保存到本地
            [[NSUserDefaults standardUserDefaults] setObject:response.responseData forKey:[self.child methodName]];
        }
    }
    /// 将response中的数据 id 类型，拷贝出来放在 manager 中，以供使用。
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    /// 移除 requestId
    [self removeRequestIdWithRequestID:response.requestId];
    /// 对重要属性，判断是否为空的逻辑不要在 delegate 中判断，在验证器里完成，比如 status 等
    if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
        /// 如果要保存 cache 并且是从网络断获取的，那么保存
        if ([self shouldCache] && !response.isCache) {
            [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
        }
        /// 拦截器，在成功回调执行前先执行一些自定义方法，会调用 interceptor 的成功回调前的方法。可以子 APIManager 重载这些方法，做内部拦截，不过这样就要调用 super
        if ([self beforePerformSuccessWithResponse:response]) {
            /// 从本地加载的数据成功后会有一次成功回调，之后并没有结束网络请求，而是继续请求新的数据去了。从网络获得数据后又会产生一个成功回调。这里就要把后面这个成功回调屏蔽掉。
            /// 所以这里先判断是否应该从本地拿数据。如果是，那么就面临着两次回调的情况。本地数据的成功回调时应该执行的，另外本地没有数据时从网络端拿数据也是应该执行的。而直接是从网络端拿到的是不能执行成功回调的。
            if ([self.child shouldLoadFromNative]) {
                if (response.isCache == YES) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
                if (self.isNativeDataEmpty) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
            /// 不是从本地获取的那么直接成功回调。
            } else {
                [self.delegate managerCallAPIDidSuccess:self];
            }
        }
        /// 回调结束，执行拦截器的通用方法。
        [self afterPerformSuccessWithResponse:response];
    } else {
        [self failedOnCallingAPI:response withErrorType:CTAPIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(CTURLResponse *)response withErrorType:(CTAPIManagerErrorType)errorType
{
    NSString *serviceIdentifier = self.child.serviceType;
    CTService *service = [[CTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    
    self.isLoading = NO;
    self.response = response;
    BOOL needCallBack = YES;
    
    if ([service.child respondsToSelector:@selector(shouldCallBackByFailedOnCallingAPI:)]) {
        needCallBack = [service.child shouldCallBackByFailedOnCallingAPI:response];
    }
    
    //由service决定是否结束回调
    /// 上面先拦截了，看看是否是 service 层面的错误处理。如果 service 层处理好了，那么就不需要 API 层面的错误处理了。所以直接 return 掉
    if (!needCallBack) {
        return;
    }
    
    //继续错误的处理
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    
    if ([self beforePerformFailWithResponse:response]) {
        [self.delegate managerCallAPIDidFailed:self];
    }
    [self afterPerformFailWithResponse:response];
}






#pragma mark - method for interceptor

/*
 拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
 当两种情况共存的时候，子类重载的方法一定要调用一下super
 然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
 
 notes:
 正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
 但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
 所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
 这就是decorate pattern
 */
- (BOOL)beforePerformSuccessWithResponse:(CTURLResponse *)response
{
    BOOL result = YES;
    
    self.errorType = CTAPIManagerErrorTypeSuccess;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager: beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(CTURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(CTURLResponse *)response
{
    BOOL result = YES;
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(CTURLResponse *)response
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
/// 实现了manager:shouldCallAPIWithParams:方法的走这个方法，否则返回yes
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self != self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

#pragma mark - method for child
- (void)cleanData
{
    [self.cache clean];
    self.fetchedRawData = nil;
    self.errorMessage = nil;
    self.errorType = CTAPIManagerErrorTypeDefault;
}

//如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
//子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
/// child 都是继承于 BaseManager 的，所以没必要这样处理
- (NSDictionary *)reformParams:(NSDictionary *)params
{
        // 如果child是继承得来的，那么这里就不会跑到，会直接跑子类中的IMP。
        // 如果child是另一个对象，就会跑到这里
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        } else {
            return params;
        }
}

- (BOOL)shouldCache
{
    return [CTNetworkingConfigurationManager sharedInstance].shouldCache;
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params
{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        CTURLResponse *response = [[CTURLResponse alloc] initWithData:result];
        response.requestParams = params;
        [CTLogger logDebugInfoWithCachedResponse:response methodName:methodName serviceIdentifier:[[CTServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier]];
        [strongSelf successedOnCallingAPI:response];
    });
    return YES;
}

- (void)loadDataFromNative
{
    /// 哪里存储的呢？
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:self.child.methodName] options:0 error:NULL];

    if (result) {
        self.isNativeDataEmpty = NO;
        __weak typeof(self) weakSelf = self;
        /// 这里异步是要模拟真实的网络请求？
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            CTURLResponse *response = [[CTURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:result options:0 error:NULL]];
            [strongSelf successedOnCallingAPI:response];
        });
    } else {
        self.isNativeDataEmpty = YES;
    }
}

#pragma mark - getters and setters
- (CTCache *)cache
{
    if (_cache == nil) {
        _cache = [CTCache sharedInstance];
    }
    return _cache;
}

- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    BOOL isReachability = [CTNetworkingConfigurationManager sharedInstance].isReachable;
    if (!isReachability) {
        self.errorType = CTAPIManagerErrorTypeNoNetWork;
    }
    return isReachability;
}

/// 好像 isloading 这个状态确实没啥用
- (BOOL)isLoading
{
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (BOOL)shouldLoadFromNative
{
    return NO;
}

@end
