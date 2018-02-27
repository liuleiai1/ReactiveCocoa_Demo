//
//  RAC_Advanced.m
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/22.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import "RAC_Advanced.h"

@implementation RAC_Advanced

+ (void)signalConnection {
    
    // 创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        // 调用connect才会调用，只调用一次
        NSLog(@"调用RACSignal");
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACMulticastConnection *connection = [signal publish];
    
    // 多次订阅信号
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    // 进行连接
    [connection connect];
}


/*
 RACCommand:处理某个事件，并且传递数据经常使用RACCommand,RACCommand就是RACMulticastConnection的封装，完全可以替代RACMulticastConnection，使用RACMulticastConnection有点麻烦
 */

// 流程：
// 1.执行execute，执行SignalBlock，返回RACSignal
// 2.创建RACMulticastConnection,
// 3.[RACMulticastConnection connect] 订阅RACSignal => RACReplaySubject
// 4.执行RACSignal的block,[RACReplaySubject sendNext]保存值
// 5.订阅RACReplaySubject，遍历值，发送出来


+ (void)signalCommand {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // 只执行一次
         NSLog(@"接收%@",input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            // 处理需要传递数据的事件
            NSLog(@"signal的block");
            
            // 传递数据
            [subscriber sendNext:@"signal"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
//    commandMethod1(command);
//    commandMethod2(command);
    commandMethod3(command);
}

// 订阅方式一
void commandMethod1(RACCommand *command) {
    // 执行命令
    RACSignal *signal = [command execute:@"Command命令"];

    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收 -- %@", x);
    }];

    [signal subscribeCompleted:^{
        NSLog(@"接收信号完成");
    }];
    
}

// 订阅方式二
void commandMethod2(RACCommand *command) {
    // 信号中的信号
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收信号中的信号 -- %@", x);
        
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"信号内容 -- %@", x);
        }];
        
        [x subscribeCompleted:^{
            NSLog(@"接收信号完成");
        }];
    }];
    
    [command execute:@"Command命令"];
}

// 订阅方式三
void commandMethod3(RACCommand *command) {
    
    // 监听命令的执行情况有没有完成
    [[command.executing skip:1] subscribeNext:^(id  _Nullable x) {

        BOOL executing = [x boolValue];

        if (executing) {
            NSLog(@"正在执行");
        } else {
            NSLog(@"执行完成");
        }
    }];
    
    
    // 直接拿到信号中的信号内容，省略信号中的信号
    // executionSignals: 信号中信号,信号发送信号
    // switchToLatest:获取最近发送的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [command execute:@"Command命令"];
    
//    注意:
//    1.RACCommand内部必须要返回signal
//    2.executionSignals 信号中信号,一开始获取不到内部信号
//    2.1 switchToLatest:获取内部信号
//    2.2 execute:获取内部信号
//    3.executing: 判断是否正在执行
//    3.1 第一次不准确,需要skip,跳过
//    3.2 一定要记得sendCompleted,否则永远不会执行完成
//    4.execute执行,执行command的block
}


+ (void)signalCommandSceneWithLoginBtn:(UIButton *)sender {
    
    // 点击按钮相当于执行了execute
    RACSubject *signal = [RACSubject subject];
    
    sender.rac_command = [[RACCommand alloc] initWithEnabled:signal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        // 只执行一次
        NSLog(@"点击按钮%@",input);
        
//        // 创建空信号,必须返回信号
//        return [RACSignal empty];
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

            // 处理需要传递数据的事件
            NSLog(@"signal的block");

            // 传递数据
            [subscriber sendNext:@"signal"];

            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendCompleted];
            });

            return nil;
        }];
    }];
   
    [sender.rac_command.executionSignals subscribeNext:^(id  _Nullable x) {
         NSLog(@"%@", x);

        [x subscribeNext:^(id  _Nullable x) {
             NSLog(@"%@", x);
        } error:^(NSError * _Nullable error) {

        } completed:^{
             NSLog(@"接收信号完成");
        }];
    }];
    
    
    [[sender.rac_command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
         // 是否允许发送信号
        // 不允许的话按钮会置灰
        BOOL executing = [x boolValue];
        [signal sendNext:@(!executing)];
    }];
}

@end
