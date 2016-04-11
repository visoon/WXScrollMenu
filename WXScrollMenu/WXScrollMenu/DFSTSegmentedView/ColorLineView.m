//
//  ColorLineView.m
//  test
//
//  Created by vison on 16/3/30.
//  Copyright © 2016年 DFST. All rights reserved.
//

#import "ColorLineView.h"

static float during = 0.3f;

@interface ColorLineView ()
@property (nonatomic, strong)UIColor *currentColor;
@end

@implementation ColorLineView


- (void)changeToColor:(UIColor *)color progress:(float)progress {
    if (progress >= 1) {
        self.currentColor = color;
        self.backgroundColor = self.currentColor;
    }
    
    CGFloat currentR, currentG, currentB;
    CGFloat targetR, targetG, targetB;

    size_t targetNumComponents = CGColorGetNumberOfComponents(color.CGColor);
    size_t currentNumComponents = CGColorGetNumberOfComponents(self.currentColor.CGColor);
    
    
    if (targetNumComponents == 4 && currentNumComponents == 4)
    {
        const CGFloat *targetComponents = CGColorGetComponents(color.CGColor);
        const CGFloat *currentComponents = CGColorGetComponents(self.currentColor.CGColor);
        
        currentR = currentComponents[0];
        currentG = currentComponents[1];
        currentB = currentComponents[2];
        
        targetR = targetComponents[0];
        targetG = targetComponents[1];
        targetB = targetComponents[2];
    }
    
    CGFloat progressR = currentR + (progress * (targetR - currentR));
    CGFloat progressG = currentG + (progress * (targetG - currentG));
    CGFloat progressB = currentB + (progress * (targetB - currentB));
    
    self.backgroundColor = [UIColor colorWithRed:progressR green:progressG blue:progressB alpha:1];
}

- (void)changeToColor:(UIColor *)color {
    [UIView animateWithDuration:during animations:^{
        self.backgroundColor = color;
    }completion:^(BOOL finished) {
        self.currentColor = color;
    }];
}

- (UIColor *)currentColor {
    if (!_currentColor) {
        _currentColor = [UIColor colorWithCGColor:self.backgroundColor.CGColor];
    }
    return _currentColor;
}

@end
