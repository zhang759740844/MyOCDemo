//
//  AXServiceFactory.m
//  RTNetworking
//
//  Created by casa on 14-5-12.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import "CTServiceFactory.h"
#import "CTService.h"

/*************************************************************************/

// service name list


@interface CTServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation CTServiceFactory

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CTServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CTServiceFactory alloc] init];
    });
    return sharedInstance;
}
//多线程环境可能会引起崩溃，对dataSource加个同步锁
#pragma mark - public methods
- (CTService<CTServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    @synchronized (self.dataSource) {

        /// condition是条件表达式，值为YES或NO；desc为异常描述，通常为NSString。当conditon为YES时程序继续运行，为NO时，则抛出带有desc描述的异常信息。
        NSAssert(self.dataSource, @"必须提供dataSource绑定并实现servicesKindsOfServiceFactory方法，否则无法正常使用Service模块");
        
        if (self.serviceStorage[identifier] == nil) {
            self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
        }
        return self.serviceStorage[identifier];

    }
}

#pragma mark - private methods
/// 要先生成一个 service。有一个 servicefactory，保存了 service 的字典。根据传入的 servicetype 查找有没有 service 实例。如果没有，根据 appdelegate 中定义的一个字典根据 servicetype 找到对应的 service 的名称，然后通过 runtime 动态创建 service。
- (CTService<CTServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    NSAssert([self.dataSource respondsToSelector:@selector(servicesKindsOfServiceFactory)], @"请实现CTServiceFactoryDataSource的servicesKindsOfServiceFactory方法");
    
    if ([[self.dataSource servicesKindsOfServiceFactory]valueForKey:identifier]) {
        NSString *classStr = [[self.dataSource servicesKindsOfServiceFactory]valueForKey:identifier];
        id service = [[NSClassFromString(classStr) alloc]init];
        NSAssert(service, [NSString stringWithFormat:@"无法创建service，请检查servicesKindsOfServiceFactory提供的数据是否正确"],service);
        NSAssert([service conformsToProtocol:@protocol(CTServiceProtocol)], @"你提供的Service没有遵循CTServiceProtocol");
        return service;
    }else {
        NSAssert(NO, @"servicesKindsOfServiceFactory中无法找不到相匹配identifier");
    }
    
    return nil;
}

@end
