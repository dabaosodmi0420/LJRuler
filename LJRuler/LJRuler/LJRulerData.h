//
//  LJRulerData.h
//  LJRuler
//
//  Created by Apple on 2017/10/18.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LJRulerData : NSObject

/** 每个Item开始绘制的起始位置 */
@property (nonatomic, assign) NSInteger leading;
/** 刻度值在当前页面的rect */
@property (nonatomic, assign) CGRect rect;
/** 当前页刻度值 */
@property (nonatomic, copy) NSString *text;
/** 刻度值在下页面的rect */
@property (nonatomic, assign) CGRect nextRect;
/** 当前页刻度值 */
@property (nonatomic, copy) NSString *nextText;

@end
