//
//  ViewController.m
//  ADPPlayer
//
//  Created by Zeaple on 2018/12/3.
//  Copyright © 2018年 Zeaple. All rights reserved.
//

#import "ViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import "ADPPlayerViewController.h"

@interface ViewController ()
@property(strong, nonatomic)AVPlayerItem *playItem;
@property (weak, nonatomic) IBOutlet UIView *greenView;
@property (weak, nonatomic) IBOutlet UIView *redView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testSublayer];
    
    [self presentPlayer];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self presentPlayer];
}

- (void)testTransform {
    [UIView animateWithDuration:0.3 animations:^{
//        self.redView.transform = CGAffineTransformRotate(self.redView.transform, M_PI_4);
//        self.redView.transform = CGAffineTransformScale(self.redView.transform, 1.2, 1.2);
//        self.redView.transform = CGAffineTransformScale(self.redView.transform, 0.8, 0.8);
//        self.redView.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI_4), CGAffineTransformMakeScale(0.8, 0.8));
        
        //旋转加缩小
//        self.redView.transform = CGAffineTransformConcat(CGAffineTransformRotate(self.redView.transform, M_PI_4), CGAffineTransformMakeScale(0.8, 0.8));
//        self.redView.layer.transform = CATransform3DRotate(self.redView.layer.transform, M_PI_2, , <#CGFloat y#>, <#CGFloat z#>)

    }];
}

- (void)testSublayer {
    
    CALayer *yellowLayer = [[CALayer alloc]init];
    yellowLayer.backgroundColor = [UIColor yellowColor].CGColor;
    yellowLayer.position = CGPointMake(0, 0);
    yellowLayer.bounds = CGRectMake(40, 0, 100, 100);
    
    CALayer *yellow2Layer = [[CALayer alloc]init];
    yellow2Layer.backgroundColor = [UIColor blueColor].CGColor;
    yellow2Layer.position = CGPointMake(0, 0);
    yellow2Layer.bounds = CGRectMake(0, 0, 100, 100);

    [yellowLayer addSublayer:yellow2Layer];
    [_greenView.layer addSublayer:yellowLayer];
}

- (AVPlayerItem *)playItem {
    if (!_playItem) {
        NSString *saoPath = [[NSBundle mainBundle]pathForResource:@"sao2" ofType:@"mp4"];
        
        NSURL *saoURL = [NSURL fileURLWithPath:saoPath];
        
        AVAsset *asset = [AVAsset assetWithURL:saoURL];
        
        _playItem = [AVPlayerItem playerItemWithAsset:asset];
    }
    return _playItem;
}

- (IBAction)playVCButtonAction:(id)sender {
//    AVPlayerViewController *play = [[AVPlayerViewController alloc]init];
//    play.player = [AVPlayer playerWithPlayerItem:self.playItem];
//    [self presentViewController:play animated:YES completion:nil];
    
//    [self testTransform];
    ADPPlayerViewController *player = [[ADPPlayerViewController alloc]init];
    [self presentViewController:player animated:YES completion:nil];
}

- (void)presentPlayer {
    ADPPlayerViewController *player = [[ADPPlayerViewController alloc]init];
    [self presentViewController:player animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
