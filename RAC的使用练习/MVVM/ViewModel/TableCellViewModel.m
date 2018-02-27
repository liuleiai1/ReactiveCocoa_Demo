//
//  TableCellViewModel.m
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/27.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import "TableCellViewModel.h"
#import "TableViewCell.h"

@implementation TableCellViewModel

- (void)bindViewModel:(UIView *)bindView {
    TableViewCell *cell = (TableViewCell *)bindView;
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:_model.courseImage]];
    cell.nameView.text = _model.courseName;
    [cell.numView setTitle:_model.studentNum forState:UIControlStateNormal];
}
@end
