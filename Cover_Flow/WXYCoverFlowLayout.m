//
//  WXYCoverFlowLayout.m
//  Cover_Flow
//
//  Created by mac on 16/7/16.
//  Copyright © 2016年 wxy. All rights reserved.
//

#import "WXYCoverFlowLayout.h"

@implementation WXYCoverFlowLayout

- (void)prepareLayout {

  //设置item大小
  CGFloat itemSide = self.collectionView.bounds.size.height * 0.8;
  self.itemSize = CGSizeMake(itemSide, itemSide);

  //设置横向滚动
  self.scrollDirection = UICollectionViewScrollDirectionHorizontal;

  //内边的间距
  CGFloat inset = (self.collectionView.bounds.size.width - itemSide) * 0.5;

  self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);

  self.collectionView.backgroundColor = [UIColor whiteColor];

  self.collectionView.showsHorizontalScrollIndicator = NO;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)
layoutAttributesForElementsInRect:(CGRect)rect {

  //系统的参数数据
  NSArray *tempAttrs = [super layoutAttributesForElementsInRect:rect];

  //创建深拷贝数组
  NSMutableArray *attrs =
      [[NSMutableArray alloc] initWithArray:tempAttrs copyItems:YES];

  //获取屏幕的中心位置
  CGFloat centerX = self.collectionView.contentOffset.x +
                    self.collectionView.bounds.size.width * 0.5;

  //修改布局的参数
  for (int i = 0; i < attrs.count; i++) {
    //获取layout的参数
    UICollectionViewLayoutAttributes *attr = attrs[i];

    //获取cell的中心
    CGFloat attrContentX = attr.center.x;

    //计算cell的中心到 collectionView的中心
    CGFloat attrDis = attrContentX - centerX;

    //获取距离的绝对值
    CGFloat attrDisABS = ABS(attrDis);

    //创建默认的矩阵
    CATransform3D transform = CATransform3DIdentity;

    //根据距离  计算缩放比例
    CGFloat scale = -0.0025 * attrDisABS + 1;

    //在空白的矩阵的基础上  让矩阵进行缩放
    transform = CATransform3DScale(transform, scale, scale, 1);

    //根据距离 计算旋转的角度
    CGFloat rotate = M_PI_4 / 200 * attrDis + 0;

    //在缩放的基础上  修改m34
    transform.m34 = -0.1 / 800;

    //在m34的基础上  修改旋转
    transform = CATransform3DRotate(transform, -rotate, 0, 1, 0);

    attr.transform3D = transform;
  }

  return attrs;
}

//每次松手以后  期望的offset的点

- (CGPoint)targetContentOffsetForProposedContentOffset:
               (CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {

  // 获取 期望显示的区域
  CGRect proposedRect =
      CGRectMake(proposedContentOffset.x, proposedContentOffset.y,
                 self.collectionView.bounds.size.width,
                 self.collectionView.bounds.size.height);

  // 根据期望显示的区域 可以获取 附近需要计算的cell的attr
  NSArray *proposedAttrs =
      [self layoutAttributesForElementsInRect:proposedRect];

  // 获取期望的contentOffsetX
  CGFloat proposedContentOffsetX = proposedContentOffset.x;

  // 屏幕的中心
  CGFloat centerX =
      proposedContentOffsetX + self.collectionView.bounds.size.width * .5;

  // 左侧的位置
  CGFloat leftX =
      centerX - (self.itemSize.width + self.minimumLineSpacing) * .5;

  // 右侧的位置
  CGFloat rightX =
      centerX + (self.itemSize.width + self.minimumLineSpacing) * .5;

  // 记录距离(可能是正可能是负)
  CGFloat flagDis = 0;

  for (int i = 0; i < proposedAttrs.count; i++) {
    // 获取某一个cell
    UICollectionViewLayoutAttributes *attr = proposedAttrs[i];

    if (attr.center.x > leftX && attr.center.x < rightX) {
      flagDis = attr.center.x - centerX;
    }
  }

  return CGPointMake(proposedContentOffsetX + flagDis, 0);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return YES;
}

@end
