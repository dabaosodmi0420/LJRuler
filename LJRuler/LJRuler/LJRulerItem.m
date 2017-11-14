//
//  LJRulerItem.m
//  LJRuler
//
//  Created by Apple on 2017/10/16.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "LJRulerItem.h"
#import "LJRulerInfo.h"

@interface LJRulerItem()

@property (nonatomic, assign)NSInteger leading;

@end

@implementation LJRulerItem

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self setup];
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    if (_index != index) {
        _index = index;
        [self setNeedsDisplay];
    }
    
}
- (void)setup{
    _index = 0;
    LJRulerInfo *info = [LJRulerInfo shareRulerInfo];
    NSInteger majorScaleDistance = info.scaleDistance * 10;
    NSMutableArray *datas = info.datas;
    LJRulerData *data = datas[0];
    for (long i = data.leading; i <= info.rulerRange; i += majorScaleDistance) {
        CGFloat x = i % info.rulerWidth;
        if(x == 0) continue;
        NSString *text = [NSString stringWithFormat:@"%0.1f",(i - info.rulerWidth * 0.5) * info.perScale / info.scaleDistance];
        CGRect textRect = [info calculateStringRectWithText:text atPoint:CGPointMake(x, info.rulerHeight - info.majorScaleLength - 1) textFont:info.font trokeWidth:@(info.textStrokeWidth)];
        NSInteger idx = i / info.rulerWidth;
        if ([self isWithinItem:textRect withX:0]) {
            if(idx == 0) continue;
            LJRulerData *data = datas[idx - 1];
            data.nextText = text;
            data.nextRect = CGRectMake(info.rulerWidth + textRect.origin.x, textRect.origin.y, textRect.size.width, textRect.size.height);
        }else if ([self isWithinItem:textRect withX:info.rulerWidth]) {
            if (idx == datas.count - 1){
                return;
            }
            LJRulerData *data = datas[idx + 1];
            data.text = text;
            data.rect = CGRectMake(textRect.origin.x - info.rulerWidth, textRect.origin.y, textRect.size.width, textRect.size.height);
        }
    }
}
/** 判断文字是否能完全显示在item之内 */
- (BOOL)isWithinItem:(CGRect)rect withX:(CGFloat)x{
    CGFloat begin = rect.origin.x;
    CGFloat end = rect.origin.x + rect.size.width;
    if (begin < x && end > x) {
        return YES;
    }
    return NO;
}
- (NSInteger)leading{
    return [[LJRulerInfo shareRulerInfo].datas objectAtIndex:_index].leading;
}
- (NSInteger)leadingWithIdx:(NSInteger)idx{
    return [[LJRulerInfo shareRulerInfo].datas objectAtIndex:idx].leading;
}
/** 是否是主要刻度 */
- (BOOL)isMajorScaleWithX:(NSInteger)x{
    LJRulerInfo *info = [LJRulerInfo shareRulerInfo];
    NSInteger temp;
    if (_index == 0) {
        temp = x - [self leadingWithIdx:0];
    }else if(_index == 1){
        temp = x + [self leadingWithIdx:0];
    }else{
        temp = x + info.rulerWidth / 2  + (_index - 1) * info.rulerWidth;
    }
    if((NSInteger)((temp / info.scaleDistance) * 10) % 100  == 0){
        return YES;
    }else{
        return NO;
    }
    
}
/** 绘制文本 */
- (void)drawLabelWithCtx:(CGContextRef)ctx text:(NSString *)text atPoint:(CGPoint)atPoint textColor:(UIColor *)textColor{
    LJRulerInfo *info = [LJRulerInfo shareRulerInfo];
    CGRect textR = [info calculateStringRectWithText:text atPoint:atPoint textFont:info.font trokeWidth:@(info.textStrokeWidth)];
    
    [self drawLabelWithCtx:ctx text:text textRect:textR textFont:info.font textColor:info.scaleTextColor strokeWidth:info.textStrokeWidth];
}

- (void)drawLabelWithCtx:(CGContextRef)ctx text:(NSString *)text textRect:(CGRect)textRect textFont:(UIFont *)textFont textColor:(UIColor *)textColor strokeWidth:(CGFloat)strokeWidth{
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, textColor.CGColor);
    CGContextSetFillColorWithColor(ctx, textColor.CGColor);
    CGContextSetLineWidth(ctx, strokeWidth);
    CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
    
    /** NSStrokeWidthAttributeName : 对应的数值，正数只改变描边宽度。负数同时改变文字的描边和填充宽度 */
    [text drawInRect:textRect withAttributes:@{NSFontAttributeName : textFont, NSForegroundColorAttributeName : textColor,NSStrokeColorAttributeName : textColor, NSStrokeWidthAttributeName : @(-strokeWidth)}];
    CGContextRestoreGState(ctx);
}
- (void)drawLabelWithCtx:(CGContextRef)ctx x:(NSInteger)x{
    LJRulerInfo *info = [LJRulerInfo shareRulerInfo];
    NSInteger temp;
    if (_index == 0) {
        temp = x - info.rulerWidth / 2;
    }else{
        temp = x + (_index - 1)* info.rulerWidth + info.rulerWidth / 2;
    }
    NSString *text = [NSString stringWithFormat:@"%0.1f",[info getCurrentValueWithOffset_X:temp]];
    
    [self drawLabelWithCtx:ctx text:text atPoint:CGPointMake(x, info.rulerHeight - info.majorScaleLength - 1) textColor:info.scaleTextColor];
    
    NSLog(@"%ld-文本--%@",_index,text);
}

/** 绘制刻度线 */
- (void)drawScaleLineWithCtx:(CGContextRef)ctx x:(NSInteger)x{
    LJRulerInfo *info = [LJRulerInfo shareRulerInfo];
    
    CGPoint startP = CGPointMake(x, info.rulerHeight);
    CGPoint endP = CGPointZero;
    // 是主要刻度
    if ([self isMajorScaleWithX:x]) {
        endP = CGPointMake(x, info.rulerHeight - info.majorScaleLength);
        [self drawLabelWithCtx:ctx x:x];
    }else{
        endP = CGPointMake(x, info.rulerHeight - info.minorScaleLength);
    }
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, info.minorScaleWidth);
    CGContextSetStrokeColorWithColor(ctx, info.minorLineColor.CGColor);
    CGContextMoveToPoint(ctx, startP.x, startP.y);
    CGContextAddLineToPoint(ctx, endP.x, endP.y);
    
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
}

- (void)drawRect:(CGRect)rect {
    LJRulerInfo *info = [LJRulerInfo shareRulerInfo];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    
    [info.bgColor setFill];
    CGContextFillRect(ctx, rect);
    
    
    NSInteger width;
    if (info.datas.count == 0) {
        return;
    }
    if (_index == info.datas.count - 1) {
        width = info.finalScaleLoc;
    }else{
        width = info.rulerWidth;
    }
    /** 绘制 */
    // x对应的是当前item的x值
    for (long x = self.leading; x <= width; x += info.scaleDistance) {
        [self drawScaleLineWithCtx:ctx x:x];
    }
    /** 绘制被分割的文字 */
    LJRulerData *data = info.datas[_index];
    if (data.text) {
        [self drawLabelWithCtx:ctx text:data.text textRect:data.rect textFont:info.font textColor:info.scaleTextColor strokeWidth:info.textStrokeWidth];
    }else if (data.nextText){
        [self drawLabelWithCtx:ctx text:data.nextText textRect:data.nextRect textFont:info.font textColor:info.scaleTextColor strokeWidth:info.textStrokeWidth];
    }
}

@end
