//
//  LJRulerItem.h
//  LJRuler
//
//  Created by Apple on 2017/10/16.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LJRulerItem : UIView

/** 索引 */
@property (nonatomic, assign) NSInteger index;

- (void)drawLabelWithCtx:(CGContextRef)ctx text:(NSString *)text textRect:(CGRect)textRect textFont:(UIFont *)textFont textColor:(UIColor *)textColor strokeWidth:(CGFloat)strokeWidth;

@end
