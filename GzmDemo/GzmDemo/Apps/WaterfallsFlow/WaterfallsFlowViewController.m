//
//  WaterfallsFlowViewController.m
//  GzmDemo
//
//  Created by gzm on 2017/3/30.
//  Copyright © 2017年 gzm. All rights reserved.
//

#import "WaterfallsFlowViewController.h"
#import "ZMCollectionViewFlowLayout.h"

@interface WaterfallsFlowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZMCollectionViewFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collecionView;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *dataList;

@end

@implementation WaterfallsFlowViewController

#pragma mark - life cycle

- (void)dealloc {
    NSLog(@"%s",__func__);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    [self setupDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - getter

- (UICollectionView *)collecionView {
    if (!_collecionView) {
        ZMCollectionViewFlowLayout *layout = [[ZMCollectionViewFlowLayout alloc] init];
        layout.delegate = self;
        layout.interval = 1;
        layout.columnNumbers = 3; // 显示的列数
        
        _collecionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collecionView.dataSource = self;
        _collecionView.delegate = self;
    }
    return _collecionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
        for (int i = 0; i < 20; i ++) {
            [_dataList addObject:[NSNumber numberWithFloat:[self getRandomNumber:50 to:200]]];
        }
    }
    return _dataList;
}

#pragma mark - setter

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor randomColor];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataList[indexPath.row].floatValue; // 返回每个item的高度
}

#pragma mark - delegate



#pragma mark - event


#pragma mark - pravit method

- (void)setupDatas {
    
}
- (void)setupSubViews {
    [self.view addSubview:self.collecionView];
    [self.collecionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

// 生成一个随机数
- (CGFloat)getRandomNumber:(int)from to:(int)to
{
    return (CGFloat)(from + (arc4random() % (to - from + 1)));
}

@end
