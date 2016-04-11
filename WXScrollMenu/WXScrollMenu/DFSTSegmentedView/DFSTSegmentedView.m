//
//  DFSTSegmentedView.m
//  test
//
//  Created by 123 on 16/3/29.
//  Copyright © 2016年 DFST. All rights reserved.
//

#import "DFSTSegmentedView.h"
#import "Masonry.h"
#import "ColorLineView.h"


#define kScreenScale [UIScreen mainScreen].bounds.size.width / 320.0
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width

static float during = 0.2f;

typedef NS_ENUM(NSInteger, Direction) {
    Direction_none,
    Direction_next,
    Direction_last
};

@interface DFSTSegmentedView ()
@property (nonatomic, strong)NSMutableArray <TabButton *> *tabButtonsArray;

@property (nonatomic, strong)ColorLineView *lineView;
@property (nonatomic, strong)NSTimer *timer;//计时器，在动画过程中去执行layout
@property (nonatomic, copy)CompeleteBlock block;
@end

@implementation DFSTSegmentedView
{
    NSInteger _targetIndex;
    TabButton *_headButton;
    TabButton *_tailButton;
    float _currentProgress;
}

Direction getDirection (NSInteger currentIndex, NSInteger targetIndex, NSInteger count) {
    if (targetIndex > currentIndex) {
        if (targetIndex == count - 1 && currentIndex == 0) {
            return Direction_last;
        } else {
            return Direction_next;
        }
    } else if (targetIndex < currentIndex) {
        if (targetIndex == 0 && currentIndex == count - 1) {
            return Direction_next;
        } else {
            return Direction_last;
        }
    } else {
        return Direction_none;
    }
}

- (void)dealloc {
    [self.timer invalidate];
}

- (instancetype)initWithFrame:(CGRect)frame
                      buttons:(NSArray <TabButton *>*)buttons
                   defaultIndex:(NSInteger)defaultIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentSegmentedIndex = defaultIndex >= buttons.count ? 0: defaultIndex;
        [self configDatasourceWithButtons:buttons];
        [self initUserInterface];
    }
    return self;
}

- (void)configDatasourceWithButtons:(NSArray *)buttons {
    [self.tabButtonsArray addObjectsFromArray:buttons];
    _headButton = [self.tabButtonsArray firstObject];
    _tailButton = [self.tabButtonsArray lastObject];
}

- (void)initUserInterface {
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.mas_equalTo(15);
    }];
    
    
    __block TabButton *tempButton = nil;
    [self.tabButtonsArray enumerateObjectsUsingBlock:^(TabButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addSubview:obj];
        [obj buttonDidClick:^{
            NSInteger targetIndex = [self.tabButtonsArray indexOfObject:obj];
            [self scrollToIndex:targetIndex];
        }];
        obj.frame = CGRectMake(CGRectGetMaxX(tempButton.frame), self.bounds.size.height - 55, obj.buttonWidth, 45);
        obj.centerX = obj.center.x;
        tempButton = obj;
    }];
    
    [self scrollToIndex:_currentSegmentedIndex progress:1];
    [self updateTabButtonCenterX];
}

#pragma mark - public methods
- (void)scrollToIndex:(NSInteger)index progress:(float)progress {
    if (progress > 1) {
        return;
    }

    _currentProgress = progress;
    _targetIndex = index;
    TabButton *targetButton = self.tabButtonsArray[index];
    TabButton *currentButton = self.tabButtonsArray[_currentSegmentedIndex];
    
    float targetOffset = [self totalOffsetCenterButton:targetButton] * progress;

    [currentButton setButtonHeightWithProgress:(1 - progress)];
    [targetButton setButtonHeightWithProgress:progress];
    [self.lineView changeToColor:targetButton.button.backgroundColor progress:progress];

    [self.tabButtonsArray enumerateObjectsUsingBlock:^(TabButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.center = CGPointMake(obj.centerX + targetOffset, obj.center.y);
    }];
    [self layoutButtons];
}

- (void)scrollToIndex:(NSInteger)index {

    if (index == _currentSegmentedIndex) {
        return;
    }
    _targetIndex = index;
    
    Direction direction = getDirection(_currentSegmentedIndex, _targetIndex, self.tabButtonsArray.count);
    [self layoutHeadTailButtonWithDirection:direction];
    
    TabButton *targetButton = self.tabButtonsArray[_targetIndex];
    TabButton *currentButton = self.tabButtonsArray[_currentSegmentedIndex];
    
    [targetButton buttonAnimationBackToNormal:NO];
    [currentButton buttonAnimationBackToNormal:YES];
    [self.lineView changeToColor:targetButton.button.backgroundColor];
    
    float totalOffset = [self offsetCenterButton:targetButton];
    
    [self.timer setFireDate:[NSDate date]];
    
    for (TabButton *btn in self.tabButtonsArray) {
        [UIView animateWithDuration:during animations:^{
            btn.center = CGPointMake(btn.center.x + totalOffset, btn.center.y);
        }completion:^(BOOL finished) {
            if ([self.tabButtonsArray lastObject] == btn) {
                [self.timer setFireDate:[NSDate distantFuture]];
                [self layoutButtons];
                [self updateTabButtonCenterX];
            }
        }];
    }
    _currentSegmentedIndex = index;
    [self.delegate didSuccessScrollToIndex:_currentSegmentedIndex];
}


