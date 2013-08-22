//
//  CPMainViewController.h
//  CrazyPuzzzle
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface CPMainViewController : UIViewController<WXApiDelegate>{

    __weak IBOutlet UILabel *_myGoldLable;
    __weak IBOutlet UILabel *_levelLable;
    __weak IBOutlet UIImageView *_mainQustionPicIV;
    __weak IBOutlet UILabel *_promptCostLabel; /// 30 or 90
    
    __weak IBOutlet UIButton *_backBtn;
    __weak IBOutlet UIButton *_goldBtn;
    
    __weak IBOutlet UIButton *_firstBtn;
    __weak IBOutlet UIButton *_sencondBtn;
    __weak IBOutlet UIButton *_thirdBtn;
    __weak IBOutlet UIButton *_fouthBtn;
    
    __weak IBOutlet UIView *_wordsContainerView;//文字面板
    
    __weak IBOutlet UIView *_prompView;
    __weak IBOutlet UIView *_prompMaskView;
    __weak IBOutlet UIImageView *_prompBgIV;
    __weak IBOutlet UILabel *_prompTitleLabel;
    __weak IBOutlet UILabel *_prompContentLabel;
    
    
    __weak IBOutlet UIView *_shareView;
    __weak IBOutlet UIView *_shareMaskView;
    __weak IBOutlet UIImageView *_shareBgIV;
    __weak IBOutlet UILabel *_shareTitleLabel;
    __weak IBOutlet UILabel *_shareContentLabel;
    
    
    __weak IBOutlet UIView *_answerCorrectView;
    __weak IBOutlet UIView *_answerCorrectMaskView;
    __weak IBOutlet UIImageView *_answerCorrectBgIV;
    __weak IBOutlet UILabel *_answerCorrectTitleLabel;
    __weak IBOutlet UILabel *_yourRankingLabel;
    __weak IBOutlet UILabel *_yourGiftLabel;
    
    
    
    NSInteger _currentLevel;  // 当前level
    NSInteger _currentGolden; // 当前金币数量
    NSString *_currentAnswer; // 答案
    NSInteger _currentWordIndex;  // 当前应该填字的位置：1 2 3 4
    
    BOOL _isWrong;
    BOOL _answerBtnSelectWhenWrong;
    BOOL _firstPrompt;
}

@property (strong,nonatomic) NSArray *dataSource;
@property (strong,nonatomic) NSArray *words;// 不用这个，直接用字符串
@property (strong,nonatomic) NSMutableString *wordsString; //所有汉字
@property (strong,nonatomic) NSString *currentPreparedString;// 随机后，顺序显示的串
@property (strong,nonatomic) NSMutableDictionary *maps;

@property (nonatomic,strong) UIImage *homeScreenShot;

- (IBAction)promptClicked:(id)sender;
- (IBAction)promptCancle:(id)sender;
- (IBAction)needPrompt:(id)sender;

- (IBAction)back:(id)sender; // back to home

- (IBAction)shareClicked:(id)sender;
- (IBAction)shareCancle:(id)sender;
- (IBAction)toFrinedZone:(id)sender;
- (IBAction)toFrined:(id)sender;


- (IBAction)next:(id)sender;
- (IBAction)answerButtonSelected:(id)sender;

// 建立文字面板，把答案混淆在里面
- (void)setupContainerView;


@end
