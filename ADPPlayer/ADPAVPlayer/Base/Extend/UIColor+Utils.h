//
//  UIColor+Utils.h
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/11.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)
//设置十六进制颜色
+ (UIColor *)colorWithHex:(NSInteger)hex;
+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
