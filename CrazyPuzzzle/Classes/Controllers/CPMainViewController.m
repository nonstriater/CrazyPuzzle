//
//  CPMainViewController.m
//  CrazyPuzzzle
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import "CPMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageAdditions.h"


#define CP_Question_Key @"question"
#define CP_Answer_Key @"answer"
#define CP_Explain_Key @"explain"
#define CP_OriginOfIdioms @"originOfIdioms"

#define CP_Words_Container_Width 300
#define CP_Words_Container_Margin 5
#define CP_Words_Container_Colomes 8
#define CP_Words_Container_Rows 3
#define CP_Word_Cell_Margin 4
#define CP_Word_Cell_Size (CP_Words_Container_Width-CP_Words_Container_Margin*2-CP_Word_Cell_Margin*(CP_Words_Container_Colomes-1))/CP_Words_Container_Colomes
#define CP_Scale_Factor 1.2
#define CP_Words_Container_Height  CP_Words_Container_Margin*2 + CP_Word_Cell_Margin*(CP_Words_Container_Rows-1)+CP_Word_Cell_Size*CP_Words_Container_Rows

#define CP_Answer_Button_Tag_Offset 1000
#define CP_Word_Button_Tag_Offset 10000

#define CP_Up_Imageview_Tag 222
#define CP_Down_Imageview_Tag 333


#define degree(x) x * M_PI / 180


#define CP_ShareView_Animation_Duration 0.6







const static NSString *_globalWordsString = @"寿 弄 麦 形 进 戒 吞 远 违 运 扶 抚 坛 技 坏 扰 拒 找 批 扯 址 走 抄 坝 贡 攻 赤 折 抓 扮 抢 孝 均 抛 投 坟 抗 坑 坊 抖 护 壳 志 扭 块 声 把 报 却 劫 芽 花 芹 芬 苍 芳 严 芦 劳 克 苏 杆 杠 杜 材 村 杏 极 李 杨 求 更 束 豆 两 丽 医 辰 励 否 还 歼 来 连 步 坚 旱 盯 呈 时 吴 助 县 里 呆 园 旷 围 呀 吨 足 邮 男 困 吵 串 员 听 吩 吹 呜 吧 吼 别 岗 帐 财 针 钉 告 我 乱 利 秃 秀 私 每 兵 估 体 何 但 伸 作 伯 伶 佣 低 你 住 位 伴 身 皂 佛 近 彻 役 返 余 希 坐 谷 妥 含 邻 岔 肝 肚 肠 龟 免 狂 犹 角 删 条 卵 岛 迎 饭 饮 系 言 冻 状 亩 况 床 库 疗 应 冷 这 序 辛 弃 冶 忘 闲 间 闷 判 灶 灿 弟 汪 沙 汽 沃 泛 沟 没 沈 沉 怀 忧 快 完 宋 宏 牢 究 穷 灾 良 证 启 评 补 初 社 识 诉 诊 词 译 君 灵 即 层 尿 尾 迟 局 改 张 忌 际 陆 阿 陈 阻 附 妙 妖 妨 努 忍 劲 鸡 驱 纯 纱 纳 纲 驳 纵 纷 纸 纹 纺 驴 纽";





@interface CPMainViewController ()

- (void)showPrompView;
- (void)hidePrompView;
- (void)hideShareView;
- (void)showShareView;

- (UIImage *)getSharedImage;

@end

