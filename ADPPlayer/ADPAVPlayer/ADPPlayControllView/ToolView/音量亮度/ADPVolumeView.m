//
//  ADPVolumeView.m
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/13.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ADPVolumeView.h"

@implementation ADPVolumeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.iconImageView.image = [UIImage imageNamed:@"speaker"];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
