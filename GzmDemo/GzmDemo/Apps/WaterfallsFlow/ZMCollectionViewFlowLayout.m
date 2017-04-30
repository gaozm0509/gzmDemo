//
//  ZMCollectionViewFlowLayout.m
//  GzmDemo
//
//  Created by gzm on 2017/3/30.
//  Copyright © 2017年 gzm. All rights reserved.
//

#import "ZMCollectionViewFlowLayout.h"


@interface ZMCollectionViewFlowLayout()

@property (nonatomic, assign) NSUInteger itemsCount;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *columnsHeight; // 保存当前每一列的高度

@end

@implementation ZMCollectionViewFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        [self setupDatas];
    }
    return self;
}


#pragma mark - Overwrite

// 必须实现的父类方法
- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.itemsCount != [self.collectionView numberOfItemsInSection:0]) {
        self.itemsCount = [self.collectionView numberOfItemsInSection:0];
        self.itemWidth = (ScreenWidth - (self.interval * (self.columnNumbers + 1))) / self.columnNumbers;
    }
    
   
    
}

// 设置UICollectionView的内容大小，道理与UIScrollView的contentSize类似
- (CGSize)collectionViewContentSize {
    CGFloat contentHeight = 0;
    for (NSNumber *number in self.columnsHeight) {
        contentHeight = MAX(contentHeight, number.floatValue);
    };
    return CGSizeMake(ScreenWidth, contentHeight);
}

// 初始话Layout外观，返回所有的布局属性
// 这个方法在滑动的时候会调用
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // TODO:// 这儿可以做缓存来提高效率
    // 每次清空事前的item的height，重新计算
    [self.columnsHeight removeAllObjects];
    for (int i = 0; i < _columnNumbers; i ++) {
        [self.columnsHeight addObject:[NSNumber numberWithFloat:0]];
    }
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.itemsCount; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        
    }
    return attributes;
}

// 根据不同的indexPath，给出布局
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat itemHeight = [self.delegate collectionView:self.collectionView layout:self heightForItemAtIndexPath:indexPath];
    
    // 筛选UI上显示的最短的那一列
    __block CGFloat minHeight = [self.columnsHeight firstObject].floatValue;
    __block NSUInteger minIndex = 0;
    [self.columnsHeight enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        minHeight = MIN(minHeight, obj.floatValue);
        
        if (minHeight == obj.floatValue) {
            minIndex = idx;
        }
    }];
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];;
    CGFloat x = minIndex * (self.interval + self.itemWidth) + self.interval;
    CGFloat y = minHeight + self.interval;
    layoutAttributes.frame = CGRectMake(x, y, self.itemWidth, itemHeight);
    self.columnsHeight[minIndex] = [NSNumber numberWithFloat:self.columnsHeight[minIndex].floatValue + itemHeight + self.interval];
    
    return layoutAttributes;
}

- (void)setColumnNumbers:(NSUInteger)columnNumbers {
    _columnNumbers = columnNumbers;
    [self.columnsHeight removeAllObjects];
    for (int i = 0; i < _columnNumbers; i ++) {
        [self.columnsHeight addObject:[NSNumber numberWithFloat:0]];
    }
}

#pragma mark - pravit method

- (void)setupDatas {
    self.columnsHeight = [NSMutableArray array];
    self.columnNumbers = 2;
    
}

@end
