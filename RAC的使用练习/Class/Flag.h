//
//  Flag.h
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/22.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flag : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *icon;

+ (instancetype)flagWithDict:(NSDictionary *)dict;

@end
