//
//  ADPSlider.m
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/10.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPSlider.h"

#import "UIColor+Utils.h"
#import "ADPConfigs.h"

@implementation ADPSlider

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setThumbImage:[UIImage imageNamed:@"playSlider"] forState:UIControlStateNormal];
        [self setMinimumTrackTintColor:[UIColor colorWithHexString:ADPMainColorHexStr]];
        //系统slider颜色182, 182, 182, 调整未缓冲完成tracking轨道颜色为淡一点的颜色
        [self setMaximumTrackTintColor:[UIColor colorWithRed:182./256 green:182./256 blue:182./256 alpha:0.6]];
    }
    return self;
}

//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
//    CGSize thumbSize = CGSizeMake(20, 20);
//    return CGRectMake(bounds.origin.x, bounds.origin.y, thumbSize.width, thumbSize.height);
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
