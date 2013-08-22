//
//  CPHomeViewController.h
//  CrazyPuzzzle
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UMFeedback.h"

@interface CPHomeViewController : UIViewController<UMFeedbackDataDelegate>{

    __weak IBOutlet UIButton *_musicOnBtn;
    __weak IBOutlet UIButton *_musicOffBtn;
    
    __weak IBOutlet UIButton *_shopCarBtn;
    __weak IBOutlet UIImageView *_fengChe;

    
    BOOL _audioStatus; // 1 播放 0 停止
}

@property (nonatomic,strong) UIImage *homeScreenShot;

- (IBAction)startGame:(id)sender;
- (IBAction)openMusic:(id)sender;
- (IBAction)closeMusic:(id)sender;

- (IBAction)feedBack:(id)sender;

@end
