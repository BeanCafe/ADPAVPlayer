//
//  ADPPlayerViewController.m
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/4.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPPlayerViewController.h"

#import "ADPPlayControllView.h"
#import "ADPAVPlayerView.h"

NSString* const ADPPlayerPlayItemDurationKey = @"player.currentItem.duration";

@interface ADPPlayerViewController ()<ADPPlayControllViewDelegate> {
    id _timePlayObservingToken;
}

@property(strong, nonatomic)AVPlayer *player;
@property(strong, nonatomic)AVPlayerViewController *playerViewController;
@property(strong, nonatomic)AVPlayerItem *playSAOItem;
@property(strong, nonatomic)AVPlayerLayer *playLayer;

@property(strong, nonatomic)ADPPlayControllView *controllView;
@property(strong, nonatomic)ADPAVPlayerView *playerView;

@end

@implementation ADPPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initPods];
    
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.controllView];
    
    [self.view addSubview:self.playerView];
    [self.view sendSubviewToBack:self.playerView];
    
    [self makeMasonryLayOuts];
    [self playSAO];
}

#pragma mark - 屏幕旋转方向控制

/**
 强制手动旋转屏幕
 未完成:先验证一下要当前的屏幕方向

 @param orientation 目标屏幕方向
 */
- (void)handControlRotate:(UIInterfaceOrientation)orientation {
    //计算旋转角度
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];
    float arch;
    if (orientation == UIInterfaceOrientationLandscapeLeft)
        arch = -M_PI_2;
    else if (orientation == UIInterfaceOrientationLandscapeRight)
        arch = M_PI_2;
    else
        arch = 0;
    //对navigationController.view 进行强制旋转
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.bounds = [[UIScreen mainScreen]bounds];
        self.view.transform = CGAffineTransformMakeRotation(arch);
    } completion:^(BOOL finished) {
        
    }];
}

/**
 监听屏幕旋转通知

 @param notification 通知
 */
- (void)handleUIDeviceOrientationChangeNotification:(NSNotification *)notification {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        {
            
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            
        }
            break;

        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addObserversAndCallBacksForAVPlayer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeObserversAndCallBacksForAVPlayer];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)shouldAutorotate {
    return YES;
}

//- (void)dealloc {
//    [self removeObserver:self forKeyPath:ADPPlayerPlayItemDurationKey];
//}

#pragma mark - Getters

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}

- (ADPAVPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ADPAVPlayerView alloc]init];
        _playerView.player = self.player;
    }
    return _playerView;
}

