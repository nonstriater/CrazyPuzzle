//
//  AudioSoundHelper.m
//  CrazyPuzzzle
//
//  Created by mac on 13-8-15.
//  Copyright (c) 2013年 xiaoran. All rights reserved.
//

#import "AudioSoundHelper.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AudioSoundHelper

+ (void)playSoundWithFileName:(NSString *)name ofType:(NSString *)type{
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    SystemSoundID shortSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,&shortSound);
    AudioServicesPlaySystemSound(shortSound);



}


@end
