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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bufferProgress;
@property (weak, nonatomic) IBOutlet UIView *bufferView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slideWidth;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (assign, nonatomic) CMTime totalTime;
@property (strong, nonatomic) NSTimer *updateTimer;
@property (weak, nonatomic) IBOutlet UIView *playerView;

@end

@implementation JCVideoPlayer

- (void)viewDidLoad {
    [super viewDidLoad];
    _videoFiles = @[@"/Users/guo.jc/Desktop/videoFile/001.mp4",
                    @"/Users/guo.jc/Desktop/videoFile/002.mp4",
                    @"/Users/guo.jc/Desktop/videoFile/003.mp4"];
    _index = 1;
    [self initPlayer];
}

- (void)initPlayer{
    
    _progressView.layer.cornerRadius = _progressBoard.layer.cornerRadius = _bufferView.layer.cornerRadius = 3;
    _progressView.layer.masksToBounds = _progressBoard.layer.masksToBounds = _bufferView.layer.masksToBounds = YES;
    
    // setAVPlayer
    _player = [[AVPlayer alloc] init];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerLayer.frame = self.view.bounds;
    [_playerView.layer addSublayer:_playerLayer];
    [self updatePlayerWithURL:[NSURL fileURLWithPath:_videoFiles[_index]]];
}

- (void)updatePlayerWithURL:(NSURL *)url {
    _playBtn.selected = NO;
    if (_updateTimer) {
        [_updateTimer invalidate];
        _updateTimer = nil;
    }
    if (_playerItem) {
//        [_playerItem removeObserver:self forKeyPath:@"status"];
    }
    _playerItem = [AVPlayerItem playerItemWithURL:url]; // create item
    [_player  replaceCurrentItemWithPlayerItem:_playerItem];
//    [self addObserverAndNotification];
    [_player play];
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self setProgress:(CMTimeGetSeconds(_playerItem.currentTime) / CMTimeGetSeconds(_playerItem.duration)) animated:YES];
    }];
}

- (void)addObserverAndNotification{
    [_playerItem addObserver:self
                  forKeyPath:@"status"
                     options:(NSKeyValueObservingOptionNew)
                     context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue]; // 获取更改后的状态
        if (status == AVPlayerStatusReadyToPlay) {
            _totalTime = item.duration; // 获取视频长度
            // 设置视频时间
//            [self setMaxDuration:CMTimeGetSeconds(duration)];
            // 播放
            [_player play];
            _playBtn.selected = YES;
        } else if (status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        } else {
            NSLog(@"AVPlayerStatusUnknown");
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDurationRanges]; // 缓冲时间
        CGFloat totalDuration = CMTimeGetSeconds(_playerItem.duration); // 总时间
        [self setProgress:timeInterval / totalDuration animated:YES]; // 更新缓冲条
    }
}

// 已缓冲进度
- (NSTimeInterval)availableDurationRanges {
    NSArray *loadedTimeRanges = [_playerItem loadedTimeRanges]; // 获取item的缓冲数组
    // discussion Returns an NSArray of NSValues containing CMTimeRanges
    
    // CMTimeRange 结构体 start duration 表示起始位置 和 持续时间
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue]; // 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds; // 计算总缓冲时间 = start + duration
    return result;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
    if (animated) {
        [UIView animateWithDuration:10 animations:^{
            _slideWidth.constant = progress * _progressBoard.bounds.size.width;
        }];
    }
    else{
        _slideWidth.constant = progress * _progressBoard.bounds.size.width;
    }
}

- (IBAction)playAction:(UIButton *)sender {
    if (sender.selected == NO) {
        [_player play];
    }
    else{
        [_player pause];
    }
    sender.selected = !sender.selected;
}

- (IBAction)preAction:(UIButton *)sender {

    if (_index == 0) {
        return;
    }
    _index--;
    NSURL *url = [NSURL fileURLWithPath:_videoFiles[_index]];
    [self updatePlayerWithURL:url];
    
}

- (IBAction)nextAction:(UIButton *)sender {
    if (_index == _videoFiles.count - 1) {
        return;
    }
    _index++;
    NSURL *url = [NSURL fileURLWithPath:_videoFiles[_index]];
    [self updatePlayerWithURL:url];
}

- (IBAction)closeAction:(UIButton *)sender {
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    if (_updateTimer) {
        [_updateTimer invalidate];
        _updateTimer = nil;
    }
    [_player replaceCurrentItemWithPlayerItem:nil];
//    [_playerItem removeObserver:self forKeyPath:@"status"];
//    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//    [_player removeTimeObserver:_playTimeObserver];
//    _playTimeObserver = nil;
//    [_playerItem removeObserver:self forKeyPath:@"status"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeScreenDir:(UIButton *)sender {
    
    if (sender.selected) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
    else{
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }
    [UIView animateWithDuration:.5 animations:^{
        _playerLayer.frame = _playerView.bounds;
    }];
    
    sender.selected = !sender.selected;
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)dealloc{
    NSLog(@"释放=====");
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
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
