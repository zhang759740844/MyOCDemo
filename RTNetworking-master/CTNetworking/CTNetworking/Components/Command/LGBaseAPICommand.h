//
//  LGBaseAPICommand.h
//  CTNetworking
//
//  Created by Corotata on 2017/4/12.
//  Copyright © 2017年 Corotata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTAPIBaseManager.h"
@class LGBaseAPICommand;

@protocol CTAPICommandDelegate <NSObject>

@required
- (void)commandDidSuccess:(LGBaseAPICommand *)command;
- (void)commandDidFailed:(LGBaseAPICommand *)command;

@end



@protocol CTAPICommand <NSObject>

//- (void)excute;

@end

/// 一个 command 对应一个 apimanager
@interface LGBaseAPICommand : NSObject

/// VC 是 Command 的 delegate 。简单点说就是 apimanager 完成了，那么就会调用 CTAPIManagerCallbackDelegate 的回调，这个command 就实现了这个回调方法，也就是说 apimanager 会回调 command，然后 command 会回调它的代理也就是 VC 的方法。这样形成一个调用链。
@property (nonatomic, weak) id<CTAPICommandDelegate> delegate;  
@property (nonatomic, strong) LGBaseAPICommand *next;
@property (nonatomic, strong) CTAPIBaseManager *apiManager;
//@property (nonatomic, weak) id<CTAPICommand> child;


- (void)excute;


@end
