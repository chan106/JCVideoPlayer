//
//  JCVideoPlayer.m
//  JCVideoPlayer
//
//  Created by Guo.JC on 2017/5/15.
//  Copyright © 2017年 Guo.JC. All rights reserved.
//

#import "JCVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface JCVideoPlayer ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIView *progressBoard;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slideWidth;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@end

@implementation JCVideoPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPlayer];
}

- (void)initPlayer{
    
    _progressView.layer.cornerRadius = _progressBoard.layer.cornerRadius = 3;
    _progressView.layer.masksToBounds = _progressBoard.layer.masksToBounds = YES;
    
    // setAVPlayer
    _player = [[AVPlayer alloc] init];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    [self.view.layer addSublayer:_playerLayer];
    
    [NSTimer scheduledTimerWithTimeInterval:.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
       
        _slideWidth.constant = arc4random() % 10 * 0.1 * (_progressBoard.bounds.size.width - 15);
        
    }];
}

- (IBAction)playAction:(UIButton *)sender {
}

- (IBAction)preAction:(UIButton *)sender {
}

- (IBAction)nextAction:(UIButton *)sender {
}

- (IBAction)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
