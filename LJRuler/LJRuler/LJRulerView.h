//
//  LJRulerView.h
//  LJRuler
//
//  Created by Apple on 2017/10/13.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJRulerViewDlegate <NSObject>
- (void)lj_rulerViewGetCurrentValue:(CGFloat)value;

@end

@interface LJRulerView : UIView

/** 代理 */
@property (nonatomic, weak) id <LJRulerViewDlegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame perScale:(NSInteger)perScale maxScale:(NSInteger)maxScale;

- (void)lj_setValue:(CGFloat)value;
@end
