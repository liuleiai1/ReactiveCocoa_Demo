//
//  TableViewController.m
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/27.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewModel.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 订阅信号
    TableViewModel *model = [[TableViewModel alloc] init];
    
    @weakify(self);
    [[model.command execute:nil] subscribeNext:^(NSArray *dataArray) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [model bindViewModel:self.tableView];

}

@end