- (void)backToIndex:(NSInteger)index {
    TabButton *targetButton = self.tabButtonsArray[_targetIndex];
    TabButton *currentButton = self.tabButtonsArray[_currentSegmentedIndex];
    
    [targetButton buttonAnimationBackToNormal:YES];
    [currentButton buttonAnimationBackToNormal:NO];
    
    [self.lineView changeToColor:currentButton.button.backgroundColor];
    
    float totalOffset = [self offsetCenterButton:currentButton];
    
    for (TabButton *btn in self.tabButtonsArray) {
        [UIView animateWithDuration:during animations:^{
            btn.center = CGPointMake(btn.center.x + totalOffset, btn.center.y);
        }completion:^(BOOL finished) {
            if ([self.tabButtonsArray lastObject] == btn) {
                [self layoutButtons];
                [self updateTabButtonCenterX];
            }
        }];
    }
}

- (void)reloadSegmentedViewWithCompeleteBlock:(CompeleteBlock)block {
    if (_currentProgress == 1.0) {
        _currentSegmentedIndex = _targetIndex;
        [self updateTabButtonCenterX];
        block(YES, _targetIndex);
        [self.delegate didSuccessScrollToIndex:_currentSegmentedIndex];
    }
    else if (_currentProgress >= 0.5) {
        [self scrollToIndex:_targetIndex];
        _currentSegmentedIndex = _targetIndex;
        block(YES, _targetIndex);
    } else {
        [self backToIndex:_currentSegmentedIndex];
        block(NO, _currentSegmentedIndex);
    }
}

/**
 *  更新按钮当前位置
 */
- (void)updateTabButtonCenterX {
    for (TabButton *btn in self.tabButtonsArray) {
        btn.centerX = btn.center.x;
    }
}

#pragma mark - private methods
- (float)offsetCenterButton:(TabButton *)button {
    return self.bounds.size.width / 2 - button.center.x;
}

- (float)totalOffsetCenterButton:(TabButton *)button {
    return self.bounds.size.width / 2 - button.centerX;
}

- (void)layoutButtons{
    
    BOOL leftLack = (_headButton.frame.origin.x >= 0) ? YES : NO;
    BOOL rightLack = (CGRectGetMaxX(_tailButton.frame) <= self.bounds.size.width) ? YES : NO;
    //左边空位
    if (leftLack && !rightLack) {
        [self layoutHeadTailButtonWithDirection:Direction_last];
        if (CGRectGetMaxX(_tailButton.frame) <= self.bounds.size.width) {
            return;//如果补不上就不补了
        }
        [self layoutButtons];
    }
    
    //右边空位
    if (rightLack && !leftLack) {
        [self layoutHeadTailButtonWithDirection:Direction_next];
        [self layoutButtons];
    }
}

- (void)layoutHeadTailButtonWithDirection:(Direction)direction {
    if (direction == Direction_last && _tailButton.frame.origin.x >= kMainScreenWidth) {
        _tailButton.center = CGPointMake(_headButton.frame.origin.x - _tailButton.buttonWidth / 2.0, _tailButton.center.y);
        _tailButton.centerX = _headButton.centerX - _headButton.bounds.size.width / 2.0 - _tailButton.bounds.size.width / 2;
        
        NSInteger tailIndex = [self.tabButtonsArray indexOfObject:_tailButton];
        NSInteger newTailIndex = tailIndex - 1 < 0 ? self.tabButtonsArray.count - 1 : tailIndex - 1;
        _headButton = _tailButton;
        _tailButton = self.tabButtonsArray[newTailIndex];
    }
    
    if (direction == Direction_next && CGRectGetMaxX(_headButton.frame) <= 0) {
        _headButton.center = CGPointMake(CGRectGetMaxX(_tailButton.frame) + _headButton.buttonWidth / 2.0, _headButton.center.y);
        _headButton.centerX = _tailButton.centerX + _headButton.bounds.size.width / 2.0 + _tailButton.bounds.size.width / 2;
        
        NSInteger headIndex = [self.tabButtonsArray indexOfObject:_headButton];
        NSInteger newHeadIndex = headIndex + 1 >= self.tabButtonsArray.count ? 0 : headIndex + 1;
        _tailButton = _headButton;
        _headButton = self.tabButtonsArray[newHeadIndex];
    }
}

- (void)showFrame:(NSTimer *)sender {
    [self layoutButtons];
}

#pragma mark - getter & setter

- (NSMutableArray<TabButton *> *)tabButtonsArray {
    if (!_tabButtonsArray) {
        _tabButtonsArray = [NSMutableArray array];
    }
    return _tabButtonsArray;
}

- (ColorLineView *)lineView {
    if (!_lineView) {
        _lineView = [ColorLineView new];
    }
    return _lineView;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(showFrame:) userInfo:nil repeats:YES];
    }
    return _timer;
}
@end
