//
//  TestAPIManager.h
//  CTNetworking
//
//  Created by casa on 15/12/31.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "CTNetworking.h"

extern NSString * const kTestAPIManagerParamsKeyLatitude;
extern NSString * const kTestAPIManagerParamsKeyLongitude;

/// 管理某个 API
@interface TestAPIManager : CTAPIBaseManager <CTAPIManager>

@end