@implementation CPMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLevel"]){
        _currentLevel = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLevel"] intValue];
    
    }else{
        _currentLevel = CP_Initial_Level;
        [USER_DEFAULT setInteger:CP_Initial_Level forKey:@"CurrentLevel"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentGolden"]){
        _currentGolden = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentGolden"] intValue];
        
    }else{
        _currentGolden = CP_Initial_Golden;
        [USER_DEFAULT setInteger:CP_Initial_Golden forKey:@"CurrentGolden"];
    }
    
    _currentWordIndex = 0;
    _isWrong = NO;
    _answerBtnSelectWhenWrong = NO;
    _firstPrompt = YES;
    self.maps = [NSMutableDictionary dictionary];
    
    NSString *file = [MAIN_BUDDLE pathForResource:@"question" ofType:@"plist"];
    NSArray * array = [NSArray arrayWithContentsOfFile:file];
    if([array[_currentLevel] isKindOfClass:[NSDictionary class]]){
        
        _currentAnswer = [array[_currentLevel-1] objectForKey:CP_Answer_Key];
    
    }

    assert(_currentAnswer != nil);
    
    _levelLable.text = [NSString stringWithFormat:@"Level:%d",_currentLevel];
    NSString *imgName = [NSString stringWithFormat:@"question%d",[[array[_currentLevel-1] objectForKey:CP_Question_Key] intValue]];
    _mainQustionPicIV.image = [UIImage imageNamed:imgName];
    _myGoldLable.text = [NSString stringWithFormat:@"%d",_currentGolden];
    
      
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePrompView)];
    [_prompMaskView addGestureRecognizer:tap];
    UIEdgeInsets edge = UIEdgeInsetsMake(48, 20, 30, 20);
    _prompBgIV.image = [[UIImage imageNamed:@"guess_msgbox_bg"] resizableImageWithCapInsets:edge];
    _prompTitleLabel.text = @"提示";
    //_prompContentLabel.text = [USER_DEFAULT objectForKey:@"MyGoldenScore" ]>= ? :@"没有足够的道具，前往小卖部购买？";
    _prompView.hidden = YES;
    
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView)];
    [_shareMaskView addGestureRecognizer:tap2];
    _shareBgIV.image = [[UIImage imageNamed:@"guess_msgbox_bg"] resizableImageWithCapInsets:edge];
    _shareTitleLabel.text = @"去微信求助";
    _shareContentLabel.text = [NSString stringWithFormat:@"今天首次分享到朋友圈赠送%d金币",CP_Gift_For_Share_To_FriendZone];
    _shareView.hidden = YES;
    [_shareView setFrame:CGRectMake(0, _shareView.frame.origin.y+APP_SCREEN_CONTENT_HEIGHT, _shareView.frame.size.width, _shareView.frame.size.height)];
    
    
    _answerCorrectBgIV.image = [[UIImage imageNamed:@"guess_msgbox_bg"] resizableImageWithCapInsets:edge];
    _yourGiftLabel.text = [NSString stringWithFormat:@"+ %d",CP_Gift_Per_Idioms];
    _yourRankingLabel.text = [NSString stringWithFormat:@"您击败了%d%%的玩家",CP_Lose_To_You];
    _answerCorrectView.hidden = YES;
    [_answerCorrectView setFrame:CGRectMake(0, _answerCorrectView.frame.origin.y+APP_SCREEN_CONTENT_HEIGHT, _answerCorrectView.frame.size.width, _answerCorrectView.frame.size.height)];
    
    // 设置混淆文字self.words
    [self setupWordsString];
    
    [self setPromptCostLabel];
    
    //[self setupContainerView];

    
    self.dataSource = array;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePaidForGoldNotification) name:kCPPaidForGoldsNotificatioin object:nil];
    
    // 动画打开
    [self showAnimating];
    
}

- (void)showAnimating
{
    NSArray *twoParts = [UIImage splitImageIntoTwoParts:self.homeScreenShot orientations:0];
    
    UIImageView *upIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, APP_SCREEN_CONTENT_HEIGHT/2)];
    //upIV.backgroundColor = [UIColor yellowColor];
    upIV.image = twoParts[0];
    upIV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    upIV.tag = CP_Up_Imageview_Tag;
    [self.view addSubview:upIV];
    
    UIImageView *downIV = [[UIImageView alloc] initWithFrame:CGRectMake(0,APP_SCREEN_CONTENT_HEIGHT/2 , 320, APP_SCREEN_CONTENT_HEIGHT/2)];
    downIV.image = twoParts[1];
    //downIV.backgroundColor = [UIColor redColor];
    downIV.tag = CP_Down_Imageview_Tag;
    downIV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:downIV];
    
    [UIView animateWithDuration:0.75 animations:^{
    
        [upIV setFrame:CGRectMake(0,-(APP_SCREEN_CONTENT_HEIGHT/2) , 320, APP_SCREEN_CONTENT_HEIGHT/2)];
        upIV.alpha = 0.0;
        [downIV setFrame:CGRectMake(0, (APP_SCREEN_CONTENT_HEIGHT/2)*2, 320, APP_SCREEN_CONTENT_HEIGHT/2)];
        downIV.alpha = 0.0;
        
    
    } completion:^(BOOL finished){
    
        [self setupContainerView];
        
            
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark handle notification

- (void)handlePaidForGoldNotification:(NSNotification *)notification
{
    _myGoldLable.text = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"CurrentGolden"]];
}




