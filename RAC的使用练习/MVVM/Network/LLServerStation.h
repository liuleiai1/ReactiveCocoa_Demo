//
//  LLServerStation.h
//  BaiSiBuDeJie
//
//  Created by 迦南 on 2017/7/21.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLServerStation : NSObject

+ (instancetype)shareInstance;

// 取消请求
- (void)cancelLoadData;

- (void)loadDataWithSuccessBlock:(void(^)(id responseObject))successBlock errorBlock:(void(^)(NSError *error))errorBlock;


@end
