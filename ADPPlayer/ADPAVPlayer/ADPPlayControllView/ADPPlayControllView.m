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

@interface ADPPlayControllView () {
    /*
     * 用于记录拖动手势的方向
     * 由于手势的方法会进行多次调用
     * 因此对滑动方向进行记录, 一次手势结束前, 只进行一次滑动方向的判断
     */
    ADPPanGestureDirection _panGestureDirection;
}

@property(strong, nonatomic)ADPControllContainerView *topContainerView;//顶部控件容器
@property(strong, nonatomic)ADPControllContainerView *bottomContainerView;//底部控件容器
@property (strong, nonatomic, readwrite)ADPPlayPauseButton *playPauseButton;//播放暂停键
@property(strong, nonatomic)UIButton *danMuOnOffButton;//弹幕开关按钮
@property(strong, nonatomic)UIButton *danMuSettingButton;//弹幕设置
@property(strong, nonatomic)UITextField *danMuPlaceHolderFireTextField;//弹幕占位发送框
@property(strong, nonatomic)UIButton *videoQualityButton;
@end

@implementation ADPPlayControllView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
////        self.backgroundColor = [UIColor whiteColor];
//        [self addSubview:self.topContainerView];
//        [self addSubview:self.bottomContainerView];
//        [self addSubview:self.brightnessView];
//        [self addSubview:self.volumeView];
//
//
//        [self.bottomContainerView addSubview:self.playPauseButton];
//        [self.bottomContainerView addSubview:self.currentAndDurationTimeLabel];
//        [self.bottomContainerView addSubview:self.progressSlider];
//        [self setUpBaseView];
//        [self makeMasonryLayOuts];
//    }
//    return self;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.topContainerView];
        [self addSubview:self.bottomContainerView];
        [self addSubview:self.brightnessView];
        [self addSubview:self.volumeView];

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
        _brightnessView.hidden = YES;
    }
    return _brightnessView;
}

- (ADPVolumeView *)volumeView {
    if (!_volumeView) {
        _volumeView = [[ADPVolumeView alloc]init];
        _volumeView.hidden = YES;
    }
    return _volumeView;
}