- (ADPPlayControllView *)controllView {
    if (!_controllView) {
//        CGFloat controllViewWidth = [[UIScreen mainScreen]bounds].size.width;
//        _controllView = [[ADPPlayControllView alloc]initWithFrame:CGRectMake(0, 0, controllViewWidth, controllViewWidth*9/16)];
        _controllView = [[ADPPlayControllView alloc]init];
        _controllView.delegate = self;
        [_controllView.progressSlider addTarget:self action:@selector(playSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_controllView.progressSlider addTarget:self action:@selector(playSliderTouchupInside:) forControlEvents:UIControlEventTouchUpInside];
        [_controllView.brightnessView.progressIndicator addTarget:self action:@selector(brightnessIndicatorValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_controllView.volumeView.progressIndicator addTarget:self action:@selector(volumeIndicatorValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _controllView;
}

- (AVPlayerItem *)playSAOItem {
    if (!_playSAOItem) {
        NSString *saoPath = [[NSBundle mainBundle]pathForResource:@"sao2" ofType:@"mp4"];
        
        NSURL *saoURL = [NSURL fileURLWithPath:saoPath];
        
        AVAsset *asset = [AVAsset assetWithURL:saoURL];
        
        _playSAOItem = [AVPlayerItem playerItemWithAsset:asset];
    }
    return _playSAOItem;
}

- (void)playSAO {
    if (self.outsidePlayItem) {
        [_player replaceCurrentItemWithPlayerItem:self.outsidePlayItem];
        [_player play];
        return;
    }
    [_player replaceCurrentItemWithPlayerItem:self.playSAOItem];
//    [_player play];
}

- (void)makeMasonryLayOuts {
    [_controllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(9.f/16);
    }];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.controllView);
    }];
}

#pragma mark - PrivateMethod

- (void)pausePlay {
    [self.player pause];
}

- (void)startPlay {
    [self.player play];
}

#pragma mark - 事件监听添加与监听移除

- (void)addObserversAndCallBacksForAVPlayer {
    [self addTimePlayObservingToken];
    //监听avaplayer播放资源总时长的变化
    [self addObserver:self forKeyPath:ADPPlayerPlayItemDurationKey options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionInitial context:nil];
    //监听设备方向改变
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleUIDeviceOrientationChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)removeObserversAndCallBacksForAVPlayer {
    [self removeTimePlayObservingToken];
    //移除监听avaplayer播放资源总时长的变化
    [self removeObserver:self forKeyPath:ADPPlayerPlayItemDurationKey];
}

//- (void)addObserverForDeviceOrientionChangeNotification {
//}

/**
 亮度变化
 
 */
- (void)brightnessIndicatorValueChanged:(UISlider *)slider {
    [[UIScreen mainScreen] setBrightness:slider.value];
}

/**
 音量变化

 */
- (void)volumeIndicatorValueChanged:(UISlider *)slider {
    self.player.volume = slider.value;
}

/**
 进度条值变更

 @param slider 进度条
 */
- (void)playSliderValueChanged:(ADPSlider *)slider {
    //当拖动进度条时, 首先先移除时间的监听
    [self removeTimePlayObservingToken];
    
    //根据进度条的值更改已播放的时间, 以响应用户的拖动
    CMTime time = CMTimeMake(slider.value, 1);
    [self changeCurrentPlayTimeWithCMTime:time];
}

/**
 当用户拖动完成时
 即用户手指离开屏幕时视为拖动完成

 @param slider 进度条
 */
- (void)playSliderTouchupInside:(ADPSlider *)slider {
    //获取读条当前的值, 由于进度条总值为播放资源的总长度
    //因此直接获取到进度条的值, 然后将播放器的时间切换到进度条的时间值即可
    CMTime time = CMTimeMake(slider.value, 1);
    [self.player seekToTime:time completionHandler:^(BOOL finished) {
        //当切换完成时再把播放进度的监听重新加回来
        [self addTimePlayObservingToken];
    }];
}

/**
 添加时间监听
 */
- (void)addTimePlayObservingToken {
    /**
     播放时间回调
     处理了:
     1.已经播放的时间显示
     2.播放进度条UI
     
     @parm addPeriodicTimeObserverForIntervalInterval监听回调时间间隔
     return 返回监听的object, 用于移除监听
     */
    __weak __typeof(self) weakSelf = self;
    _timePlayObservingToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //改变当前播放的时间显示
        [weakSelf changeCurrentPlayTimeWithCMTime:time];
        //将当前已经播放的描述作为当前的进度, 总进度为整个视频的duration即为持续时间
        weakSelf.controllView.progressSlider.value =  CMTimeGetSeconds(time);
    }];
}

/**
 移除时间监听
 */
- (void)removeTimePlayObservingToken {
    //移除播放时间的监听
    if (_timePlayObservingToken) {
        [self.player removeTimeObserver:_timePlayObservingToken];
        _timePlayObservingToken = nil;
    }
}

/**
 更新已播放时间的文字显示

 @param time CMTime已播放时间
 */
- (void)changeCurrentPlayTimeWithCMTime:(CMTime)time {
    //获取当前已经播放的秒数
    double newCurrentTimeSeconds =  CMTimeGetSeconds(time);
    
    //计算分钟数
    int wholeMinutes = (int)trunc(newCurrentTimeSeconds/60);
    self.controllView.currentTimeString = [NSString stringWithFormat:@"%d:%02d", wholeMinutes, (int)trunc(newCurrentTimeSeconds) - wholeMinutes * 60];
}

#pragma mark - Delegates

- (void)controllView:(ADPPlayControllView *)controllView playPauseButtonClicked:(ADPPlayPauseButton *)playPauseButton {
    if (playPauseButton.selected) {
        [self pausePlay];
    } else {
        self.player.rate = 2.0;
        [self startPlay];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:ADPPlayerPlayItemDurationKey]) {
        NSValue *durationAsValue = [change objectForKey:NSKeyValueChangeNewKey];
        CMTime newDuration = [durationAsValue isKindOfClass:[NSValue class]] ? durationAsValue.CMTimeValue : kCMTimeZero;
        BOOL hasValidDuration = CMTIME_IS_NUMERIC(newDuration) && newDuration.value != 0;
        double newDurationSeconds = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0;

        int wholeMinutes = (int)trunc(newDurationSeconds / 60);
        self.controllView.durationTimeString = [NSString stringWithFormat:@"%d:%02d", wholeMinutes, (int)trunc(newDurationSeconds) - wholeMinutes * 60];
        self.controllView.progressSlider.maximumValue = newDurationSeconds;
        self.controllView.progressSlider.value = hasValidDuration?CMTimeGetSeconds(self.player.currentTime):0.0;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
