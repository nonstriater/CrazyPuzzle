//
//  MyTableViewController.h
//  CrazyPuzzzle
//
//  Created by mac on 13-8-14.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTableViewCell.h"


@interface MyTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MyTableViewCellDelegate>{

    __weak IBOutlet UITableView *_tableView;
    
    

}

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSArray *productIDs;

@end
