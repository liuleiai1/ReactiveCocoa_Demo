//
//  Flag.m
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/22.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import "Flag.h"

@implementation Flag

+ (instancetype)flagWithDict:(NSDictionary *)dict {
    
    Flag *flag = [[self alloc] init];
    
    [flag setValuesForKeysWithDictionary:dict];
    
    return flag;
}

@end