#pragma mark privates

// 建立文字面板，把答案混淆在里面 3x8
- (void)setupContainerView
{
    [_wordsContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    int count = CP_Words_Container_Colomes*CP_Words_Container_Rows;
    
    //prepare the  24 words
    NSInteger totalWordsCount = [self.wordsString length];
    NSMutableString *prepareWords = [NSMutableString string];
    for (int j=0; j< count - 4; j++) {
        NSString *aWord = [self.wordsString substringWithRange:NSMakeRange(rand()%totalWordsCount, 1)];
        [prepareWords appendString:aWord];
    }
    [prepareWords appendString:_currentAnswer]; // 这样一共24个汉字
    
    NSMutableString *str = [NSMutableString stringWithString:prepareWords];
    NSMutableString *s = [NSMutableString string];
    for(int i=0; i< count ; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"word.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"word_press.png"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i+CP_Word_Button_Tag_Offset;
        [btn addTarget:self action:@selector(wordButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(wordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(wordButtonTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        [btn addTarget:self action:@selector(wordButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        
        // set btn text 4 + 3*8-4  随机选一个，然后去掉
        SLog(@"%@",str);
        
        NSRange selectedRange = NSMakeRange(rand()%[str length], 1);
        NSString *aWord = [str substringWithRange:selectedRange];
        [btn setTitle:aWord forState:UIControlStateNormal];
        [str replaceCharactersInRange:selectedRange withString:@""];
        
        [s appendString:aWord];
        
        // set btn frame
        
        CGFloat x = i%CP_Words_Container_Colomes*(CP_Word_Cell_Size+CP_Word_Cell_Margin) +CP_Words_Container_Margin;
        CGFloat y = (i/CP_Words_Container_Colomes)*(CP_Word_Cell_Size+CP_Word_Cell_Margin) + CP_Words_Container_Margin;
        
        [btn setFrame:CGRectMake(-CP_Word_Cell_Size, y, CP_Word_Cell_Size, CP_Word_Cell_Size)];
        [_wordsContainerView addSubview:btn];
        [_wordsContainerView setFrame:CGRectMake(_wordsContainerView.frame.origin.x, _wordsContainerView.frame.origin.y, _wordsContainerView.frame.size.width, CP_Words_Container_Height)];
        
        [UIView animateWithDuration:1.0 animations:^{
            
            [btn setFrame:CGRectMake(x, y, CP_Word_Cell_Size*CP_Scale_Factor, CP_Word_Cell_Size*CP_Scale_Factor)];
            
        } completion:^(BOOL finished){
            
            if (finished) {
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    [btn setFrame:CGRectMake(x, y, CP_Word_Cell_Size, CP_Word_Cell_Size)];
                    
                    
                } completion:^(BOOL finished){
                    
                    
                    
                }];
                
            }
            
        }];
        
        
    }
    
    // record this round of wordsStirng
    self.currentPreparedString = s;
    
}


///
- (void)setupWordsString{

//    NSString *file = [MAIN_BUDDLE pathForResource:@"words-test" ofType:@"strings"];
//    NSMutableString *rawStr = [[NSMutableString alloc] initWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
    //去掉空格和换行
//    [rawStr replaceOccurrencesOfString:@" " withString:@"" options:nil range:nil];
//    [rawStr replaceOccurrencesOfString:@"\n" withString:@"" options:nil range:nil];
    
    //self.words = [_wordsString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    
    NSMutableString *words = [NSMutableString stringWithString:_globalWordsString];
    [words replaceOccurrencesOfString:@" " withString:@"" options:1 range:NSMakeRange(0, [words length]-1)];//过滤空格
    
     
    self.wordsString = words;
}


- (void)setPromptCostLabel
{
    _promptCostLabel.text = [NSString stringWithFormat:@"%d",_firstPrompt?CP_First_Prompt_Cost:CP_NoFirst_Prompt_Cost];
}


- (void)showPrompView{

    _prompContentLabel.text = [[USER_DEFAULT objectForKey:@"CurrentGolden"] intValue]>=[_promptCostLabel.text intValue]? [NSString stringWithFormat:@"确认花掉%d金币获取一个文字提示?",_firstPrompt?CP_First_Prompt_Cost:CP_NoFirst_Prompt_Cost] : @"没有足够的道具，前往小卖部购买？";

}

- (void)hidePrompView{

    _prompView.hidden = YES;
}


- (BOOL)checkAnswer
{
    NSMutableString *yourAnswer = [NSMutableString string];
    for (int i=0; i<4; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:(i+CP_Answer_Button_Tag_Offset)];
        assert(btn.titleLabel.text);
        [yourAnswer appendString:btn.titleLabel.text];
    }
    

    if([self checkAnswerWithYourAnswer:yourAnswer]){
        [self youAreRight];
    }else{
    
        [self youAreWrong];
    }

    return YES;


}

- (BOOL)checkAnswerWithYourAnswer:(NSString *)yourAnswer{
    
    return [_currentAnswer isEqualToString:yourAnswer];
    
}

- (void)youAreWrong
{
    SLog(@"you are wrong");
    
    _isWrong = YES;
       
    for (int i=0; i<4; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:(i+CP_Answer_Button_Tag_Offset)];
        
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z" ];
        animation.duration = 0.25;
        animation.repeatCount = 4;
        
        float rand = (float)random();
        [animation setBeginTime:CACurrentMediaTime() + rand * .0000000001];
        
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSNumber numberWithFloat:degree(-4)]];
        [values addObject:[NSNumber numberWithFloat:degree(4)]];
        [values addObject:[NSNumber numberWithFloat:degree(-4)]];
        
        animation.values=values;
        [btn.layer addAnimation:animation forKey:nil];
        
        
        [UIView animateWithDuration:0.75 animations:^{
        
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        } completion:^(BOOL finished){
        
        
        }];
        
    }
    

}

- (void)youAreRight
{
    SLog(@"you are right");
    
    _currentWordIndex = 0;
   
    // 奖励玩家
    int currentGold = [_myGoldLable.text intValue] + CP_Gift_Per_Idioms;
    _myGoldLable.text = [NSString stringWithFormat:@"%d",currentGold];
    [USER_DEFAULT setInteger:currentGold forKey:@"CurrentGolden"];
    
    
    
    [UIView animateWithDuration:0.75 animations:^{
    
        [_answerCorrectView setFrame:CGRectMake(0, _answerCorrectView.frame.origin.y-APP_SCREEN_CONTENT_HEIGHT, _answerCorrectView.frame.size.width, _answerCorrectView.frame.size.height)];
         _answerCorrectView.hidden = NO;
        _answerCorrectView.alpha = 1;
        
    } completion:^(BOOL finished){
        
    
    }];
}

- (UIImage *)getSharedImage{
    
    NSString *oldStr = _levelLable.text;
    
    _levelLable.text = @"帮我猜猜这张图代表什么成语？";
    
    _myGoldLable.hidden = YES;
    _backBtn.hidden = YES;
    _goldBtn.hidden = YES;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //还原self.view
    _levelLable.text = oldStr;
    _myGoldLable.hidden = NO;
    _backBtn.hidden = NO;
    _goldBtn.hidden = NO;
    
    return aImage;
}



#pragma mark actions


- (IBAction)back:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    /// 先完成动画，再back to home
    
    UIImageView *upIV = (UIImageView *)[self.view viewWithTag:CP_Up_Imageview_Tag];
    UIImageView *downIV = (UIImageView *)[self.view viewWithTag:CP_Down_Imageview_Tag];
    
    
    [UIView animateWithDuration:0.75 animations:^{
        
        [upIV setFrame:CGRectMake(0, 0, 320, APP_SCREEN_CONTENT_HEIGHT/2)];
        upIV.alpha = 1.0;
        [downIV setFrame:CGRectMake(0,APP_SCREEN_CONTENT_HEIGHT/2 , 320, APP_SCREEN_CONTENT_HEIGHT/2)];
        downIV.alpha = 1.0;
        
        
    } completion:^(BOOL finished){
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        CPMainViewController *homeVC = [sb instantiateViewControllerWithIdentifier:@"CPHomeViewController"];
        
        [self presentModalViewController:homeVC animated:NO];
             
    }];
    
}



