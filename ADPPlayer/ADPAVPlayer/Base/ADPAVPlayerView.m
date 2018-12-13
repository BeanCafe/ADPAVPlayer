//
//  ADPAVPlayerView.m
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPAVPlayerView.h"

@implementation ADPAVPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return self.playerLayer.player;
}

- (void)setPlayer:(AVPlayer *)player {
    self.playerLayer.player = player;
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
