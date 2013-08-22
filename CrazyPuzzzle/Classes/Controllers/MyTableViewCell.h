//
//  MyTableViewCell.h
//  CrazyPuzzzle
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyTableViewCellDelegate;
@interface MyTableViewCell : UITableViewCell

@property (nonatomic,assign) id<MyTableViewCellDelegate> delegate;

- (void)setupCellWithDict:(NSDictionary *)dict;

@end

@protocol MyTableViewCellDelegate <NSObject>

- (void)MyTableViewCell:(MyTableViewCell *)cell buyGoldClicked:(id)sender;

@end