// golden 够就提示，不够就去商店
- (IBAction)needPrompt:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    if([[USER_DEFAULT objectForKey:@"CurrentGolden"] intValue]>=[_promptCostLabel.text intValue]){
        /// 随便挑成语中的一个字提示，并扣积分(xxxx 还不是这样，要提示没有的单词)
        
        // 找到提示的单词，且 第二次提示90分（第一次30）
        //如果是在isWrong=YES的情况下，那就先清空answer button
        //如果用户在输入若干单词后寻要提示，我这边的处理是提示用户还没有出入位置的单词( 这个规则可能会改 )
        if (_isWrong) {
            for (int i=0; i<4; i++) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:(i+CP_Answer_Button_Tag_Offset)];
                [btn setTitle:nil forState:UIControlStateNormal];
                btn.titleLabel.text = nil;
            }
            _isWrong = NO;

        }
        //把还没有填词的btn 的tag装入array（)
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<4; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:(i+CP_Answer_Button_Tag_Offset)];
            if ([btn.titleLabel.text length] == 0) {
                [array addObject:[NSNumber numberWithInt:btn.tag]];
                
            }   
        }
        assert([array count] != 0);
        NSUInteger i = rand()%[array count];
        //通过i确定需要提示的单词
        NSString *prompt = [_currentAnswer substringWithRange:NSMakeRange([array[i] intValue]-CP_Answer_Button_Tag_Offset, 1)];
        UIView *unknown = [self.view viewWithTag:([array[i] intValue]) ];
        if ([unknown isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)unknown;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:prompt forState:UIControlStateNormal];
        }
        
        // 通过这个 prompt 单词 找到在container view 的位置，隐藏word btn， 设置maps
        NSRange range = [self.currentPreparedString rangeOfString:prompt];
        UIButton *wordBtn = (UIButton *)[_wordsContainerView viewWithTag:(range.location + CP_Word_Button_Tag_Offset)];
        wordBtn.hidden = YES;
        self.maps[[NSString stringWithFormat:@"%d",([array[i] intValue]-CP_Answer_Button_Tag_Offset)]] = [NSString stringWithFormat:@"%d",(range.location + CP_Word_Button_Tag_Offset)];
        
        
        if ([array count] == 1) { // 本轮提示后，成语完成，需要进入check模式
            
            [self checkAnswer];
            
            
        }
        
        
        if (_firstPrompt) {
            _currentGolden-=CP_First_Prompt_Cost;
            _firstPrompt = NO;
            
            //
            [self setPromptCostLabel];
            
            
        }else{// 这是第二次提示了
        
            _currentGolden-=CP_NoFirst_Prompt_Cost;
        
        }
        
        
        _myGoldLable.text = [NSString stringWithFormat:@"%d",_currentGolden];;
        [USER_DEFAULT setInteger:_currentGolden forKey:@"CurrentGolden"];
        [self hidePrompView];
        
        
    }else{// 跳到商店
    
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        [self presentViewController:[storyBoard instantiateViewControllerWithIdentifier:@"CPPropStoreViewController"] animated:NO completion:nil];
        
    }
    
}



