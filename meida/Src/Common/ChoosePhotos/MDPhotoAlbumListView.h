//
//  MDPhotoAlbumListView.h
//  meida
//
//  Created by ToTo on 2018/8/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDPhotoAlbumListView : UIView

/**
 *  透明度
 */
@property (nonatomic , assign) CGFloat viewAlpha;

/**
 *  返回选中的专辑内的图片 专辑名称 选中行
 */
typedef void (^PhotoAlbumListBlock)(NSInteger index);

/**
 *  显示 XHCPhotoAlbumListView
 */
- (void)showPhotoAlbumListViewWithAlbumList:(NSMutableArray *)albumListArr index:(NSInteger)selectIndex completion:(PhotoAlbumListBlock)completion;

@end
