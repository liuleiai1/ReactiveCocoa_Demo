//
//  RAC_Basic.m
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/20.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import "RAC_Basic.h"

@implementation RAC_Basic

+ (void)createBasicSignal {
    // 创建信号（默认是一个冷信号）
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"执行信号block");
        
        // 发送信号
        [subscriber sendNext:@"发送信号"];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"执行信号结束,或者订阅者销毁就会调用,默认订阅者没有被强引用");
            // 只要subscriber调用sendError，sendCompleted，就会执行
            // 并且内部会把subscriber的next和Completed，error清空
            // 执行完Block后，当前信号就不在被订阅了。
        }];
    }];
    
    // 订阅信号（只有订阅了信号，才会激活信号）
    // 每次调用都会创建新的订阅者
    // 监听Next，用于传数据
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收数据 -- %@", x);
    }];
    
    //这样相当于每次创建新的订阅者,就会导致didSubscribe多次调用
    //监听错误
    [signal subscribeError:^(NSError * _Nullable error) {
        NSLog(@"接收错误");
    }];
    
    // 监听完成
    [signal subscribeCompleted:^{
        NSLog(@"接收信号完成");
    }];
    
    // 三个一起订阅
    [signal subscribeNext:^(id  _Nullable x) {
        
    } error:^(NSError * _Nullable error) {
        
    } completed:^{
        
    }];
    
    // RACSignal底层实现：
    // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
    // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
    // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
    // 2.1 subscribeNext内部会调用siganl的didSubscribe
    // 3.siganl的didSubscribe中调用[subscriber sendNext:];
    // 3.1 sendNext底层其实就是执行subscriber的nextBlock
}


+ (void)createSubjectSignal {
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收数据 -- %@", x);
    }];
    
    [subject subscribeCompleted:^{
        NSLog(@"接收信号完成");
    }];
    
    // 发送信号
    [subject sendNext:@"发送信号"];
    
    // 如果不需要订阅者，记得调用sendCompleted，把订阅者移除，否则一直存在
    // sendCompleted底层会清除所有的订阅者
    [subject sendCompleted];
    
}


+ (void)createReplaySubjectSignal {
    // 创建信号
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    // 发送信号
    [subject sendNext:@"第一次发送信号"];
    
    // 订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收数据 -- %@", x);
    }];
    
    // 发送信号
    [subject sendNext:@"第二次发送信号"];
}

+ (void)mergeSignal {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"执行信号block");
        
        // 发送信号
        [subscriber sendNext:@"发送信号A"];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"执行信号block");
        
        // 发送信号
        [subscriber sendNext:@"发送信号B"];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
        
    }];
}

+ (void)dependecySignal {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"执行信号block");
        
        // 发送信号
        [subscriber sendNext:@"发送信号A"];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"执行信号block");
        
        // 发送信号
        [subscriber sendNext:@"发送信号B"];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    // Selector:当数组所有信号都发送next
    // rac_liftSelector硬性要求:有几个信号就必须有几个参数,参数就是信号发出值
    [self rac_liftSelector:@selector(dependencyAfterSelectorWithData1:data2:) withSignalsFromArray:@[signalA, signalB]];
}

+ (void)dependencyAfterSelectorWithData1:(NSString *)data1 data2:(NSString *)data2 {
    NSLog(@"%@ -- %@", data1, data2);
}

@end
