//
//  DFSTSegmentedView.h
//  test
//
//  Created by 123 on 16/3/29.
//  Copyright © 2016年 DFST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabButton.h"

typedef void(^CompeleteBlock)(BOOL success, NSInteger currentIndex);

@protocol DFSTSegmentedDelegate <NSObject>
//滚动成功后的回调
- (void)didSuccessScrollToIndex:(NSInteger)index;

@end

@class TabButton;
@interface DFSTSegmentedView : UIView
@property (nonatomic, assign, readonly)NSInteger currentSegmentedIndex;//当前index
@property (nonatomic, assign)id<DFSTSegmentedDelegate> delegate;

/**
 *  初始化
 *
 *  @param frame        frame
 *  @param buttons      按钮集合
 *  @param defaultIndex 默认选中的序号
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame
                      buttons:(NSArray <TabButton *> *)buttons
                   defaultIndex:(NSInteger)defaultIndex;

/**
 *  根据进度滚动到index
 *
 *  @param index    序号
 *  @param progress progress范围 0.0～1.0
 */
- (void)scrollToIndex:(NSInteger)index progress:(float)progress;

/**
 *  滚动到index  采用动画
 *
 *  @param index
 */
- (void)scrollToIndex:(NSInteger)index;

/**
 *  用了进度滚动后必须调用此方法来判断是否滚动成功(！！！！在使用进度后必须执行此方法！！！！)
 *
 *  @param block
 */
- (void)reloadSegmentedViewWithCompeleteBlock:(CompeleteBlock)block;
@end
