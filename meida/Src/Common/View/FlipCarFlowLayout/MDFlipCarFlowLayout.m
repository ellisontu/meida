//
//  MDFlipCarFlowLayout.m
//  meida
//
//  Created by ToTo on 2018/7/4.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDFlipCarFlowLayout.h"

#define kPageCardWidth 280
#define kLineSpace 10
#define kPageCardHeight 160

@interface MDFlipCarFlowLayout ()

@property (nonatomic,assign) int pageNum;

@end


@implementation MDFlipCarFlowLayout

- (void)prepareLayout{
    
    [super prepareLayout];
    //滑动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //两个cell的间距
    self.minimumLineSpacing = kLineSpace;
    //计算cell超出显示的宽度
    //CGFloat width = ((SCR_WIDTH - kPageCardWidth) - (kLineSpace*2))/2;
    //每个section的间距
    self.sectionInset = UIEdgeInsetsMake(0, kLineSpace, 0, 0);
    //每个cell实际的大小
    self.itemSize = CGSizeMake(kPageCardWidth,kPageCardHeight);
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *superAttributes = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributes = [[NSArray alloc] initWithArray:superAttributes copyItems:YES];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    self.collectionView.frame.size.width,
                                    self.collectionView.frame.size.height);
    CGFloat offset = CGRectGetMidX(visibleRect);
    
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attribute, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat distance = offset - attribute.center.x;
        // 越往中心移动，值越小，那么缩放就越小，从而显示就越大
        // 同样，超过中心后，越往左、右走，缩放就越大，显示就越小
        CGFloat scaleForDistance = distance / self.itemSize.width;
        // 0.1可调整，值越大，显示就越大
        CGFloat scaleForCell = 1 + 0.1 * (1 - fabs(scaleForDistance));
        
        //只在Y轴方向做缩放
        attribute.transform3D =  CATransform3DMakeScale(1, scaleForCell, 1);
        attribute.zIndex = 1;
        
        //渐变
        CGFloat scaleForAlpha = 1 - fabs(scaleForDistance) * 0.6f;
        attribute.alpha = scaleForAlpha;
    }];
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 分页以1/3处
    if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 3.0) {
        self.previousOffsetX += kPageCardWidth+kLineSpace ;
        self.pageNum = self.previousOffsetX/(kPageCardWidth+kLineSpace);
        if ([self.delegate respondsToSelector:@selector(scrollToIndex:)]) {
            [self.delegate scrollToIndex:self.pageNum];
        }
    }
    else if (proposedContentOffset.x < self.previousOffsetX  - self.itemSize.width / 3.0) {
        self.previousOffsetX -= kPageCardWidth+kLineSpace;
        self.pageNum = self.previousOffsetX/(kPageCardWidth+kLineSpace);
        if ([self.delegate respondsToSelector:@selector(scrollToIndex:)]) {
            [self.delegate scrollToIndex:self.pageNum];
        }
    }
    //将当前cell移动到屏幕中间位置
    proposedContentOffset.x = self.previousOffsetX;
    
    return proposedContentOffset;
}

@end



@interface MDFlipCarCellView ()

@property (nonatomic, strong) UIImageView       *showImgView;

@end


@implementation MDFlipCarCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.contentView.backgroundColor = COLOR_WITH_WHITE;
    
    _showImgView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:_showImgView];
    
    [_showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _showImgView.contentMode = UIViewContentModeScaleAspectFill;
    _showImgView.layer.masksToBounds = YES;
    
    [_showImgView imageWithUrlStr:@"https://pro.modao.cc/uploads3/images/1665/16650985/raw_1516589142.png" placeholderImage:IMAGE(@"")];
    
}

@end
