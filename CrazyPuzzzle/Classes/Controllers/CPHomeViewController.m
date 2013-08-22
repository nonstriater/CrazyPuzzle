//
//  CPHomeViewController.m
//  CrazyPuzzzle
//
//  Created by mac on 13-8-11.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import "CPHomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageAdditions.h"
#import "CPMainViewController.h"

@interface CPHomeViewController ()

- (void)musicPlay;
- (void)musicStop;

- (void) startAnimation;

@end


static AVAudioPlayer *_audioPlayer = nil;

@implementation CPHomeViewController



//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        //
//        _audioStatus = YES;    
//    }
//    
//    return self;
//
//}
//

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLevel"]){
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLevel"] intValue];
        
    }else{
        
        [USER_DEFAULT setInteger:CP_Initial_Level forKey:@"CurrentLevel"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentGolden"]){
       [[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentGolden"] intValue];
        
    }else{
        
        [USER_DEFAULT setInteger:CP_Initial_Golden forKey:@"CurrentGolden"];
    }
    
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"AudioStatus"]){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AudioStatus"];
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"AudioStatus"] boolValue]) {
        [self musicPlay];
    }
    
    [self startAnimation];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //截屏，留作动画用
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.homeScreenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private

- (void)musicPlay
{
    _musicOnBtn.hidden = YES;
    _musicOffBtn.hidden = NO;
    
    
    if (!_audioPlayer) {
        
        NSString *mfp = [[NSBundle mainBundle] pathForResource:@"bg0" ofType:@"mp3"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:mfp];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            
    }
    
    if (![_audioPlayer isPlaying]) {
        [_audioPlayer prepareToPlay];
        [_audioPlayer setVolume:0.75];
        _audioPlayer.numberOfLoops = -1;
        
        [_audioPlayer play];
    }
    

}

- (void)musicStop
{
    _musicOnBtn.hidden = NO;
    _musicOffBtn.hidden = YES;
    
    
    [_audioPlayer stop];
}

#pragma mark action

- (IBAction)startGame:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    //NSArray *twoPart = [UIImage splitImageIntoTwoParts:self.homeScreenShot orientation:0];
      
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    CPMainViewController *mainVC = [sb instantiateViewControllerWithIdentifier:@"CPMainViewController"];
    mainVC.homeScreenShot = self.homeScreenShot;
    
    [self presentModalViewController:mainVC animated:NO];
    
}


- (IBAction)openMusic:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    [self musicPlay];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AudioStatus"];
}

- (IBAction)closeMusic:(id)sender;
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    [self musicStop];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"AudioStatus"];
}

- (IBAction)feedBack:(id)sender
{
    [AudioSoundHelper playSoundWithFileName:@"mainclick" ofType:@"mp3"];
    
    [UMFeedback showFeedback:self withAppkey:CP_UMeng_App_Key];

}


#pragma mark anmimation( timer )

- (void) startAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    animation.duration = 3;
    animation.repeatCount = 99999;
    
    [_fengChe.layer addAnimation:animation forKey:@"animation1"];
    
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(shopCarFly) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    

}


- (void)shopCarFly
{
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation2.duration=5;
    animation2.repeatCount = 3;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    NSMutableArray *values = [NSMutableArray array];
    //[values addObject:[NSNumber numberWithFloat:Degrees_To_Radians(0)]];
    [values addObject:[NSNumber numberWithFloat:Degrees_To_Radians(45)]];
    [values addObject:[NSNumber numberWithFloat:Degrees_To_Radians(0)]];
    [values addObject:[NSNumber numberWithFloat:Degrees_To_Radians(-45)]];
    [values addObject:[NSNumber numberWithFloat:Degrees_To_Radians(0)]];
    [values addObject:[NSNumber numberWithFloat:Degrees_To_Radians(45)]];
    animation2.values = values;
    
    
    CGPoint oldAnchorPoint = _shopCarBtn.layer.anchorPoint;
    [_shopCarBtn.layer setAnchorPoint:CGPointMake(0.5, 0)];
    [_shopCarBtn.layer setPosition:CGPointMake(_shopCarBtn.layer.position.x + _shopCarBtn.layer.bounds.size.width * (_shopCarBtn.layer.anchorPoint.x - oldAnchorPoint.x), _shopCarBtn.layer.position.y + _shopCarBtn.layer.bounds.size.height * (_shopCarBtn.layer.anchorPoint.y - oldAnchorPoint.y))];
    
    [_shopCarBtn.layer addAnimation:animation2 forKey:@"animation"];

}


@end
