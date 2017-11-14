//
//  LJRulerBorderView.h
//  LJRuler
//
//  Created by Apple on 2017/10/25.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJRulerItem.h"
@interface LJRulerBorderView : LJRulerItem
- (instancetype)initWithFrame:(CGRect)frame drawText:(NSString *)text drawTextRect:(CGRect)textRect;
@end