//动画
- (void)hideShareView{
    
    [UIView animateWithDuration:CP_ShareView_Animation_Duration animations:^{
        
        [_shareView setFrame:CGRectMake(0, _shareView.frame.origin.y+APP_SCREEN_CONTENT_HEIGHT, _shareView.frame.size.width, _shareView.frame.size.height)];
        
        
    } completion:^(BOOL finished){
        _shareView.hidden = YES;
        
    }];

        
}

- (void)showShareView{
   
    
    [UIView animateWithDuration:CP_ShareView_Animation_Duration animations:^{
        
        [_shareView setFrame:CGRectMake(0, _shareView.frame.origin.y-APP_SCREEN_CONTENT_HEIGHT, _shareView.frame.size.width, _shareView.frame.size.height)];
        _shareView.hidden = NO;
        
    } completion:^(BOOL finished){
        
        
    }];

}



- (IBAction)promptClicked:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    _prompView.hidden = NO;
    [self showPrompView];

}

- (IBAction)promptCancle:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    [self hidePrompView];

}


- (IBAction)shareClicked:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    [self showShareView];

}

- (IBAction)shareCancle:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    [self hideShareView];

}

// 去朋友圈
- (IBAction)toFrinedZone:(id)sender
{
   // NSString *imgName = [NSString stringWithFormat:@"question%d",[[_dataSource[_currentLevel-1] objectForKey:CP_Question_Key] intValue]];
    _shareView.hidden = YES;
    
    // 截屏 ， 拼图
    UIImage *img = [self getSharedImage];
    UIImage *thumbImg = [UIImage scaleAspect:img toSize:CGSizeMake(140, 240)];
    
    WXMediaMessage *msg = [WXMediaMessage message];
    [msg setThumbImage:thumbImg];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(img);// 截屏图片要保存为png格式
    
    msg.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText=NO; //表示多媒体消息
    req.scene = WXSceneTimeline; // 不填，或WXSceneSession 将发给朋友
    req.message = msg;
    
    // 跳到微信页面
    if([WXApi sendReq:req]){
        SLog(@"jump to wx");
    }else{
    
        assert(0);
    }
    
}

