//
//  MDChoosePhotosCtrl.m
//  meida
//
//  Created by ToTo on 2018/8/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDChoosePhotosCtrl.h"
#import "MDShootPhotoCtrl.h"

#import "MediaAlbumsModel.h"
#import "MediaAssetModel.h"

#import "MDPhotoAlbumListView.h"
#import "MDChoosePhotoCell.h"
#import "UIImage+Capture.h"

#import "MediaResourcesManager.h"
#import "LocalFileManager.h"

static NSString *MDChoosePhotoCellID = @"MDChoosePhotoCell";
@interface MDChoosePhotosCtrl ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton          *titleBtn;      /**< 标题(相册名称) */
@property (nonatomic, strong) UIButton          *arrowBtn;      /**< 可旋转箭头 */
@property (nonatomic, strong) UIButton          *addCountBtn;   /**< 下一步 添加计数 */
@property (nonatomic, strong) UIImageView       *shootImgView;  /**< 拍摄按钮 */

@property (nonatomic, strong) NSMutableArray    *albumListArr;  /**< 专辑列表 */
@property (nonatomic, strong) NSMutableArray    *photoArr;      /**< 指定专辑内的图片 */
@property (nonatomic, assign) NSInteger         albumSelectIdx; /**< 选中的专辑 */
@property (nonatomic, strong) NSMutableArray    *selectArr;     /**< 选中的图片 */
@property (nonatomic, strong) PHAsset           *shootAssets;   /**< 刚拍的那个照片 */
#pragma mark - 添加图片专用
@property (nonatomic, assign) NSInteger         maxSelectCount; /**< 最大选择数量 */

@end

@implementation MDChoosePhotosCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubviews];
    [self loadAlbumListWithShootBlock:NO];
    
    if (arrayIsEmpty(self.publishArr)) {
        _maxSelectCount = 9;
    }
    else {
        _maxSelectCount = 9 - self.publishArr.count;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
    [self updateTheAddCountBtnCount];
}

#pragma mark - 载入本地数据
- (void)loadAlbumListWithShootBlock:(BOOL)isShoot
{
    _albumSelectIdx = 0;
    [_albumListArr removeAllObjects];
    MDWeakPtr(weakPtr, self);
    if ([MediaResourcesManager canAccessAlbumsAndCamera]) {
        // 获取相册列表信息
        [MediaResourcesManager fetchAlbums:^(NSArray<MediaAlbumsModel *> * _Nonnull albums, BOOL success) {
            
            if (success) {
                [weakPtr.albumListArr addObjectsFromArray:albums];
                [weakPtr.albumListArr sortUsingComparator:^NSComparisonResult(MediaAlbumsModel *obj1, MediaAlbumsModel *obj2) {
                    if(obj1.assetCount > obj2.assetCount) {
                        return NSOrderedAscending;
                    }
                    return NSOrderedDescending;
                }];
                
                if (!arrayIsEmpty(weakPtr.albumListArr)) {
                    [weakPtr loadPhotoListWithShootBlock:isShoot];
                }
            }
            else {
                XLog(@"相册列表没获取着啊");
            }
        }];
    }
}

- (void)loadPhotoListWithShootBlock:(BOOL)isShoot
{
    MediaAlbumsModel *model = self.albumListArr[_albumSelectIdx];
    NSString *titleStr = model.name;
    if (titleStr.length > 8) {
        titleStr = [[titleStr substringToIndex:8] stringByAppendingString:@"..."];
    }
    [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];
    // 获取相册内assets
    MDWeakPtr(weakPtr, self);
    [MediaResourcesManager fetchAssetsWithAlbum:model completion:^(NSArray<MediaAssetModel *> * _Nonnull assets, BOOL success) {
        
        if (success) {
            [weakPtr.photoArr removeAllObjects];
            [weakPtr.photoArr addObjectsFromArray:assets];
            // 遍历标记
            [weakPtr AddTagToSelectedImagesWithIsShoot:isShoot];
            [weakPtr.collectionView reloadData];
        }
        else {
            XLog(@"assets没获取着啊");
        }
    }];
}

