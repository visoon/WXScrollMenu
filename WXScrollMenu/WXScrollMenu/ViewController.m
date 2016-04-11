//
//  ViewController.m
//  WXScrollMenu
//
//  Created by vison on 16/4/11.
//  Copyright © 2016年 vison. All rights reserved.
//

#import "ViewController.h"
#import "DFSTSegmentedView.h"

@interface ViewController ()<DFSTSegmentedDelegate>
{
    DFSTSegmentedView *_segmentedView;
    float _originOffset;
    float _currentOffset;
    float _defaultIndex;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  top menu
     */
    NSMutableArray *buttonArr = [NSMutableArray array];
    NSMutableArray *colorArr = [NSMutableArray array];
    UIColor *color0 = [UIColor colorWithRed:89 / 255.0 green:204 / 255.0 blue:62 / 255.0 alpha:1];
    UIColor *color1 = [UIColor colorWithRed:0 / 255.0 green:207 / 255.0 blue:219 / 255.0 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:255 / 255.0 green:100 / 255.0 blue:105 / 255.0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:255 / 255.0 green:176 / 255.0 blue:76 / 255.0 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:129 / 255.0 green:225 / 255.0 blue:73 / 255.0 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:243 / 255.0 green:206 / 255.0 blue:67 / 255.0 alpha:1];
    
    NSArray *titles = @[@"标题1", @"这里是标题2", @"标题3", @"这里是标题4", @"这里是标题5", @"这里是标题6"];
    [colorArr addObjectsFromArray:@[color0, color1, color2, color3, color4, color5]];
    for (int i = 0; i < titles.count; i ++) {
        TabButton *t = [[TabButton alloc] initWithBackgroundColor:colorArr[i] title:titles[i]];
        [buttonArr addObject:t];
    }
    _segmentedView = [[DFSTSegmentedView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50) buttons:buttonArr defaultIndex:_defaultIndex];
    _segmentedView.delegate = self;
    [self.view addSubview:_segmentedView];
    
    
    
    /**
     *  pan gesture
     */
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _originOffset = [gesture translationInView:self.view].x;
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        _currentOffset = [gesture translationInView:self.view].x;
        //右滑
        if (_currentOffset > _originOffset) {
            NSInteger targetIndex = _segmentedView.currentSegmentedIndex - 1 < 0 ? 5 : _segmentedView.currentSegmentedIndex - 1;
            float progress = (_currentOffset - _originOffset) / [UIScreen mainScreen].bounds.size.width * 1.0;
            [_segmentedView scrollToIndex:targetIndex progress:progress];
        }
        //左滑
        else {
            NSInteger targetIndex = _segmentedView.currentSegmentedIndex + 1 >= 6 ? 0 : _segmentedView.currentSegmentedIndex + 1;
            float progress = fabs(_currentOffset - _originOffset) / [UIScreen mainScreen].bounds.size.width * 1.0;
            [_segmentedView scrollToIndex:targetIndex progress:progress];
        }
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [_segmentedView reloadSegmentedViewWithCompeleteBlock:^(BOOL success, NSInteger currentIndex) {
            
        }];
    }
}

- (void)didSuccessScrollToIndex:(NSInteger)index {
    NSLog(@"currentIndex = %d", index);
}






@end
