//
//  LJRulerBorderView.m
//  LJRuler
//
//  Created by Apple on 2017/10/25.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "LJRulerBorderView.h"
#import "LJRulerInfo.h"
@interface LJRulerBorderView(){
    NSString *_text;
    CGRect _textRect;
}

@end

@implementation LJRulerBorderView

- (instancetype)initWithFrame:(CGRect)frame drawText:(NSString *)text drawTextRect:(CGRect)textRect{
    if (self = [super initWithFrame:frame]) {
        _textRect = textRect;
        _text = text;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    LJRulerInfo *info = [LJRulerInfo shareRulerInfo];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [info.bgColor setFill];
    CGContextFillRect(ctx, rect);
    
    [self drawLabelWithCtx:ctx text:_text textRect:_textRect textFont:info.font textColor:info.scaleTextColor strokeWidth:info.textStrokeWidth];

}


@end
