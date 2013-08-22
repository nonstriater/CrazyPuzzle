//
//  MyTableViewCell.m
//  CrazyPuzzzle
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupCellWithDict:(NSDictionary *)dict
{
    UILabel *lbl = (UILabel *)[self.contentView viewWithTag:100];
    lbl.text = dict[CP_Value_Key];
    
    
    UIButton *btn = (UIButton *)[self.contentView viewWithTag:101];
    [btn setTitle:[NSString stringWithFormat:@"￥%@",dict[CP_Price_Key]] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buyGoldClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)buyGoldClicked:(id)sender
{
    if ([_delegate respondsToSelector:@selector(MyTableViewCell:buyGoldClicked:)]) {
        [_delegate MyTableViewCell:self buyGoldClicked:sender];
    }

}

@end
