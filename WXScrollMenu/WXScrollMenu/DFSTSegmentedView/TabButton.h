//
//  TabButton.h
//  test
//
//  Created by 123 on 16/3/29.
//  Copyright © 2016年 DFST. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Masonry.h"

typedef void(^TabButtonClickBlock)(void);

@interface TabButton : UIView
@property (nonatomic, assign, readonly)float buttonWidth;//视图宽度，根据按钮标题文字自适应
@property (nonatomic, assign)float centerX;//记录按钮的居中位置
@property (nonatomic, strong)UIButton *button;

//初始化
- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage
                                  title:(NSString *)title;

- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor
                                  title:(NSString *)title;

//设置高度进度
- (void)setButtonHeightWithProgress:(float)progress;

//动画变化高度，YES为变矮  NO为变高
- (void)buttonAnimationBackToNormal:(BOOL)isNormal;

//按钮回调方法
- (void)buttonDidClick:(TabButtonClickBlock)block;

@end
