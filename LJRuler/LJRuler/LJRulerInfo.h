//
//  LJRulerInfo.h
//  LJRuler
//
//  Created by Apple on 2017/10/18.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LJRulerData.h"

@interface LJRulerInfo : NSObject

#pragma mark - 属性
/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *mainScr;

/** 文本的字体 */
@property (nonatomic, strong, readonly) UIFont *font;

/** 小刻度线颜色 */
@property (nonatomic, strong, readonly) UIColor *minorLineColor;
/** 主要刻度线颜色 */
@property (nonatomic, strong, readonly) UIColor *majorLineColor;
/** 刻度文本颜色 */
@property (nonatomic, strong, readonly) UIColor *scaleTextColor;
/** 文本线宽 */
@property (nonatomic, assign, readonly) CGFloat textStrokeWidth;
/** 背景颜色 */
@property (nonatomic, strong, readonly) UIColor *bgColor;
/** 每个刻度的距离 */
@property (nonatomic, assign, readonly) CGFloat scaleDistance;
/** 小刻度线长 */
@property (nonatomic, assign, readonly) CGFloat minorScaleLength;
/** 小刻度线宽 */
@property (nonatomic, assign, readonly) CGFloat minorScaleWidth;
/** 主要刻度线长 */
@property (nonatomic, assign, readonly) CGFloat majorScaleLength;
/** 主要刻度线宽  */
@property (nonatomic, assign, readonly) CGFloat majorScaleWidth;
/** 标尺宽度 */
@property (nonatomic, assign, readonly) NSInteger rulerWidth;
/** 标尺高度  */
@property (nonatomic, assign, readonly) NSInteger rulerHeight;
/** 标尺的最大位置（刻度尺的总长 + 0刻度之前的距离） */
@property (nonatomic, assign, readonly) NSInteger rulerRange;
/** 每个刻度的数值 */
@property (nonatomic, assign, readonly) NSInteger perScale;
/** 最后一位刻度 */
@property (nonatomic, assign, readonly) NSInteger finalScaleLoc;
/** rulerData数组 */
@property (nonatomic, strong) NSMutableArray <LJRulerData *> *datas;
/** 当前值 */
@property (nonatomic, assign, readonly) CGFloat currentValue;

#pragma mark - 方法
/** 初始化 */
+ (instancetype)shareRulerInfo;
/** 设置基本参数 */
- (void)setWidth:(NSInteger)width heigh:(NSInteger)heigh perScale:(NSInteger)perScale maxScale:(NSInteger)maxScale mainScr:(UIScrollView *)mainScr;
/** 当前刻度值 */
- (CGFloat)getCurrentValueWithOffset_X:(CGFloat)x;
/**  设置数值 */
- (void)setCurrentValue:(CGFloat)value;
/** 计算文本尺寸 */
- (CGRect)calculateStringRectWithText:(NSString *)text atPoint:(CGPoint)atPoint textFont:(UIFont *)textFont  trokeWidth:(NSNumber *)trokeWidth;
@end
