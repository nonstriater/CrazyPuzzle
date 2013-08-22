//
//  MyTableViewController.m
//  CrazyPuzzzle
//
//  Created by mac on 13-8-14.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import "MyTableViewController.h"
#import "CPIAPStoreManager.h"
#import "MyTableViewCell.h"




@interface MyTableViewController ()

@end

@implementation MyTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.productIDs = CP_Golden_ProductIDs;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 88;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"Cell";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    int row = indexPath.row;
    NSDictionary *dict = _dataSource[row];
    
    [cell setupCellWithDict:dict];
    
    
    
    return cell;
    
}




#pragma mark actions
/// 购买 金币
- (void)MyTableViewCell:(MyTableViewCell *)cell buyGoldClicked:(id)sender{
    
    
    NSInteger row = [_tableView indexPathForCell:cell].row;
    //NSString *price = _dataSource[row][CP_Price_Key];
    [[CPIAPStoreManager shareManager] buyProduct:self.productIDs[row]];
    
    
}




@end
