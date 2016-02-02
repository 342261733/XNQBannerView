//
//  ViewController.m
//  XNQBannerView
//
//  Created by QFPayShadowMan on 16/2/2.
//  Copyright © 2016年 xnq. All rights reserved.
//

#import "ViewController.h"
#import "XNQBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *arrImageName = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    // ** 混合型
//  UIImage *testImage = [UIImage imageNamed:@"1.jpg"];
//  NSArray *arrImageName = @[@"http://xxx/xxx.png",@"http://xxx/xxx.png",@"http://xxx/xxx.png",@"4.jpg",testImage];
    XNQBannerView *bannerView = [[XNQBannerView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 100)];
    bannerView.arrImages = arrImageName;
    bannerView.clickIndex = ^(NSInteger index) {//** 页面的点击回调
        NSLog(@"click index is %lu",(long)index);
    };
    [self.view addSubview:bannerView];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
