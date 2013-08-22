//
//  CPPropStoreViewController.h
//  CrazyPuzzzle
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CPPropStoreViewController : UIViewController{

    __weak IBOutlet UIImageView *_xmbLogoIV;
    __weak IBOutlet UIView *_tableView; // scrollview

    __weak IBOutlet UILabel *_promptLabel;
    __weak IBOutlet UILabel *_coinLeftLbl;
    __weak IBOutlet UILabel *_myCoinLbl;
    
    __weak IBOutlet UIButton *_goldenBtn;
    __weak IBOutlet UIButton *_tasksBtn;
    
    NSInteger _currentSelected; // 1 代表金币 2 代表任务
}

@property(strong,nonatomic) NSArray *dataSourceOfGold;
@property(strong,nonatomic) NSArray *dataSourceOfTask;

- (IBAction)closeClicked:(id)sender;

- (IBAction)openGoldenBox:(id)sender;
- (IBAction)openTasksBox:(id)sender;

@end
