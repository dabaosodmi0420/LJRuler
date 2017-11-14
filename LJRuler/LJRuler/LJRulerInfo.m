//
//  LJRulerInfo.m
//  LJRuler
//
//  Created by Apple on 2017/10/18.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "LJRulerInfo.h"
#import "LJRulerBorderView.h"
NSString        *kDefaultFontName           = @"Helvetica";//默认字体
const NSInteger kDefaultLabelFontSize       = 15;//默认刻度label字体大小

const CGFloat   kDefaultScaleDistance       = 10.0f;//默认刻度间距离

const CGFloat   kDefaultMinorScaleLength    = 10.0f;//默认小刻度线长度
const CGFloat   kDefaultMinorScaleWidth     = 1.0f;//默认小刻度线宽度

const CGFloat   kDefaultMajorScaleLength    = 15.0f;//默认大刻度线长度
const CGFloat   kDefaultMagorScaleWidth     = 1.0f;//默认大刻度线宽度

const CGFloat   kDefaultTextStrokeWidth     = 1.0;//默认文字线宽

@interface LJRulerInfo(){
    NSInteger _maxScale;
}

@end

@implementation LJRulerInfo

+ (instancetype)shareRulerInfo{
    static LJRulerInfo *rulerInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rulerInfo = [[LJRulerInfo alloc]init];
        [rulerInfo setup];
    });
    return rulerInfo;
}
- (void)setup{
    _font = [UIFont fontWithName:kDefaultFontName size:kDefaultLabelFontSize];
    _scaleDistance      = kDefaultScaleDistance;
    _minorScaleLength   = kDefaultMinorScaleLength;
    _minorScaleWidth    = kDefaultMinorScaleWidth;
    _majorScaleLength   = kDefaultMajorScaleLength;
    _majorScaleWidth    = kDefaultMagorScaleWidth;
    _textStrokeWidth    = kDefaultTextStrokeWidth;
    _minorLineColor     = [UIColor grayColor];
    _majorLineColor     = [UIColor grayColor];
    _scaleTextColor     = [UIColor grayColor];
    _bgColor            = [UIColor yellowColor];
}

- (void)setCurrentValue:(CGFloat)value{
    CGFloat temp = 0;
    if (value < 0) {
        temp = 0;
    }else if (value > _maxScale){
        value = _maxScale;
    }
    if (self.mainScr) {
        CGFloat x = value * _scaleDistance / _perScale;
        [self.mainScr setContentOffset:CGPointMake(x, 0) animated:YES];
    }
}
/** 当前刻度值 */
- (CGFloat)getCurrentValueWithOffset_X:(CGFloat)x{
    if (self.mainScr) {
        return x * ((CGFloat)_perScale / _scaleDistance);
    }
    return 0;
}
- (CGFloat)currentValue{
    if (self.mainScr) {
        return [self getCurrentValueWithOffset_X:self.mainScr.contentOffset.x];
    }
    return 0;
}

- (void)setWidth:(NSInteger)width heigh:(NSInteger)heigh perScale:(NSInteger)perScale maxScale:(NSInteger)maxScale mainScr:(UIScrollView *)mainScr{
    _mainScr = mainScr;
    _rulerWidth = width % 2 == 0 ? width : width + 1;
    _rulerHeight = heigh;
    _perScale = perScale;
    _rulerRange = _scaleDistance * ((double)maxScale / perScale) + _rulerWidth / 2;
    _maxScale = maxScale;
    _mainScr = mainScr;
    _mainScr.backgroundColor = _bgColor;
    [self calculateData];
}
/** 计算文本尺寸 */
- (CGRect)calculateStringRectWithText:(NSString *)text atPoint:(CGPoint)atPoint textFont:(UIFont *)textFont  trokeWidth:(NSNumber *)trokeWidth{
    CGSize tempSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : textFont, NSStrokeWidthAttributeName : trokeWidth} context:nil].size;
    CGRect rect = CGRectMake(atPoint.x - tempSize.width * 0.5, atPoint.y - tempSize.height, tempSize.width, tempSize.height);
    return rect;
}
- (void)calculateData{
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    /** 计算每个item绘画的起始位置 */
    LJRulerData *data = [LJRulerData new];
    data.leading = _rulerWidth * 0.5;
    [_datas addObject:data];
    NSInteger idx = 0;
    for (long x = _rulerWidth * 0.5; x <= _rulerRange; x += _scaleDistance) {
        NSInteger temp = x / _rulerWidth;
        if (temp != idx) {
            LJRulerData *data = [LJRulerData new];
            data.leading = x % _rulerWidth;
            [_datas addObject:data];
            idx = temp;
        }
    }

    /** 判断最后一个文本是的超出界限 */
    BOOL isBorder = NO;
    NSString *text;
    CGRect rect = CGRectZero;
    for (long x = _maxScale / _perScale * _scaleDistance + _rulerWidth * 0.5; x >= _rulerWidth / 2; x -= _scaleDistance) {
        CGFloat value = [self getCurrentValueWithOffset_X:x - _rulerWidth / 2];
        NSInteger step = _scaleDistance * 10;
        if((NSInteger)(x - _rulerWidth * 0.5) % step == 0){
            NSString *textT = [NSString stringWithFormat:@"%0.1f",value];
            CGRect rectT = [self calculateStringRectWithText:textT atPoint:CGPointMake(x, _rulerHeight - _majorScaleLength - 1) textFont:_font trokeWidth:@(_textStrokeWidth)];
            if ((rectT.size.width + rectT.origin.x) > (_datas.count ) * _rulerWidth) {
                isBorder = YES;
                text = textT;
                rect = CGRectMake(rectT.origin.x - _datas.count * _rulerWidth, rectT.origin.y, rectT.size.width, rectT.size.height);
            }
            break;
        }
    }
    /** 计算最后刻度的位置 */
    if (self.datas != 0) {
        if (self.datas.count == 1) {
            _finalScaleLoc = _rulerRange;
        }else{
            _finalScaleLoc = _rulerRange - (self.datas.count - 1) * _rulerWidth ;
        }
        if (_finalScaleLoc >= _rulerWidth * 0.5) {
            _mainScr.contentInset = UIEdgeInsetsMake(0, 0, 0, _finalScaleLoc - _rulerWidth * 0.5);
            if (isBorder) {
                LJRulerBorderView *borderView = [[LJRulerBorderView alloc]initWithFrame:CGRectMake(_datas.count * _rulerWidth, 0, _mainScr.contentInset.right, _rulerHeight) drawText:text drawTextRect:rect];
                [_mainScr addSubview:borderView];
            }
        }else{
            [_mainScr addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGPoint newPoint;
    id newValue = [ change valueForKey:NSKeyValueChangeNewKey];
     [(NSValue*)newValue getValue:&newPoint ];
    if (newPoint.x > (_rulerRange - _rulerWidth * 0.5)) {
        [_mainScr setContentOffset:CGPointMake(_rulerRange - _rulerWidth * 0.5, 0) animated:NO];
    }
}
@end
