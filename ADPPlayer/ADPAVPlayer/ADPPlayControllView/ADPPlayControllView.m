//
//  ADPPlayControllView.m
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/6.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPPlayControllView.h"

#import "ADPPlayPauseButton.h"
#import "ADPControllContainerView.h"
#import "ADPBrigntnessView.h"
#import "ADPVolumeView.h"

@interface ADPPlayControllView () {
    CGPoint _panGestureStartPoint;
}

@property(strong, nonatomic)ADPControllContainerView *topContainerView;
@property(strong, nonatomic)ADPControllContainerView *bottomContainerView;
@property (strong, nonatomic, readwrite)ADPPlayPauseButton *playPauseButton;
@property(strong, nonatomic)ADPVolumeView *volumeView;
@property(strong, nonatomic)ADPBrigntnessView *brightnessView;
@end

@implementation ADPPlayControllView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.topContainerView];
        [self addSubview:self.bottomContainerView];
        [self addSubview:self.brightnessView];
        
        [self.bottomContainerView addSubview:self.playPauseButton];
        [self.bottomContainerView addSubview:self.currentAndDurationTimeLabel];
        [self.bottomContainerView addSubview:self.progressSlider];
        [self setUpBaseView];
        [self makeMasonryLayOuts];
    }
    return self;
}

- (void)setUpBaseView {
    _currentTimeString = @"00:00";
    _durationTimeString = @"00:00";
    
    [self.playPauseButton addTarget:self action:@selector(playPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //添加滑动事件监听
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self addGestureRecognizer:pan];
}

#pragma mark - Getters

- (ADPControllContainerView *)topContainerView {
    if (!_topContainerView) {
        _topContainerView = [[ADPControllContainerView alloc]init];
    }
    return _topContainerView;
}

- (ADPControllContainerView *)bottomContainerView {
    if (!_bottomContainerView) {
        _bottomContainerView = [[ADPControllContainerView alloc]init];
    }
    return _bottomContainerView;
}

- (UILabel *)currentAndDurationTimeLabel {
    if (!_currentAndDurationTimeLabel) {
        _currentAndDurationTimeLabel = [[UILabel alloc]init];
        _currentAndDurationTimeLabel.font = [UIFont boldSystemFontOfSize:12];
        _currentAndDurationTimeLabel.textColor = [UIColor whiteColor];
        _currentAndDurationTimeLabel.text = @"00:09/26:88";
    }
    return _currentAndDurationTimeLabel;
}

- (ADPPlayPauseButton *)playPauseButton {
    if (!_playPauseButton) {
        _playPauseButton = [ADPPlayPauseButton buttonWithType:UIButtonTypeCustom];
        _playPauseButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_playPauseButton setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
        [_playPauseButton setImage:[UIImage imageNamed:@"pause-button"] forState:UIControlStateSelected];
//        _playPauseButton.backgroundColor = [UIColor grayColor];
    }
    return _playPauseButton;
}

- (ADPSlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[ADPSlider alloc]init];
    }
    return _progressSlider;
}

- (ADPBrigntnessView *)brightnessView {
    if (!_brightnessView) {
        _brightnessView = [[ADPBrigntnessView alloc]init];
    }
    return _brightnessView;
}

- (ADPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[ADPVolumeView alloc]init];
    }
    return _volumeView;
}

#pragma mark - Setters

- (void)setCurrentTimeString:(NSString *)currentTimeString {
    _currentTimeString = currentTimeString;
    [self newCurrentTimeInDisplayLabel:currentTimeString];
}

- (void)setDurationTimeString:(NSString *)durationTimeString {
    _durationTimeString = durationTimeString;
    [self newDurationTimeInDisplayLabel:durationTimeString];
}

#pragma mark - PrivateMethod

- (void)makeMasonryLayOuts {
    [_topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(64);
    }];

    [_bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(64);
    }];
    
    [_playPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomContainerView.mas_left);
        make.bottom.mas_equalTo(self.bottomContainerView.mas_bottom);
        
        CGFloat buttonSize = 40.f;
        make.width.mas_equalTo(buttonSize);
        make.height.mas_equalTo(buttonSize);
    }];
    
    [_currentAndDurationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playPauseButton.mas_right);
        make.centerY.mas_equalTo(self.playPauseButton.mas_centerY);
        
        make.height.mas_equalTo(12);
    }];
    
    [_progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.playPauseButton.mas_top);
    }];
    
    [_brightnessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(44);
    }];
}

- (void)newCurrentTimeInDisplayLabel:(NSString *)currentTime {
    self.currentAndDurationTimeLabel.text = [NSString stringWithFormat:@"%@/%@", currentTime, self.durationTimeString];
}

- (void)newDurationTimeInDisplayLabel:(NSString *)durationTime {
    self.currentAndDurationTimeLabel.text = [NSString stringWithFormat:@"%@/%@", self.currentTimeString, durationTime];
}

#pragma mark - Actions

- (void)playPauseButtonAction:(ADPPlayPauseButton *)button {
    if ([self.delegate respondsToSelector:@selector(controllView:playPauseButtonClicked:)]) {
        [self.delegate controllView:self playPauseButtonClicked:button];
    }
    button.selected = !button.selected;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self];
    NSLog(@"location:x:%f, location:y:%f", point.x, point.y);
    if (pan.state == UIGestureRecognizerStateBegan) {
        _panGestureStartPoint = point;
    }
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed) {
        _panGestureStartPoint = CGPointZero;
    }
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self handleAffairAccordingToPanTypeWithPanGesture:pan];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        //当滑动结束时发送结束events
        [self.progressSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 根据滑动事件的不同类型和位置响应不同事件

 @param panGesture 拖动的当前点
 */
- (ADPPanGestureDirection)handleAffairAccordingToPanTypeWithPanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint panPoint = [panGesture locationInView:self];
    //向右向下滑动速度
    CGPoint panVel = [panGesture velocityInView:self];
    
    CGFloat absX = fabs(panPoint.x);
    CGFloat absY = fabs(panPoint.y);
    
    if (MAX(absX, absY)<10) return ADPPanGestureDirectionCancel;

    CGFloat pointX = panPoint.x;
    CGFloat pointY = panPoint.y;

    //差值
    CGFloat xMinus = pointX-_panGestureStartPoint.x;
    CGFloat yMinus = pointY-_panGestureStartPoint.y;
    //差值绝对值
    CGFloat absXMinus = fabs(pointX-_panGestureStartPoint.x);
    CGFloat absYMinus = fabs(pointY-_panGestureStartPoint.y);
    //滑动速度
    CGFloat velX = panVel.x;
    CGFloat velY = panVel.y;
    
    if (absYMinus<60) {
        //直接以滑动速度作为作为滑动参考, 因为滑动速度向右滑为正, 向左滑为负, 正好作为滑动参考, 来变化进度条数值
        self.progressSlider.value += (velX/20);
        [self.progressSlider sendActionsForControlEvents:UIControlEventValueChanged];
    } else if (absXMinus<30) {
        //竖向滑动
        
        NSLog(@"handle:竖向滑动");
        if (yMinus<0) {
            NSLog(@"handle:向上滑动");
        } else {
            NSLog(@"handle:向下滑动");
        }
    }
    return ADPPanGestureDirectionCancel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
