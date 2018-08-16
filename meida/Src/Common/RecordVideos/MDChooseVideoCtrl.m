//
//  MDChooseVideoCtrl.m
//  meida
//
//  Created by ToTo on 2018/8/8.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDChooseVideoCtrl.h"
#import "MDRecordVideoCtrl.h"

#import "MediaResourcesManager.h"
#import "MediaAssetModel.h"
#import "MDCacheFileManager.h"
#import "MDVideoPreviewView.h"

static NSString *MDVideoShootCellID   = @"MDVideoShootCell";
static NSString *MDVideoGallaryCellID = @"MDVideoGallaryCell";

typedef void(^ResultPath)(NSString *filePath, NSString *fileName);

@interface MDChooseVideoCtrl ()<UICollectionViewDataSource, UICollectionViewDelegate, VideoGallaryCellDelegate, VideoPreviewViewDelegate>

@property (nonatomic, assign) VideoGallaryType type;
@property (nonatomic, assign) NSInteger maxLimitCount;

@property (nonatomic, strong) NSMutableArray *videoList;            /**< 本地视频列表 */
@property (nonatomic, strong) NSMutableArray *selectedVideoList;    /**< 已选择视频 */

@end

@implementation MDChooseVideoCtrl


- (instancetype) initWithVideoChosenType:(VideoGallaryType)type maxLimitCount:(NSInteger)count
{
    self = [super init];
    if (self)
    {
        self.type = type;
        self.maxLimitCount = count;
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateAlbumVideoList" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutView];
    [self loadLocalVideoList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAlbumList) name:@"UpdateAlbumVideoList" object:nil];
}


#pragma mark - UI
#define kCollectCellPad 1
- (void) layoutView
{
    [self setTitle:@"视频选择"];
    [self setNavigationType:NavCustom];
    [self setLeftBtnWith:@"取消" image:nil];
    [self setRightBtnWith:@"确定" image:nil];
    [self disableRightBtn];
    
    //视频列表区域
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kCollectCellPad;
    layout.minimumInteritemSpacing = kCollectCellPad;
    layout.sectionInset = UIEdgeInsetsMake(OnePixScale, 0, 0, 0);
    layout.itemSize = CGSizeMake((SCR_WIDTH-kCollectCellPad*3)/4.f, (SCR_WIDTH-kCollectCellPad*3)/4.f);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.allowsMultipleSelection = YES;
    self.collectionView.backgroundColor = kDefaultBackgroundColor;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MDVideoShootCellID];
    [self.collectionView registerClass:[MDVideoGallaryCell class] forCellWithReuseIdentifier:MDVideoGallaryCellID];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeaderHeight];
    [self.collectionView autoSetDimensionsToSize:CGSizeMake(SCR_WIDTH, SCR_HEIGHT-kHeaderHeight)];
}


#pragma mark - 事件
- (void)leftBtnTapped:(id)sender
{
    [super back:sender];
}

- (void)rightBtnTapped:(id)sender
{
    if (!arrayIsEmpty(self.selectedVideoList)) {
        if (self.type == VideoGallaryToAdd) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoGallaryCtrl:videoList:)]) {
                [self.delegate videoGallaryCtrl:self videoList:self.selectedVideoList];
            }
            [self back:nil];
        }
        else if(self.type == VideoGallaryToShare) {
            //XHCVideoMakerViewController *ctrl = [[XHCVideoMakerViewController alloc] initInstanceWithVideoList:self.selectedVideoList];
            //[self.navigationController pushViewController:ctrl animated:YES];
        }
    }
    else {
        [Util showAlertMsg:@"选择至少一段视频！"];
    }
}

- (void)updateAlbumList
{
    //[self.sortView removeAll];
    //    [self.sortView animationHide];
    [self.selectedVideoList removeAllObjects];
    [self.videoList removeAllObjects];
    
    [self loadLocalVideoList];
}