- (void)AddTagToSelectedImagesWithIsShoot:(BOOL)isShoot
{
    for (int i = 0; i < self.photoArr.count; i ++) {
        MediaAssetModel *model = self.photoArr[i];
        if ([[MediaResourcesManager shareInstance] checkChooseAssetsWithModel:model selectArr:self.selectArr] > -1) {
            model.selected = YES;
        }
        else {
            model.selected = NO;
        }
        // 1. 拍摄回调  2. 存在 assets  3. 本地找到  --> 默认选中并添加并更新计数
        if (isShoot && self.shootAssets && [self.shootAssets.localIdentifier isEqualToString:model.asset.localIdentifier]) {
            model.selected = YES;
            [self.selectArr addObject:model];
            [self updateTheAddCountBtnCount];
        }
    }
}


#pragma mark - UI
- (void)setupSubviews
{
    // 导航栏
    UIView *naviView = [UIView newAutoLayoutView];
    [self.view addSubview:naviView];
    naviView.backgroundColor = COLOR_WITH_WHITE;
    [naviView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [naviView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [naviView autoSetDimensionsToSize:CGSizeMake(SCR_WIDTH, kHeaderHeight)];
    // 返回
    UIButton *backBtn = [self creatButtonWithTitle:@"取消" addView:naviView];
    [backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [backBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.f];
    [backBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStatusBarHeight];
    // 确定
    _addCountBtn = [self creatButtonWithTitle:@"确定" addView:naviView];
    [_addCountBtn addTarget:self action:@selector(comfirmSelectImg:) forControlEvents:UIControlEventTouchUpInside];
    [_addCountBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.f];
    [self.addCountBtn setTitleColor:RED forState:UIControlStateNormal];
    
    // 标题
    _titleBtn = [self creatButtonWithTitle:@"相机胶卷" addView:naviView];
    [_titleBtn addTarget:self action:@selector(switchTheAlbum) forControlEvents:UIControlEventTouchUpInside];
    [_titleBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_titleBtn autoSetDimension:ALDimensionHeight toSize:40.f];
    // 箭头
    _arrowBtn = [UIButton newAutoLayoutView];
    [naviView addSubview:_arrowBtn];
    [_arrowBtn setImage:IMAGE(@"mm_album_up") forState:UIControlStateNormal];
    [_arrowBtn addTarget:self action:@selector(switchTheAlbum) forControlEvents:UIControlEventTouchUpInside];
    [_arrowBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_titleBtn];
    CGAffineTransform trans = _arrowBtn.transform;
    _arrowBtn.transform = CGAffineTransformRotate(trans, M_PI);
    
    [@[backBtn, _arrowBtn] autoSetViewsDimensionsToSize:CGSizeMake(44, 44)];
    [@[backBtn, _addCountBtn, _titleBtn, _arrowBtn] autoAlignViewsToAxis:ALAxisHorizontal];
    [_addCountBtn autoSetDimensionsToSize:CGSizeMake(60, 44)];
    // 线
    UIView *lineView = [UIView newAutoLayoutView];
    [naviView addSubview:lineView];
    lineView.backgroundColor = kDefaultBackgroundColor;
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [lineView autoSetDimensionsToSize:CGSizeMake(SCR_WIDTH, OnePixScale)];
    
    // 图片列表
    // 1. 初始化布局类
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = OnePixScale * 2;
    flowLayout.minimumInteritemSpacing = OnePixScale * 2;
    flowLayout.itemSize = CGSizeMake((SCR_WIDTH - OnePixScale * 6) / 4.f, (SCR_WIDTH - OnePixScale * 6) / 4.f);
    
    // 2. 初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCellID"];
    [self.collectionView registerClass:[MDChoosePhotoCell class] forCellWithReuseIdentifier:MDChoosePhotoCellID];
    self.collectionView.backgroundColor = COLOR_WITH_WHITE;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.collectionView autoSetDimensionsToSize:CGSizeMake(SCR_WIDTH, SCR_HEIGHT - kHeaderHeight)];
}

- (UIButton *)creatButtonWithTitle:(NSString *)title addView:(UIView *)addView
{
    UIButton *btn = [UIButton newAutoLayoutView];
    [addView addSubview:btn];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kDefaultTitleColor forState:UIControlStateNormal];
    btn.titleLabel.font = FONT_SYSTEM_NORMAL(16);
    
    return btn;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArr.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        UICollectionViewCell *shootCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellID" forIndexPath:indexPath];
        [shootCell addSubview:self.shootImgView];
        [self.shootImgView autoPinEdgesToSuperviewEdges];
        
        return shootCell;
    }
    else {
        MDChoosePhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:MDChoosePhotoCellID forIndexPath:indexPath];
        photoCell.maxSelectCount = self.maxSelectCount;
        if (self.photoArr.count > indexPath.item - 1) {
            // 是否可被选中交给 cell 处理
            photoCell.model = self.photoArr[indexPath.item - 1];
            photoCell.selectArr = self.selectArr;
            MDWeakPtr(weakPtr, self);
            photoCell.choosePhotoCellCallBack = ^() {
                // 更新选中数据 按钮状态
                [weakPtr updateTheAddCountBtnCount];
            };
        }
        
        return photoCell;
    }
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.item != 0) {
        // 埋点数据
        UserAnalyticsModel *analyzeModel = [[UserAnalyticsModel alloc] init];
        [analyzeModel uploadEditVideoAndPhotoInfoWithPhase:@"3" subPhase:@"3" functionType:3];
        // 预览
//        XHCPhotoPreviewViewController *photoPreviewVC = [XHCPhotoPreviewViewController new];
//        photoPreviewVC.selectArr = self.selectArr;
//        photoPreviewVC.photoArr = self.photoArr;
//        photoPreviewVC.index = [NSIndexPath indexPathForRow:indexPath.item - 1 inSection:indexPath.section];
//        photoPreviewVC.publishArr = self.publishArr;
//        photoPreviewVC.deleteArr = self.deleteArr;
//        [self.navigationController pushViewController:photoPreviewVC animated:YES];
    }
    else {
        // 权限
        if ([Util checkCameraAuthorityStatus] == DeviceAuthDenied) {
            [Util showMessage:@"需要您的授权才能访问本设备的拍摄功能！" inView:self.view];
            return;
        }
        // 埋点
        UserAnalyticsModel *analyzeModel = [[UserAnalyticsModel alloc] init];
        [analyzeModel uploadEditVideoAndPhotoInfoWithPhase:@"3" subPhase:@"2" functionType:3];
        // 照片上限
        MDWeakPtr(weakPtr, self);
        if (self.selectArr.count == _maxSelectCount) {
            NSString *countStr = [NSString stringWithFormat:@"最多选择%zd张图片哦~",_maxSelectCount];
            [Util showMessage:countStr inView:self.view];
            return;
        }
        // 拍摄
        MDShootPhotoCtrl *vc = [[MDShootPhotoCtrl alloc] init];
        vc.shootPhotoBlock = ^(id assets) {
            if ([assets isKindOfClass:[PHAsset class]]) {
                weakPtr.shootAssets = (PHAsset *)assets;
            }
            [weakPtr loadAlbumListWithShootBlock:YES];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - 事件
- (void)switchTheAlbum
{
    // 旋转
    CGAffineTransform trans = _arrowBtn.transform;
    trans = CGAffineTransformRotate(trans, M_PI);
    [UIView animateWithDuration:0.15 animations:^{
        self.arrowBtn.transform = trans;
    }];
    // 切换相册
    MDPhotoAlbumListView *albumListView = [[MDPhotoAlbumListView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT)];
    [self.view addSubview:albumListView];
    MDWeakPtr(weakPtr, self);
    // albumListArr : 相册列表  albumSelectIdx : 记录选中位置  selectArr : 标记选中图
    [albumListView showPhotoAlbumListViewWithAlbumList:self.albumListArr index:self.albumSelectIdx completion:^(NSInteger index) {
        
        if (index != weakPtr.albumSelectIdx) {
            // 切换文件 进行 reload
            if (weakPtr.albumListArr.count > index) {
                weakPtr.albumSelectIdx = index;
                [self loadPhotoListWithShootBlock:NO];
            }
        }
        // 没有切换文件夹 只旋转
        CGAffineTransform trans = weakPtr.arrowBtn.transform;
        trans = CGAffineTransformRotate(trans, M_PI);
        [UIView animateWithDuration:0.15 animations:^{
            weakPtr.arrowBtn.transform = trans;
        }];
    }];
}

- (void)comfirmSelectImg:(UIButton *)sender
{
    if (arrayIsEmpty(self.selectArr)) {
        return ;
    }
//    [Util showLoadingVwInView:self.view withText:@"正在处理图片"];
//    // 埋点
//    UserAnalyticsModel *analyzeModel = [[UserAnalyticsModel alloc] init];
//    [analyzeModel uploadEditVideoAndPhotoInfoWithPhase:@"3" subPhase:@"4" functionType:3];
//
//    // 处理图片
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        NSMutableArray *mArr = [NSMutableArray array];
//        // 起名算法专用变量
//        NSInteger selectedCount = _publishArr.count + _deleteArr.count;
//
//        for (int i = 0; i < self.selectArr.count; i ++) {
//
//            ShareBuyPublishPhotoModel *photoModel = [ShareBuyPublishPhotoModel new];
//            photoModel.propertyArr = [NSMutableArray array];
//            photoModel.filterIndex = 0;
//            photoModel.stickerIndex = -1;
//            MediaAssetModel *assetModel = self.selectArr[i];
//
//            if (!arrayIsEmpty(self.publishArr)) {
//                // 新添加进来的图片 取名不能重复 最好把以前图片覆盖了
//                NSString *imagePathStr = [_deleteArr firstObject];
//                NSString *publishImageStr = nil;
//                if (stringIsEmpty(imagePathStr)) {
//                    // 没有删除的图片名可用
//                    imagePathStr = [NSString stringWithFormat:@"newShareBuyImage_%zd", selectedCount];
//                    publishImageStr = [NSString stringWithFormat:@"newShareBuyImage_pub_%zd",selectedCount];
//
//                    selectedCount ++;
//                    photoModel.imagePath = imagePathStr;
//                    photoModel.publishImage = publishImageStr;
//                }
//                else {
//                    // 用完在数组中移除
//                    photoModel.imagePath = imagePathStr;
//                    [_deleteArr removeObject:imagePathStr];
//
//                    NSArray *array = [imagePathStr componentsSeparatedByString:@"_"];
//                    photoModel.publishImage = [NSString stringWithFormat:@"newShareBuyImage_pub_%zd",[array lastObject]];
//                }
//            }
//            else {
//                photoModel.imagePath = [NSString stringWithFormat:@"newShareBuyImage_%d",i];;
//                photoModel.publishImage = [NSString stringWithFormat:@"newShareBuyImage_pub_%d",i];
//            }
//
//            photoModel.imageAsset = assetModel;
//            [LSFileManage saveDataToFolder:kNewShareBuyImageFile fileName:photoModel.imagePath data:UIImageJPEGRepresentation(photoModel.clipImage, 1.0)];
//            [LSFileManage saveDataToFolder:kNewShareBuyImageFile fileName:photoModel.publishImage data:UIImageJPEGRepresentation(photoModel.clipImage, 1.0)];
//
//            [mArr addObject:photoModel];
//        }

        // 处理完成
        dispatch_async(dispatch_get_main_queue(), ^{
            MediaAssetModel *model = self.selectArr.firstObject;
            if (self.selcectImgBlock) {
                self.selcectImgBlock(model.originImage);
                [self.navigationController popViewControllerAnimated:YES];
            }
        });

//        [Util hideLoadingVw];
//    });
}

- (void)clickBackBtn
{
    if (arrayIsEmpty(self.publishArr)) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        // 添加图片进来(至少有一张图)
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)updateTheAddCountBtnCount
{
//    if (arrayIsEmpty(self.selectArr)) {
//        [self.addCountBtn setTitle:@"继续" forState:UIControlStateNormal];
//        [self.addCountBtn setTitleColor:kDefaultBackgroundColor forState:UIControlStateNormal];
//    }
//    else {
        //NSString *addStr = [NSString stringWithFormat:@"确定",self.selectArr.count];
        //[self.addCountBtn setTitle:addStr forState:UIControlStateNormal];
        //[self.addCountBtn setTitleColor:RED forState:UIControlStateNormal];
//    }
}

#pragma mark - getter & setter
- (NSMutableArray *)albumListArr
{
    if (!_albumListArr) {
        _albumListArr = [NSMutableArray array];
    }
    
    return _albumListArr;
}

- (NSMutableArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    
    return _photoArr;
}

- (NSMutableArray *)selectArr
{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    
    return _selectArr;
}

- (UIImageView *)shootImgView
{
    if (!_shootImgView) {
        _shootImgView = [UIImageView newAutoLayoutView];
        _shootImgView.image = [UIImage imageNamed:@"mm_photo_shoot"];
        _shootImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _shootImgView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
