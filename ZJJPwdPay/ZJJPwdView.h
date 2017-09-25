//
//  ZJJPwdView.h
//  ZJJPwdPay
//
//  Created by 张锦江 on 2017/9/23.
//  Copyright © 2017年 ZJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^forgetBlock)(void);
typedef void(^passNumBlock)(NSString *);

@interface ZJJPwdView : UIView

+ (id)comeOutPwdView;

@property (nonatomic, copy) forgetBlock myForgetBlock;
@property (nonatomic, copy) passNumBlock myPassNumBlock;

@end