// 分享给某个好友
- (IBAction)toFrined:(id)sender
{
     _shareView.hidden = YES;
    
    UIImage *img = [self getSharedImage];
    UIImage *thumbImg = [UIImage scaleAspect:img toSize:CGSizeMake(120, 180)];
    
    
    WXMediaMessage *msg = [WXMediaMessage message];
    [msg setThumbImage:thumbImg];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(img);// 截屏图片要保存为png格式
    
    msg.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText=NO; //表示多媒体消息
    req.message = msg;
    //req.scene = WXSceneTimeline; // 不填，或WXSceneSession 将发给朋友
    
    
    [WXApi sendReq:req];// 跳到微信页面

}

// weixin delegate

- (void)onReq:(BaseReq *)req
{

}

- (void)onResp:(BaseResp *)resp
{

}




- (IBAction)next:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    [UIView animateWithDuration:0.75 animations:^{
        
        [_answerCorrectView setFrame:CGRectMake(0, _answerCorrectView.frame.origin.y+APP_SCREEN_CONTENT_HEIGHT, _answerCorrectView.frame.size.width, _answerCorrectView.frame.size.height)];
        
        
    } completion:^(BOOL finished){
        _answerCorrectView.hidden = YES;
        
    }];
    
    // 配置好下一题的环境(下面的内容可以放在一个单独的函数中，与viewdidload中的复用)
    _currentLevel ++;
    
    if (_currentLevel > [self.dataSource count]) {//
        
        SLog(@"这已经是最后一关！");
        return;
        
        
    }
    [USER_DEFAULT setInteger:_currentLevel forKey:@"CurrentLevel"];
    _levelLable.text = [NSString stringWithFormat:@"Level:%d",_currentLevel];
    
    _currentAnswer = [self.dataSource[_currentLevel-1] objectForKey:CP_Answer_Key];
    NSString *imgName = [NSString stringWithFormat:@"question%d",[[self.dataSource[_currentLevel-1] objectForKey:CP_Question_Key] intValue]];
    _mainQustionPicIV.image = [UIImage imageNamed:imgName];
    
    _currentWordIndex = 0;
     self.maps = [NSMutableDictionary dictionary];
    
    for (int i=0; i<4; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:(i+CP_Answer_Button_Tag_Offset)];
        [btn setTitle:nil forState:UIControlStateNormal];
        btn.titleLabel.text = nil;
    }
    
    _firstPrompt = YES;
    [self setPromptCostLabel];
    
    [self setupContainerView];
    
    
}

