//
//  CLBasicCommand.m
//  CLNetWorkApiManager
//
//  Created by liang on 2017/8/11.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "CLBasicCommand.h"

@implementation CLBasicCommand

#pragma mark publick method
- (void)execute {
    
    [self.apiManager loadData];
}

- (NSDictionary *)paramsForNextCommand:(CTAPIBaseManager *)apiManager {
    
    return nil;
}
#pragma mark - CTAPIManagerParamSource

- (NSDictionary *)paramsForApi:(CTAPIBaseManager *)manager {
    
    if (self.params) {
        
        return self.params;
    }
    if ([self.dataSource respondsToSelector:@selector(paramsForcommand:)]) {
        
        return [self.dataSource paramsForcommand:self];
    }
    return nil;
}
#pragma mark - CTAPIManagerCallBackDelegate

- (void)managerCallAPIDidFailed:(CTAPIBaseManager *)manager {
    
    if ([self.delegate respondsToSelector:@selector(command:didFaildWith:)]) {
        
        [self.delegate command:self didFaildWith:manager];
    }
    
}

- (void)managerCallAPIDidSuccess:(CTAPIBaseManager *)manager {
    
    if (self.next) {
        
        if ([self.delegate respondsToSelector:@selector(command:successMessage:)]) {
            
            [self.delegate command:self successMessage:manager];
        }
        /// 这里直接将 VC 中的 params 保存到 command 里。这样做有什么好处呢？
        /// 我明白了，这里提供了一个参数拦截的方法，paramsForNextCommand 是每个 command 可选实现的，如果实现了，就直接用这个方法给的参数
        /// 这个的好处是，某个页面触发了一个接口调用，然后这个接口调用完后，会调用下一个接口。并且下一个接口的所有参数和这个页面无关。那么我们就没有必要再把获取参数的方法写在该 VC 中了，直接在 Command 里处理就可以了。
        /// 妙哉妙哉
        self.next.params = [self paramsForNextCommand:manager];
        [self.next execute];
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(command:didSuccess:)]) {
            
            [self.delegate command:self didSuccess:manager];
        }
    }
    
}

- (CTAPIBaseManager *)apiManager {
    /// 用这种方式强制重写，其实也可以用 protocol 的
    NSParameterAssert(@"subclass must rewrite this method");
    return nil;
}
@end