#pragma mark - 数据
- (void) loadLocalVideoList
{
    [Util showLoadingVwInView:MDAPPDELEGATE.window withText:@"载入相册..."];
    
    MDWeakPtr(weakPtr, self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [MediaResourcesManager fetchAssetsWithVideoAlbum:^(NSArray<MediaAssetModel *> * _Nonnull videoAssets, BOOL success) {
            // 这里包含在 icloud 上的视频内容
            if (success) {
                weakPtr.videoList = [NSMutableArray arrayWithArray:videoAssets];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [Util hideLoadingVw];
                [weakPtr.collectionView reloadData];
            });
        }];
    });
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.videoList.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDVideoShootCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        UIImageView *shootImgVw = [UIImageView newAutoLayoutView];
        shootImgVw.image = [UIImage imageNamed:@"mm_photo_shoot"];
        shootImgVw.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:shootImgVw];
        [shootImgVw autoPinEdgesToSuperviewEdges];
        
        return cell;
    }
    else {
        MDVideoGallaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MDVideoGallaryCellID forIndexPath:indexPath];
        cell.delegate = self;
        
        if (self.videoList.count > indexPath.item - 1) {
            MediaAssetModel *model = self.videoList[indexPath.item - 1];
            [cell updateCellImage:model videoIdx:indexPath.item - 1];
            NSInteger idx = [[MediaResourcesManager shareInstance] checkChooseAssetsWithModel:model selectArr:self.selectedVideoList];
            [cell setSelectedStatus:idx!=-1];
        }
        
        return cell;
    }
    
    return [UICollectionViewCell newAutoLayoutView];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item == 0) {
        MDRecordVideoCtrl *vc = [[MDRecordVideoCtrl alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        MediaAssetModel *model = self.videoList[indexPath.item - 1];
        NSInteger idx = [[MediaResourcesManager shareInstance] checkChooseAssetsWithModel:model selectArr:self.selectedVideoList];
        
        MDWeakPtr(weakPtr, self);
        [MediaResourcesManager fetchVideoAssetsUrl:model completion:^(MediaAssetModel * _Nonnull assetModel, BOOL isIniCloud) {
            if (isIniCloud) {
                [Util showOptionWarning:@"此视频存于 iCloud 请到相册内下载到本地后使用~"];
            }
            else {
                [MDVideoPreviewView videoPreviewForAsset:model videoIdx:indexPath.item - 1 selected:idx > -1 delegate:weakPtr];
            }
        }];
    }
}


#pragma mark - XHCVideoGallaryCellDelegate
- (BOOL) videoCell:(MDVideoGallaryCell *)cell videoIdx:(NSInteger)videoIdx selected:(BOOL)selected
{
    MediaAssetModel *mediaModel = self.videoList[videoIdx];
    if (stringIsEmpty(mediaModel.assetUrl.absoluteString)) {
        [Util showMessage:@"无法获取当前资源" inView:MDAPPDELEGATE.window];
        return NO;
    }
    
    if (selected) {
        
        NSInteger limitCount = MIN(_maxLimitCount, MaxEditableVideoCount);
        if (self.selectedVideoList.count == limitCount) {
            [Util showOptionWarning:[NSString stringWithFormat:@"视频最多只可以选取%ld段噢!",limitCount]];
            return NO;
        }
        
        if (mediaModel.asset.duration < 3.0) {
            [Util showOptionWarning:[NSString stringWithFormat:@"视频时长不能小于%d秒!",kMinShootDuration]];
            return NO;
        }
        
        [self.selectedVideoList addObject:mediaModel];
        
        [self enableRightBtn];
    }
    else {
        NSInteger idx = [[MediaResourcesManager shareInstance] checkChooseAssetsWithModel:mediaModel selectArr:self.selectedVideoList];
        
        if (idx != -1) {
            [self.selectedVideoList removeObject:mediaModel];
            //[_sortView removeVideoAtIndex:idx];
            
            if (self.selectedVideoList.count == 0) {
                //[_sortView animationHide];
                [self disableRightBtn];
            }
        }
    }
    
    return YES;
}
- (void) openConverEditorCtrl:(MediaAssetModel *)model
{
    [Util showLoadingVwInView:self.view withText:@"正在读取需要上传的视频数据"];
    /*
    [self getVideoPathFromPHAsset:model.asset Complete:^(NSString *filePath, NSString *fileName) {
        
        if (!stringIsEmpty(filePath)) {
         
            NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            if (fileInfoDic) {
             
                NSNumber *fileSize = [fileInfoDic objectForKey:NSFileSize];
                if ([fileSize longLongValue] < [[LOGIN_USER.aliAccess objectForKey:@"limit"] longLongValue]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        XHCCoverImageEditorViewController *ctrl = [[XHCCoverImageEditorViewController alloc] initWithVideoFilePath:filePath];
//                        ctrl.isDirectUpload = YES;
//                        [XHCAPPDELEGATE.navigation pushViewController:ctrl animated:YES];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Util showOptionWarning:[NSString stringWithFormat:@"需要上传的视频不能超过 %lld M", [[LOGIN_USER.aliAccess objectForKey:@"limit"] longLongValue]/(1024*1024)]];
                    });
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Util showOptionWarning:@"请确认视频长度是否超过了10分钟！"];
                });
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Util showOptionWarning:@"视频读取错误，请确认该视频是否在iCloud上！"];
            });
        }
        
        [Util hideLoadingVw];
    }];
         */
}

#pragma mark - XHCVideoPreviewViewDelegate
- (void) previewView:(MDVideoPreviewView *)view confirmSelectedIdx:(NSInteger)idx
{
    MediaAssetModel *assetModel = self.videoList[idx];

    NSInteger i = [[MediaResourcesManager shareInstance] checkChooseAssetsWithModel:assetModel selectArr:self.selectedVideoList];
    [self updateS:i > -1 videoIdx:idx];

    [self enableRightBtn];

    [self.collectionView reloadData];
}

- (void)updateS:(BOOL)isSelected videoIdx:(NSInteger)videoIdx
{
    MediaAssetModel *assetModel = self.videoList[videoIdx];
    if (!isSelected)
    {
        NSInteger limitCount = MIN(_maxLimitCount, MaxEditableVideoCount);
        if (self.selectedVideoList.count == limitCount)
        {
            [Util showOptionWarning:[NSString stringWithFormat:@"视频最多只可以选取%ld段噢!",limitCount]];
            return;
        }
        
        if (assetModel.asset.duration < 3)
        {
            [Util showOptionWarning:[NSString stringWithFormat:@"视频时长不能小于%d秒!",kMinShootDuration]];
            return;
        }
        
        [self.selectedVideoList addObject:assetModel];
        
        [self enableRightBtn];
    }
    else
    {
        NSInteger idx = [[MediaResourcesManager shareInstance] checkChooseAssetsWithModel:assetModel selectArr:self.selectedVideoList];
        
        if (idx != -1)
        {
            [self.selectedVideoList removeObject:assetModel];
            if (self.selectedVideoList.count == 0)
            {
                [self disableRightBtn];
            }
        }
    }
    
}


#pragma mark - getter
- (NSMutableArray *)videoList
{
    if (!_videoList) {
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}

- (NSMutableArray *)selectedVideoList
{
    if (!_selectedVideoList)
    {
        _selectedVideoList = [NSMutableArray array];
    }
    return _selectedVideoList;
}


- (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result {
    // 当前方法只能在 9.0 及以上版本使用 临上线暂不修改
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        
        if (assetRes.type == PHAssetResourceTypePairedVideo
            || assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = resource.originalFilename ?: @"tempAssetVideo.mov";
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSArray *info = [fileName componentsSeparatedByString:@"."];
        if (info.count >1) {
            
            NSString *typeStr = [info lastObject];
            NSString *cachePath = [MDCacheFileManager cachePathWithType:CacheClipVideoTemp];
            NSString *outputPath = [NSString stringWithFormat:@"%@/direct.%@",cachePath,typeStr];
            [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
            [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                        toFile:[NSURL fileURLWithPath:outputPath]
                                                                       options:nil
                                                             completionHandler:^(NSError * _Nullable error) {
                                                                 if (error) {
                                                                     result(nil, nil);
                                                                 }
                                                                 else {
                                                                     result(outputPath, fileName);
                                                                 }
                                                             }];
        }
        else {
            result(nil, nil);
        }
    }
    else {
        result(nil, nil);
    }
}


@end




#pragma mark -  拍摄 选择视频或者选择录制 controller cell #############################################----------
@interface MDVideoGallaryCell()

@property (nonatomic, strong) UIImageView       *photoImageVw;
@property (nonatomic, strong) MediaAssetModel   *assetModel;
@property (nonatomic, strong) UIButton          *selectedStatusBtn;
@property (nonatomic, assign) NSInteger         videoIdx;

@end

@implementation MDVideoGallaryCell

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void) updateCellImage:(MediaAssetModel *)assetModel videoIdx:(NSInteger)videoIdx
{
    _assetModel = assetModel;
    if (self.photoImageVw)
    {
        self.photoImageVw.image = assetModel.thumbnailImage;
    }
    _videoIdx = videoIdx;
    
    self.selectedStatusBtn.hidden = NO;
}

- (void) setSelectedStatus:(BOOL)isSelected
{
    self.selectedStatusBtn.selected = isSelected;
    [self.contentView bringSubviewToFront:self.selectedStatusBtn];
}

#pragma mark -
- (UIImageView *)photoImageVw
{
    if (!_photoImageVw)
    {
        _photoImageVw = [UIImageView newAutoLayoutView];
        _photoImageVw.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageVw.clipsToBounds = YES;
        [self.contentView addSubview:_photoImageVw];
        [_photoImageVw autoPinEdgesToSuperviewEdges];
    }
    return _photoImageVw;
}

- (UIButton *)selectedStatusBtn
{
    if (!_selectedStatusBtn)
    {
        _selectedStatusBtn = [UIButton newAutoLayoutView];
        [_selectedStatusBtn setImage:[UIImage imageNamed:@"video_unselected"] forState:UIControlStateNormal];
        [_selectedStatusBtn setImage:[UIImage imageNamed:@"video_selected"] forState:UIControlStateSelected];
        [_selectedStatusBtn addTarget:self action:@selector(selectedBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        _selectedStatusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_selectedStatusBtn];
        [_selectedStatusBtn autoSetDimensionsToSize:CGSizeMake(44, 44)];
        [_selectedStatusBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [_selectedStatusBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    }
    return _selectedStatusBtn;
}

- (void) selectedBtnTapped:(UIButton *)sender
{
    MDWeakPtr(weakPtr, self);
    [MediaResourcesManager fetchVideoAssetsUrl:_assetModel completion:^(MediaAssetModel * _Nonnull assetModel, BOOL isIniCloud) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isIniCloud) {
                [Util showOptionWarning:@"此视频存于 iCloud 请到相册内下载到本地后使用~"];
            }
            else {
                if (weakPtr.delegate && [weakPtr.delegate respondsToSelector:@selector(videoCell:videoIdx:selected:)]) {
                    if([weakPtr.delegate videoCell:weakPtr videoIdx:weakPtr.videoIdx selected:!sender.selected]) {
                        sender.selected = !sender.selected;
                    }
                }
            }
            
        });
    }];
}

@end
