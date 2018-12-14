//
//  ADPIconProgressIndicatorBaseView.h
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/13.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPBaseView.h"

@interface ADPIconProgressIndicatorBaseView : ADPBaseView

@property(strong, nonatomic)UIImageView *iconImageView;

/**
 音量亮度提示框
 
 值区间0.f-1.f
 */
@property(strong, nonatomic)UISlider *progressIndicator;

@end
