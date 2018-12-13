//
//  ADPIconProgressIndicatorBaseView.m
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/13.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPIconProgressIndicatorBaseView.h"

static CGFloat const ADPIconProgressIndicatorBaseViewGap = 10.f;

@interface ADPIconProgressIndicatorBaseView()
@property(strong, nonatomic)UIView *backGrayView;
@end

@implementation ADPIconProgressIndicatorBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:self.iconImageView];
//        [self addSubview:self.progressIndicator];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.backGrayView];
        [self addSubview:self.iconImageView];
        [self addSubview:self.progressIndicator];
        [self makeMasonryLayOuts];
    }
    return self;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}

- (UISlider *)progressIndicator {
    if (!_progressIndicator) {
        _progressIndicator = [[UISlider alloc]init];
        _progressIndicator.thumbTintColor = [UIColor clearColor];
        _progressIndicator.minimumTrackTintColor = [UIColor colorWithHexString:ADPMainColorHexStr];
        //系统slider颜色182, 182, 182, 调整未缓冲完成tracking轨道颜色为淡一点的颜色
        [_progressIndicator setMaximumTrackTintColor:[UIColor colorWithRed:182./256 green:182./256 blue:182./256 alpha:0.6]];
    }
    return _progressIndicator;
}

- (UIView *)backGrayView {
    if (!_backGrayView) {
        _backGrayView = [[UIView alloc]init];
        _backGrayView.backgroundColor = [UIColor blackColor];
        _backGrayView.alpha = 0.3;
        _backGrayView.layer.cornerRadius = 10;
    }
    return _backGrayView;
}

- (void)makeMasonryLayOuts {
    __weak __typeof(self) weakSelf = self;
    [_backGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).offset(ADPIconProgressIndicatorBaseViewGap);
        make.bottom.mas_equalTo(self).offset(-ADPIconProgressIndicatorBaseViewGap);
        make.width.mas_equalTo(self.iconImageView.mas_height);
    }];
    
    [_progressIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(ADPIconProgressIndicatorBaseViewGap);
        make.right.mas_equalTo(self.mas_right).offset(-ADPIconProgressIndicatorBaseViewGap);
        make.centerY.mas_equalTo(self.iconImageView.mas_centerY);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
