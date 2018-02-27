//
//  RAC_Advanced.h
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/22.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAC_Advanced : NSObject

// 信号连接（避免多个订阅信号）
+ (void)signalConnection;

// 常用事件处理的信号使用
+ (void)signalCommand;
+ (void)signalCommandSceneWithLoginBtn:(UIButton *)sender;
@end
