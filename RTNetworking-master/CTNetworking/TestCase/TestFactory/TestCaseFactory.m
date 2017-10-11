//
//  TestCaseFactory.m
//  CTNetworking
//
//  Created by casa on 15/12/31.
//  Copyright © 2015年 casa. All rights reserved.
//

#import "TestCaseFactory.h"

#import "FireSingleAPI.h"

/// 每个 VC 都有一个 type，factory 可以根据这个 type 选择实例化某个 VC
@implementation TestCaseFactory

- (UIViewController *)testCaseWithType:(TestCaseType)testCaseType
{
    UIViewController *testCase = nil;
    
    if (testCaseType == TestCaseTypeFireSingleAPI) {
        testCase = [[FireSingleAPI alloc] init];
    }
    
    return testCase;
}

@end
