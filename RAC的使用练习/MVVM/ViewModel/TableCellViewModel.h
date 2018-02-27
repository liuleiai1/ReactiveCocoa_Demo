//
//  TableCellViewModel.h
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/27.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModelProtocol.h"
#import "TableModel.h"

@interface TableCellViewModel : NSObject <ViewModelDelegate>

@property (nonatomic, strong) TableModel *model;
@end
