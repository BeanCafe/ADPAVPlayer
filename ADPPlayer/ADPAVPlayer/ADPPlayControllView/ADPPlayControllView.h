//
//  ADPPlayControllView.h
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPBaseView.h"
#import "ADPPlayPauseButton.h"
#import "ADPSlider.h"
#import "ADPBrigntnessView.h"
#import "ADPVolumeView.h"

@class ADPPlayControllView;
@protocol ADPPlayControllViewDelegate<NSObject>

/**
 播放暂停按钮点击回调

 @param controllView 控制View
 @param playPauseButton 播放暂停按钮, selected为暂停状态, 反之为播放状态
 */
- (void)controllView:(ADPPlayControllView *)controllView playPauseButtonClicked:(ADPPlayPauseButton *)playPauseButton;

@end

typedef NS_ENUM(NSUInteger, ADPPanGestureDirection) {
    ADPPanGestureDirectionUndetermined,
    ADPPanGestureDirectionHorizontal,
    ADPPanGestureDirectionVerticalLeftArea,
    ADPPanGestureDirectionVerticalRightArea,
    ADPPanGestureDirectionCancel,
};

@interface ADPPlayControllView : ADPBaseView

@property (strong, nonatomic, readonly)UIButton *playPauseButton;
@property (copy, nonatomic)NSString *currentTimeString;
@property (copy, nonatomic)NSString *durationTimeString;

@property(strong, nonatomic)UILabel *currentAndDurationTimeLabel;
@property(strong, nonatomic)ADPSlider *progressSlider;

@property(strong, nonatomic)ADPVolumeView *volumeView;
@property(strong, nonatomic)ADPBrigntnessView *brightnessView;

@property (weak, nonatomic)id<ADPPlayControllViewDelegate>delegate;
@end
