//
//  ADPAVPlayerView.h
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AVPlayer;

@interface ADPAVPlayerView : UIView
@property (strong, nonatomic)AVPlayer *player;
@property (strong, nonatomic, readonly)AVPlayerLayer *playerLayer;
@end
