//
//  RAC_CommonMethods.h
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/25.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAC_CommonMethods : NSObject

// 监听方法调用
+ (void)listenMethodUseWithView:(UIView *)view;

// 监听通知
+ (void)listenNotificationUse;

// 监听文字输入和改变
+ (void)listenTextChangeWithTextField:(UITextField *)txtField label:(UILabel *)label;

@end
