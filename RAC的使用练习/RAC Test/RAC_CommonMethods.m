//
//  RAC_CommonMethods.m
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/25.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import "RAC_CommonMethods.h"
#import "LLView.h"

@interface RAC_CommonMethods ()

@end

@implementation RAC_CommonMethods

+ (void)listenMethodUseWithView:(UIView *)view {
    [[view rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"点击View");
    }];
}

+ (void)listenNotificationUse {
    // 监听通知
    // 管理观察者:不需要管理观察者,RAC内部管理
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"Notification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"监听到通知 -- %@", x);
    }];
    
    
    // 发出通知
    NSDictionary *dict = @{@"name" : @"ray", @"age" : @10};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification" object:nil userInfo:dict];
}

+ (void)listenTextChangeWithTextField:(UITextField *)txtField label:(UILabel *)label {
    [txtField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"txtField: %@", x);
    }];
    
    // 绑定
    RAC(label,text) = txtField.rac_textSignal;
}

@end
