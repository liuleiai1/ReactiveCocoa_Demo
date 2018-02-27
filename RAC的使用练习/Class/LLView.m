//
//  LLView.m
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/25.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import "LLView.h"

@implementation LLView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (_subject) {
        [_subject sendNext:@"点击了view"];
    }
}

@end
