//
//  ViewModelProtocol.h
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/27.
//  Copyright © 2018年 迦南. All rights reserved.
//

@protocol ViewModelDelegate <NSObject>

@optional
- (void)bindViewModel:(UIView *)bindView;

@end
