## WXScrollMenu

###循环滚动菜单！

###预览图
![image](https://github.com/visoon/WXScrollMenu/blob/master/scroll.gif)

###使用方式
####初始化
```c
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
```

####回调
```c
- (void)didSuccessScrollToIndex:(NSInteger)index {
    NSLog(@"currentIndex = %d", index);
}
```

####其它方法
```c
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
```


###注意事项
如果存在bug，请提交pull request
