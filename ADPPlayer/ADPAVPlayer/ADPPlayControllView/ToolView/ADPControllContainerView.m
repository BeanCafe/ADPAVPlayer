//
//  ADPControllContainerView.m
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/7.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPControllContainerView.h"

@interface ADPControllContainerView ()
@property(strong, nonatomic)ADPBaseView *blackMaskView;
@end

@implementation ADPControllContainerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.shadowRadius = 15.1f;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowOffset = CGSizeMake(0, 20);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        [self addSubview:self.blackMaskView];
        [self makeLayOuts];
    }
    return self;
}

- (ADPBaseView *)blackMaskView {
    if (!_blackMaskView) {
        _blackMaskView = [[ADPBaseView alloc]init];
        _blackMaskView.backgroundColor = [UIColor blackColor];
        _blackMaskView.layer.shadowRadius = 15.1f;
        _blackMaskView.layer.shadowOpacity = 1.0;
        _blackMaskView.layer.shadowOffset = CGSizeMake(0, -20);
        _blackMaskView.layer.shadowColor = [UIColor blackColor].CGColor;
        _blackMaskView.alpha = 0.1;
    }
    return _blackMaskView;
}

- (void)makeLayOuts {
    [_blackMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
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
