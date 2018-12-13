//
//  ADPBrigntnessView.m
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/13.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPBrigntnessView.h"

@implementation ADPBrigntnessView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.iconImageView setImage:[UIImage imageNamed:@"brightness"]];
    }
    return self;
}

@end
