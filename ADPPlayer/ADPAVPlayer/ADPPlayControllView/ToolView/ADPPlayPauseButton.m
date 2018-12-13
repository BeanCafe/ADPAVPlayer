//
//  ADPPlayPauseButton.m
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/7.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPPlayPauseButton.h"

@implementation ADPPlayPauseButton

/**
 根据按钮大小, 缩小button可视视图, 即播放暂停按钮图片的大小
 已达到触摸范围大, 视图显得小的目的

 @return imageView的rect
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    //到边界距离根据按钮大小调整, 默认按钮为正方形
    CGFloat padding = contentRect.size.width/4;
    
    CGFloat width = contentRect.size.width-padding*2;
    CGFloat height = contentRect.size.height-padding*2;
    CGFloat x = padding;
    CGFloat y = padding;
    return CGRectMake(x, y, width, height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
