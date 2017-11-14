//
//  LJRulerView.m
//  LJRuler
//
//  Created by Apple on 2017/10/13.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "LJRulerView.h"
#import "LJRulerItem.h"
#import "LJRulerInfo.h"
#import "LJRulerData.h"

#define LJRulerCellIden @"LJRulerCell"
@interface LJRulerView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

/** 标尺信息 */
@property (nonatomic, strong) LJRulerInfo *rulerInfo;

/** 滚动尺子 */
@property (nonatomic, strong) UICollectionView *collectionView;

/** 标线 */
@property (nonatomic, strong) UIView *graticuleView;

/** item尺寸 */
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation LJRulerView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return [super hitTest:point withEvent:event];
}
- (instancetype)initWithFrame:(CGRect)frame perScale:(NSInteger)perScale maxScale:(NSInteger)maxScale{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.collectionView];
        [self addSubview:self.graticuleView];
        self.itemSize = self.collectionView.bounds.size;
        self.rulerInfo = [LJRulerInfo shareRulerInfo];
        [self.rulerInfo setWidth:self.collectionView.frame.size.width heigh:self.collectionView.frame.size.height perScale:perScale maxScale:maxScale mainScr:self.collectionView];
        [self.collectionView reloadData];
    }
    return self;
}
#pragma mark - activity
- (void)lj_setValue:(CGFloat)value{
    LJRulerInfo *info = [LJRulerInfo shareRulerInfo];
    [info setCurrentValue:value];
}
#pragma mark - collectionViewDataSource && collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.rulerInfo.datas.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LJRulerCellIden forIndexPath:indexPath];
    LJRulerItem *item = (LJRulerItem *)[cell viewWithTag:101];
    if (!item) {
        item = [[LJRulerItem alloc]initWithFrame:CGRectMake(0, 0, self.itemSize.width, self.itemSize.height)];
        item.tag = 101;
        [cell.contentView addSubview:item];
    }
    item.index = indexPath.row;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    LJRulerInfo *info = [LJRulerInfo shareRulerInfo];
    if ([self.delegate respondsToSelector:@selector(lj_rulerViewGetCurrentValue:)]) {
        [self.delegate lj_rulerViewGetCurrentValue:info.currentValue];
    }
}
#pragma mark - setting&getting
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LJRulerCellIden];
        
    }
    return _collectionView;
}
- (UIView *)graticuleView{
    if (!_graticuleView) {
        _graticuleView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 1, 0, 2, self.frame.size.height)];
        _graticuleView.backgroundColor = [UIColor redColor];
    }
    return _graticuleView;
}
@end
