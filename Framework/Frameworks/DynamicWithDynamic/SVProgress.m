//
//  SVProgress.m
//  test
//
//  Created by Zachary on 2016/10/20.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "SVProgress.h"
#import "SVProgressHUD/SVProgressHUD.h"

@implementation SVProgress
+(SVProgresshud)getBlock{
    return ^(){
        [SVProgressHUD showSuccessWithStatus:@"成功！"];
    };
}
@end