- (IBAction)answerButtonSelected:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    UIButton *btn = (UIButton *)sender;
    
    if (_isWrong) {
        for (int i=0; i<4; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:(i+CP_Answer_Button_Tag_Offset)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        //_currentWordIndex = btn.tag - CP_Answer_Button_Tag_Offset;
        _answerBtnSelectWhenWrong = YES;
    }
    
    
    if([btn.titleLabel.text length]>0){
        [btn setTitle:nil forState:UIControlStateNormal];
        btn.titleLabel.text = nil;
        
        // tell word btn 显示出来
        int targetTag = [[self.maps objectForKey:[NSString stringWithFormat:@"%d",(btn.tag-CP_Answer_Button_Tag_Offset)]] intValue];
        UIButton *wordBtn = (UIButton *)[_wordsContainerView viewWithTag:targetTag];
        wordBtn.hidden = NO;
        

        // cal _currentWordIndex
        if(_currentWordIndex > (btn.tag - CP_Answer_Button_Tag_Offset))
            _currentWordIndex = btn.tag - CP_Answer_Button_Tag_Offset;
    }

}

- (void)wordButtonSelected:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    //
    if (_isWrong) {
        if (!_answerBtnSelectWhenWrong) {
            for (int i=0; i<4; i++) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:(i+CP_Answer_Button_Tag_Offset)];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setTitle:nil forState:UIControlStateNormal];
                btn.titleLabel.text = nil; //加这一句
                
                //对应的 word button 显示出来
                int targetWordTag = [self.maps[[NSString stringWithFormat:@"%d",(btn.tag - CP_Answer_Button_Tag_Offset)]] intValue];
                [_wordsContainerView viewWithTag:targetWordTag].hidden = NO;
                
            }
           
            _currentWordIndex = 0;
        }
        _answerBtnSelectWhenWrong = NO;
        _isWrong = NO;
    }
    
    UIButton *btn = (UIButton *)sender;
    NSString *text = btn.titleLabel.text;
    
        
    // set answer button
    
    UIView *unkonw = [self.view viewWithTag:(_currentWordIndex+CP_Answer_Button_Tag_Offset)];
    if ([unkonw isKindOfClass:[UIButton class]]) {
        UIButton *answerBtn = (UIButton *)unkonw;
        [answerBtn setTitle:text forState:UIControlStateNormal];
    }
    
    
    // remove the selected word button
    
    // word 选中后就从contain中消失,但要记得点 answer btn 时还要放回来
    // 要记录每个字从哪个word btn来,通过tag来标记：如{0:1,1:3,2:12,3:21}
    // 因此，使用字典来记录就行了(self.maps)
    //
    btn.hidden = YES;
    [self.maps setObject:[NSString stringWithFormat:@"%d",btn.tag] forKey:[NSString stringWithFormat:@"%d",_currentWordIndex]];

    // 这是揭晓答案的时刻
    if (_currentWordIndex == 3) { 
        
        [self checkAnswer];
        return;
        
    }
    
    // cal _currentWordInex:
    
    while (_currentWordIndex !=3) { // 当前填的字不是最后一个，看下后面的字是否已经填了
     
        _currentWordIndex++;
        UIButton *ab = nil;
        UIView *uk = [self.view viewWithTag:(_currentWordIndex+CP_Answer_Button_Tag_Offset)];
        if([uk isKindOfClass:[UIButton class]]) {
            ab = (UIButton *)uk;               
        }
        if([ab.titleLabel.text length]==0) return;
        else{
            if (_currentWordIndex == 3) {//check answer
                
                [self checkAnswer];
                return;
            }
        }
    }
  
    
}



- (void)wordButtonTouchDown:(id)sender
{
//    UIButton *btn = (UIButton *)sender;
//    
//    [UIView animateWithDuration:0.2 animations:^{
//    
//        btn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
//        
//        
//    } completion:^(BOOL finished){
//    
//        btn.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2/3, 2/3);
//    }];

}


- (void)wordButtonTouchCancel:(id)sender{

    
}


- (void)wordButtonTouchUpOutside:(id)sender{
    
}




@end
