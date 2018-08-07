//
//  MDChoosePhotoCell.m
//  meida
//
//  Created by ToTo on 2018/8/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDChoosePhotoCell.h"
#import "MediaAssetModel.h"
#import "MediaResourcesManager.h"

@interface MDChoosePhotoCell ()

@property (nonatomic, strong) UIImageView   *photoImg;
@property (nonatomic, strong) UIButton      *markBtn;

@end

@implementation MDChoosePhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    
    return self;
}


#pragma mark - UI
- (void)setupSubviews
{
    _photoImg = [UIImageView newAutoLayoutView];
    [self.contentView addSubview:_photoImg];
    _photoImg.userInteractionEnabled = YES;
    _photoImg.contentMode = UIViewContentModeScaleAspectFill;
    _photoImg.clipsToBounds = YES;
    [_photoImg autoPinEdgesToSuperviewEdges];
    
    _markBtn = [UIButton newAutoLayoutView];
    [_photoImg addSubview:_markBtn];
    [_markBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_markBtn autoSetDimensionsToSize:CGSizeMake(44, 44)];
    [_markBtn autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_markBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
}

- (void)clickSelectBtn:(UIButton *)sender
{
    // 当到达最大数量 9 并且继续添加则不进行处理
    if (_selectArr.count == _maxSelectCount && (_model.selected == NO)) {
        NSString *countStr = [NSString stringWithFormat:@"最多选择%zd张图片哦~",_maxSelectCount];
        [Util showMessage:countStr inView:MDAPPDELEGATE.window];
        return;
    }
    
    if (_model.isCloudImage) {
        [Util showMessage:@"这张图片保存在iCloud上,快去相册下载高清图吧~" inView:MDAPPDELEGATE.window];
        return ;
    }
    // 更新按钮状态
    _model.selected = !_model.selected;
    [self updateTheMarkBtnStatus];
    // 更新数据
    NSInteger index = [[MediaResourcesManager shareInstance] checkChooseAssetsWithModel:_model selectArr:self.selectArr];
    if (index > -1) {
        [_selectArr removeObjectAtIndex:index];
    }
    else {
        [_selectArr addObject:_model];
    }
    
    // 控制器更新数组
    if (self.choosePhotoCellCallBack) {
        self.choosePhotoCellCallBack();
    }
    
    // 埋点数据
    UserAnalyticsModel *analyzeModel = [[UserAnalyticsModel alloc] init];
    [analyzeModel uploadEditVideoAndPhotoInfoWithPhase:@"3" subPhase:@"1" functionType:3];
}

- (void)updateTheMarkBtnStatus
{
    if (_model.selected) {
        [_markBtn setImage:IMAGE(@"video_selected") forState:UIControlStateNormal];
    }
    else {
        [_markBtn setImage:IMAGE(@"video_unselected") forState:UIControlStateNormal];
    }
}


#pragma mark - setter
- (void)setModel:(MediaAssetModel *)model
{
    _model = model;
    
    self.photoImg.image = _model.thumbnailImage;
    [self updateTheMarkBtnStatus];
}


@end
