//
//  TabButton.m
//  test
//
//  Created by 123 on 16/3/29.
//  Copyright © 2016年 DFST. All rights reserved.
//

#import "TabButton.h"

#define kScreenScale [UIScreen mainScreen].bounds.size.width / 320.0


static float minButtonWidth = 90.0f;//按钮最小宽度
static float minButtonHeight = 30.0f;//按钮最低高度
static float maxButtonHeight = 40.0f;//按钮最高高度
static float during = 0.3;//动画时长

@interface TabButton ()
@property (nonatomic, copy)TabButtonClickBlock block;
@end

@implementation TabButton

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage
                                  title:(NSString *)title
{
    self = [super init];
    if (self) {
        [self initUserInterfaceWithBackgroundImage:backgroundImage title:title];
        [self configPropertyValueWithTitle:title];
    }
    return self;
}

- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor title:(NSString *)title {
    self = [super init];
    if (self) {
        [self initUserInterfaceWithBackgroundColor:backgroundColor title:title];
        [self configPropertyValueWithTitle:title];
    }
    return self;
}

- (void)initUserInterfaceWithBackgroundColor:(UIColor *)backgroundColor
                                       title:(NSString *)title{
    self.backgroundColor = [UIColor clearColor];
    
    [self.button setTitle:title forState:UIControlStateNormal];
    [self.button setBackgroundColor:backgroundColor];
    [self addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(minButtonHeight);
    }];
}

- (void)initUserInterfaceWithBackgroundImage:(UIImage *)backgroundImage
                                       title:(NSString *)title{
    self.backgroundColor = [UIColor clearColor];
    
    [self.button setTitle:title forState:UIControlStateNormal];
    [self.button setImage:backgroundImage forState:UIControlStateNormal];
    [self addSubview:self.button];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(minButtonHeight);
    }];
}

- (void)configPropertyValueWithTitle:(NSString *)title {
    float titleWidth = [title sizeWithAttributes:@{NSFontAttributeName : self.button.titleLabel.font}].width;
    if (titleWidth < minButtonWidth) {
        _buttonWidth = minButtonWidth * kScreenScale;
    } else {
        _buttonWidth = titleWidth + 20 * kScreenScale;
    }
    
}

#pragma mark - public methods
- (void)setButtonHeightWithProgress:(float)progress {
    float currentHeight = minButtonHeight + (progress * (maxButtonHeight - minButtonHeight));
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(currentHeight);
    }];
    [self layoutIfNeeded];
}

- (void)buttonAnimationBackToNormal:(BOOL)isNormal {
    //变矮
    if (isNormal) {
        [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(minButtonHeight);
        }];
    }
    //变高
    else {
        [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(maxButtonHeight);
        }];
    }
    [UIView animateWithDuration:during animations:^{
        [self layoutIfNeeded];
    }];
    
}

- (void)buttonDidClick:(TabButtonClickBlock)block {
    self.block = ^() {
        block();
    };
}

#pragma mark - response methods
- (void)click:(UIButton *)sender {
    self.block();
}

#pragma mark - setter & getter
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _button.layer.cornerRadius = 4;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _button.backgroundColor = [UIColor colorWithRed:(arc4random() % 256) / 255.0 green:(arc4random() % 256) / 255.0 blue:(arc4random() % 256) / 255.0 alpha:1];
    }
    return _button;
}
@end
