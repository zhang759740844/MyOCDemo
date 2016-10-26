//
//  SVProgress.h
//  test
//
//  Created by Zachary on 2016/10/20.
//  Copyright © 2016年 Zachary. All rights reserved.
//
typedef void(^SVProgresshud)();

#import <Foundation/Foundation.h>

@interface SVProgress : NSObject

+ (SVProgresshud)getBlock;
@end
