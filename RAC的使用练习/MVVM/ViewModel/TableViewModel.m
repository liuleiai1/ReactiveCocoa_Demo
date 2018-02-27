//
//  TableViewModel.m
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/27.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import "TableViewModel.h"
#import "TableCellViewModel.h"

#import "LLServerStation.h"
#import "TableModel.h"

#import "TableViewCell.h"


static NSString * const ID = @"cell";

@interface TableViewModel () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation TableViewModel

- (RACCommand *)command {
    if (!_command) {
        // 请求数据
        _command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                // 调接口
                [[LLServerStation shareInstance] loadDataWithSuccessBlock:^(id responseObject) {
                    
                    NSDictionary *result = responseObject[@"result"];
                    NSDictionary *recommendsDict = result[@"recommends"];
                    
                    // 字典转模型
                    NSArray *itemArr = [TableModel mj_objectArrayWithKeyValuesArray:recommendsDict[@"courses"]];
                    
                    self.dataArray = [[itemArr.rac_sequence.signal map:^id _Nullable(id  _Nullable value) {
                        
                        // 创建Cell视图模型
                        TableCellViewModel *cellVM = [[TableCellViewModel alloc] init];
                        cellVM.model = value;
                        return cellVM;
                        
                    }] toArray];
                    
                    // 发送信号
                    [subscriber sendNext:itemArr];
                    [subscriber sendCompleted];
                    
                } errorBlock:^(NSError *error) {
                     [subscriber sendError:error];
                }];
        
                
                return nil;
            }];
        }];
    }
    return _command;
}

#pragma mark - 视图模型绑定
- (void)bindViewModel:(UIView *)bindView {
    UITableView *tableView = (UITableView *)bindView;
    tableView.delegate = self;
    tableView.dataSource = self;
     [tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    tableView.rowHeight = 120;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    TableCellViewModel *vm = self.dataArray[indexPath.row];
    [vm bindViewModel:cell];
    
    return cell;
}

@end
