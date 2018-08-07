//
//  MDPhotoAlbumListView.m
//  meida
//
//  Created by ToTo on 2018/8/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDPhotoAlbumListView.h"
#import "MediaResourcesManager.h"
#import "MediaAlbumsModel.h"
#import "MediaAssetModel.h"

#define kPhotoAlbumListCellHeight 44

@interface MDPhotoAlbumListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *albumListArr;
@property (nonatomic, strong) NSMutableArray    *photoArr;
@property (nonatomic, assign) NSInteger         selectIndex;
@property (nonatomic, strong) PhotoAlbumListBlock photoAlbumListBlock;

@end

@implementation MDPhotoAlbumListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    
    return self;
}


#pragma mark - UI
- (void)initView
{
    UIView *bgView = [UIView newAutoLayoutView];
    [self addSubview:bgView];
    bgView.backgroundColor = COLOR_WITH_CLEAR;
    [bgView autoPinEdgesToSuperviewEdges];
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePhotoAlbumListView)]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCR_HEIGHT - 50, SCR_WIDTH, 0) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.alwaysBounceVertical = NO;
    _tableView.rowHeight = kPhotoAlbumListCellHeight;
    _tableView.backgroundColor = COLOR_WITH_CLEAR;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (self.viewAlpha) {
        cell.backgroundColor = [COLOR_WITH_WHITE colorWithAlphaComponent:self.viewAlpha];
    }
    MediaAlbumsModel *model = self.albumListArr[indexPath.row];
    NSString *titleStr = [NSString stringWithFormat:@"%@(%ld)",model.name,model.assetCount];
    if (titleStr.length > 10) {
        titleStr = [[titleStr substringToIndex:10] stringByAppendingString:@"..."];
    }
    cell.textLabel.text = titleStr;
    cell.textLabel.font = FONT_SYSTEM_NORMAL(15);
    cell.textLabel.textColor = kDefaultTitleColor;
    
    UIImageView *markImg = [UIImageView newAutoLayoutView];
    if (indexPath.row == self.selectIndex) {
        markImg.image = IMAGE(@"xuanzhong");
    }
    else {
        markImg.image = IMAGE(@"weixuanzhong");
    }
    [cell.contentView addSubview:markImg];
    [markImg autoSetDimensionsToSize:CGSizeMake(40, 40)];
    [markImg autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [markImg autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:15];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.albumListArr.count > indexPath.row) {
        self.selectIndex = indexPath.row;
        [self hidePhotoAlbumListView];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 下面这几行代码是用来设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

- (void)showPhotoAlbumListViewWithAlbumList:(NSMutableArray *)albumListArr index:(NSInteger)selectIndex completion:(PhotoAlbumListBlock)completion

{
    self.photoAlbumListBlock = completion;
    self.selectIndex = selectIndex;
    self.albumListArr = albumListArr;
    [self.tableView reloadData];
    
    self.tableView.y = kHeaderHeight;
    [UIView animateWithDuration:0.15 animations:^{
        NSInteger num = self.albumListArr.count > 5 ? 5 : self.albumListArr.count;
        self.tableView.height = kPhotoAlbumListCellHeight * num;
    }];
}

- (void)hidePhotoAlbumListView
{
    [UIView animateWithDuration:0.15 animations:^{
        self.tableView.height = 0;
    } completion:^(BOOL finished) {
        if (self.photoAlbumListBlock) {
            self.photoAlbumListBlock(self.selectIndex);
        }
        [self removeFromSuperview];
    }];
}


#pragma mark - getter
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
@end
