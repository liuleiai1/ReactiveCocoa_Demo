//
//  RAC_Basic.h
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/20.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAC_Basic : NSObject

// 基本信号的创建和使用（RACSignal）
+ (void)createBasicSignal;

// 创建RACSubject类的信号
+ (void)createSubjectSignal;

// 创建RACReplaySubject类的信号
+ (void)createReplaySubjectSignal;

// 合并信号
+ (void)mergeSignal;

// 信号设置数据依赖
+ (void)dependecySignal;

@end
