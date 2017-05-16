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
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"kkkkkkk" forState:UIControlStateNormal];
    button.frame = CGRectMake(50, 100, 40, 40);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tap{

    [self presentViewController:[JCVideoPlayer new] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
