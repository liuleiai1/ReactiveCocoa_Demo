//
//  TableViewCell.h
//  RAC的使用练习
//
//  Created by 迦南 on 2018/2/27.
//  Copyright © 2018年 迦南. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic, readonly) IBOutlet UIImageView *iconView;
@property (weak, nonatomic, readonly) IBOutlet UILabel *nameView;
@property (weak, nonatomic, readonly) IBOutlet UIButton *numView;

@end
