//
//  RAC_Sequence.m
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/22.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import "RAC_Sequence.h"
#import "Flag.h"

@implementation RAC_Sequence

// RACSequence:RAC中的集合，用来操作数组和字典
// 由于RAC需要信号才能运作，需要把数组转换成RACSequence集合就好了

+ (void)getArrayElement {
    
    NSArray *array = @[@1, @2, @3, @4];
    
    // 将数组转成信号类，并获取每一个元素
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
        
        // block中都是在子线程中执行，如果需要刷新UI，要回到主线程
        NSLog(@"%@", [NSThread currentThread]);
    }];
}

// 将字典转成信号类，并获取每一个元素
+ (void)getDictionaryElement {
    NSDictionary *dict = @{@"name" : @"wangsicong", @"age" : @18, @"money" : @1000};
    
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        // 解包成元组类型
        RACTupleUnpack(NSString *key,id value) = x;
        NSLog(@"%@ -- %@",key, value);
    }];
}

+ (void)dictToModel {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
    
    // map:映射
    // mapBlock: value参数:集合  返回值:需要映射成那个值
    NSArray *itemArr = [[dictArr.rac_sequence.signal map:^id(id value) {
        return [Flag flagWithDict:value];
    }] toArray];
    
    NSLog(@"%@", itemArr);
}

@end
