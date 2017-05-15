//
//  ViewController.m
//  JCVideoPlayer
//
//  Created by Guo.JC on 2017/5/15.
//  Copyright © 2017年 Guo.JC. All rights reserved.
//

#import "ViewController.h"
#import "JCVideoPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self presentViewController:[JCVideoPlayer new] animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
