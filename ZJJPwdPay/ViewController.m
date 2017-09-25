//
//  ViewController.m
//  ZJJPwdPay
//
//  Created by 张锦江 on 2017/9/23.
//  Copyright © 2017年 ZJJ. All rights reserved.
//
#define SCREEN_WIDTH         [UIScreen mainScreen].bounds.size.width

#import "ViewController.h"
#import "ZJJPwdView.h"

@interface ViewController () {
    UILabel *_label;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self creatUI];
}

#pragma mark - 方法
- (void)creatUI {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 40)];
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor yellowColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    _label = label;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor yellowColor];
    [button setTitle:@"支付" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)payClick {
    ZJJPwdView *pwd = [ZJJPwdView comeOutPwdView];
    pwd.myForgetBlock = ^{
        NSLog(@"忘记密码");
    };
    pwd.myPassNumBlock = ^(NSString *pwdString) {
        _label.text = [NSString stringWithFormat:@"您输入的密码是:%@",pwdString];
    };
    [[UIApplication sharedApplication].delegate.window addSubview:pwd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