- (UIButton *)danMuOnOffButton {
    if (!_danMuOnOffButton) {
        _danMuOnOffButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _danMuOnOffButton;
}

- (UIButton *)danMuSettingButton {
    if (!_danMuSettingButton) {
        _danMuSettingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _danMuSettingButton;
}

- (UITextField *)danMuPlaceHolderFireTextField {
    if (!_danMuPlaceHolderFireTextField) {
        _danMuPlaceHolderFireTextField = [[UITextField alloc]init];
    }
    return _danMuPlaceHolderFireTextField;
}

- (UIButton *)videoQualityButton {
    if (!_videoQualityButton) {
        _videoQualityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _videoQualityButton;
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
    
    [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    if (pan.state == UIGestureRecognizerStateBegan) {
        //当手势开始时记录开始point
        CGPoint point = [pan locationInView:self];
    }
    
    /*
     * 进行滑动方向的判定, 每个手势期内仅进行一次滑动方向的判定
     * 再手势状态变更为UIGestureRecognizerStateEnded时进行重置
     */
    if (_panGestureDirection == ADPPanGestureDirectionUndetermined) {
        _panGestureDirection = [self directionOfPanGesture:pan];
    }
    
    //向右向下滑动速度
    CGPoint panVel = [pan velocityInView:self];
    //滑动速度
    CGFloat velX = panVel.x;
    CGFloat velY = panVel.y;
    switch (_panGestureDirection) {
        case ADPPanGestureDirectionHorizontal:
        {
            if (pan.state == UIGestureRecognizerStateChanged) {
                //分别处理横向滑动与竖向滑动
                //直接以滑动速度作为作为滑动参考, 因为滑动速度向右滑为正, 向左滑为负, 正好作为滑动参考, 来变化进度条数值
                self.progressSlider.value += (velX/20);
                //发送值变更的消息
                [self.progressSlider sendActionsForControlEvents:UIControlEventValueChanged];
            }
            //当滑动结束时, 发送视频进度条结束events
            if (pan.state == UIGestureRecognizerStateEnded) {
                [self.progressSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        case ADPPanGestureDirectionVerticalLeftArea:
        {
            if (pan.state == UIGestureRecognizerStateChanged) {
                if (self.brightnessView.hidden) {
                    self.brightnessView.hidden = NO;
                }
                //左半部分为亮度
                self.brightnessView.progressIndicator.value += (velY/2000);
                [self.brightnessView.progressIndicator sendActionsForControlEvents:UIControlEventValueChanged];
            }
            
            if (pan.state == UIGestureRecognizerStateEnded) {
                self.brightnessView.hidden = YES;
                [self.brightnessView.progressIndicator sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
        case ADPPanGestureDirectionVerticalRightArea:
        {
            if (pan.state == UIGestureRecognizerStateChanged) {
                if (self.volumeView.hidden) {
                    self.volumeView.hidden = NO;
                }
                //左半部分为亮度
                self.volumeView.progressIndicator.value += (velY/2000);
                [self.volumeView.progressIndicator sendActionsForControlEvents:UIControlEventValueChanged];
            }
            
            if (pan.state == UIGestureRecognizerStateEnded) {
                self.volumeView.hidden = YES;
                [self.volumeView.progressIndicator sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;

        default:
            break;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed) {
        //重置拖动手势方向
        _panGestureDirection = ADPPanGestureDirectionUndetermined;
    }
}

/**
 根据滑动事件的不同类型和位置响应不同事件

 @param panGesture 拖动的当前点
 */
- (ADPPanGestureDirection)directionOfPanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint panPoint = [panGesture locationInView:self];
    //向右向下滑动速度
    CGPoint panVel = [panGesture velocityInView:self];
    
    CGFloat absX = fabs(panPoint.x);
    CGFloat absY = fabs(panPoint.y);
    
    if (MAX(absX, absY)<10) return ADPPanGestureDirectionCancel;

    CGFloat pointX = panPoint.x;

//    //差值
//    CGFloat xMinus = pointX-_panGestureStartPoint.x;
//    CGFloat yMinus = pointY-_panGestureStartPoint.y;
//    //差值绝对值
//    CGFloat absXMinus = fabs(pointX-_panGestureStartPoint.x);
//    CGFloat absYMinus = fabs(pointY-_panGestureStartPoint.y);
    //滑动速度
    CGFloat velX = panVel.x;
    CGFloat velY = panVel.y;
    CGFloat absVelX = fabs(velX);
    CGFloat absVelY = fabs(velY);
    
    if (absVelY<100) {
        //横向滑动
        return ADPPanGestureDirectionHorizontal;
//        //直接以滑动速度作为作为滑动参考, 因为滑动速度向右滑为正, 向左滑为负, 正好作为滑动参考, 来变化进度条数值
//        self.progressSlider.value += (velX/20);
//        //发送值变更的消息
//        [self.progressSlider sendActionsForControlEvents:UIControlEventValueChanged];
//
//        //当滑动结束时, 发送视频进度条结束events
//        if (panGesture.state == UIGestureRecognizerStateEnded) {
//            [self.progressSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
//        }
    } else if (absVelX<100) {
        //竖向滑动
        //判断滑动的点在视图左半部分还是右半部分
        if (pointX<(self.frame.size.width/2)) {
            return ADPPanGestureDirectionVerticalLeftArea;
//            if (self.brightnessView.hidden) {
//                self.brightnessView.hidden = NO;
//            }
//            //左半部分为亮度
//            self.brightnessView.progressIndicator.value += (velY/500);
//
//            if (panGesture.state == UIGestureRecognizerStateEnded) {
//                self.brightnessView.hidden = YES;
//            }
        } else {
            return ADPPanGestureDirectionVerticalRightArea;
//            //右半部分为音量
//            if (self.volumeView.hidden) {
//                self.volumeView.hidden = NO;
//            }
//            //左半部分为亮度
//            self.volumeView.progressIndicator.value += (velY/500);
//
//            if (panGesture.state == UIGestureRecognizerStateEnded) {
//                self.volumeView.hidden = YES;
//            }
        }
//        NSLog(@"handle:竖向滑动");
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
