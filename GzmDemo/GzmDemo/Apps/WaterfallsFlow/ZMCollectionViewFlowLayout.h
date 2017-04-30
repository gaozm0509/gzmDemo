//
//  ZMCollectionViewFlowLayout.h
//  GzmDemo
//
//  Created by gzm on 2017/3/30.
//  Copyright © 2017年 gzm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZMCollectionViewFlowLayoutDelegate;
@interface ZMCollectionViewFlowLayout : UICollectionViewLayout


/**
 瀑布流显示的列数，默认显示两列
 */
@property (nonatomic, assign) NSUInteger columnNumbers;


/**
 每列之间的间隔距离,默认10
 */
@property (nonatomic, assign) CGFloat interval;


@property (nonatomic, weak) id<ZMCollectionViewFlowLayoutDelegate> delegate;

@end

@protocol ZMCollectionViewFlowLayoutDelegate <NSObject>

// 获取item的高度，应为默认item的宽度可以通过间隔和列数计算出来的，所以这儿只需要高度即可
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
