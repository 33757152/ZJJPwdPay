//
//  ZJJPwdView.m
//  ZJJPwdPay
//
//  Created by 张锦江 on 2017/9/23.
//  Copyright © 2017年 ZJJ. All rights reserved.
//
#define HSColor(r,g,b)       [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1]
#define MAIN_COLOR           HSColor(237,138,38)
#define ZJJLOG               NSLog(@"%s",__FUNCTION__);
#define TF_TAG               90000
#define BLACK_ROUND_TAG      100000
#define SCREEN_WIDTH         [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT        [UIScreen mainScreen].bounds.size.height
#define UN_VISABLE_FRAME     CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 2*SCREEN_HEIGHT/3)
#define VISABLE_FRAME        CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH, 2*SCREEN_HEIGHT/3)

#import "ZJJPwdView.h"

@interface ZJJPwdView ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *forgetPwdBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation ZJJPwdView

+ (id)comeOutPwdView {
    return [[self alloc] initWithPwdView];
}

- (id)initWithPwdView {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        [self creatView];
    }
    return self;
}

- (void)creatView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.titleLabel];
    [self.bottomView addSubview:self.lineView];
    [self creatSixTextField];
    [self.bottomView addSubview:self.forgetPwdBtn];
    [self.bottomView addSubview:self.closeBtn];
    [self beginToAppear];
}

- (void)creatSixTextField {
    float tf_y = _bottomView.frame.size.height*3/16;
    float tfW = (SCREEN_WIDTH-40)/6;
    float tfH = _bottomView.frame.size.height/2/4;
    UIView *aroundView = [[UIView alloc] initWithFrame:CGRectMake(20, tf_y, 6*tfW, tfH)];
    aroundView.backgroundColor = [UIColor whiteColor];
    aroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    aroundView.layer.borderWidth = 0.3;
    aroundView.layer.cornerRadius = 10.0f;
    aroundView.clipsToBounds = YES;
    [self.bottomView addSubview:aroundView];
    [self.bottomView.layer addSublayer:aroundView.layer];
    for (NSInteger i = 0; i<6; i++) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20+tfW*(i%6), tf_y, tfW, tfH)];
        tf.textAlignment = NSTextAlignmentCenter;
        tf.backgroundColor = [UIColor clearColor];
        tf.tintColor = [UIColor clearColor];
        tf.tag = TF_TAG+i;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.userInteractionEnabled = NO;
        [self.bottomView addSubview:tf];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(tf.frame.origin.x+tfW+0.1, tf_y, 0.1, tfH)];
        line.alpha = 0.5;
        line.backgroundColor = [UIColor lightGrayColor];
        if (i != 5) {
            [self.bottomView addSubview:line];
        }
        if (i == 0) {
            [self textFieldCanUse:tf];
        }
        float blackR_w = tfH/4;
        if (tfH < tfW) {
            blackR_w = tfW/4;
        }
        UIView *blackView = [[UIView alloc] init];
        blackView.frame = CGRectMake((tfW-blackR_w)/2, (tfH-blackR_w)/2, blackR_w, blackR_w);
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0;
        blackView.tag = BLACK_ROUND_TAG+i;
        blackView.layer.cornerRadius = blackR_w/2;
        blackView.clipsToBounds = YES;
        [tf addSubview:blackView];
    }
}

- (void)beginToAppear {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        _bottomView.frame = VISABLE_FRAME;
    }];
}

- (void)beginToDisAppear {
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0];
        _bottomView.frame = UN_VISABLE_FRAME;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:UN_VISABLE_FRAME];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _bottomView.frame.size.height/2/4)];
        _titleLabel.text = @"请输入密码";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, SCREEN_WIDTH, 0.5)];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.3;
    }
    return _lineView;
}

- (UIButton *)forgetPwdBtn {
    if (!_forgetPwdBtn) {
        UITextField *textField = [self viewWithTag:TF_TAG];
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPwdBtn.frame = CGRectMake(SCREEN_WIDTH-100, textField.frame.origin.y+textField.frame.size.height+10, 100, 40);
        _forgetPwdBtn.backgroundColor = [UIColor whiteColor];
        [_forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _forgetPwdBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_forgetPwdBtn addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(SCREEN_WIDTH-5-40, 5, 40, 40);
        [_closeBtn setTitle:@"❎" forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (void)textFieldCanUse:(UITextField *)textField {
    textField.userInteractionEnabled = YES;
    [textField becomeFirstResponder];
}

- (void)textFieldCanNotUse:(UITextField *)textField {
    [textField resignFirstResponder];
    textField.userInteractionEnabled = NO;
}

- (void)contentDidChange:(NSNotification *)noti {
    UITextField *currentTF = noti.object;
    if ([currentTF.text isEqualToString:@""]) {
        [self notHideTextWith:currentTF.tag];
    }else {
        [self hideTextWith:currentTF.tag];
    }
    if (currentTF.text.length>1) {
        NSString *currentStr = [currentTF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *lastStr = [currentTF.text substringWithRange:NSMakeRange(1, 1)];
        UITextField *nextTF = [self viewWithTag:currentTF.tag+1];
        currentTF.text = currentStr;
        nextTF.text = lastStr;
        [self hideTextWith:currentTF.tag+1];
        if (currentTF.tag == TF_TAG+4) {
            [self beginToDisAppear];
            [self obtainPwd];
        }else {
            [self textFieldCanNotUse:currentTF];
            [self textFieldCanUse:nextTF];
        }
    }else if (currentTF.text.length == 0) {
        UITextField *lastTF = [self viewWithTag:currentTF.tag-1];
        UITextField *deleteTF = [self viewWithTag:currentTF.tag];
        if (lastTF) {
            [self textFieldCanUse:lastTF];
        }
        if (currentTF.tag != TF_TAG) {
            [self textFieldCanNotUse:deleteTF];
        }
    }
}

- (void)hideTextWith:(NSInteger)tag {
    UIView *blackView = [self viewWithTag:tag+BLACK_ROUND_TAG-TF_TAG];
    blackView.alpha = 1;
}

- (void)notHideTextWith:(NSInteger)tag {
    UIView *blackView = [self viewWithTag:tag+BLACK_ROUND_TAG-TF_TAG];
    blackView.alpha = 0;
}

- (void)obtainPwd {
    NSString *pwdString = [NSString stringWithFormat:@""];
    for (NSInteger i = 0; i<6; i++) {
        UITextField *tf = [self viewWithTag:TF_TAG+i];
        pwdString = [NSString stringWithFormat:@"%@%@",pwdString,tf.text];
    }
    if (self.myPassNumBlock) {
        self.myPassNumBlock(pwdString);
    }
}

- (void)forgetClick {
    [self beginToDisAppear];
    if (self.myForgetBlock) {
        self.myForgetBlock();
    }
}

- (void)closeClick {
    [self beginToDisAppear];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
