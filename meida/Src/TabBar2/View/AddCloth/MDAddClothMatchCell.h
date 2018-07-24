//
//  MDAddClothMatchCell.h
//  meida
//
//  Created by ToTo on 2018/7/5.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDAddClothGroupTagModel, MDAddClothTagModel;

#pragma mark -  衣橱 -> 我的衣橱 -> 搭配 Camera 相机 cell #############################################----------
@interface MDAddClothMatchCameraCell : UITableViewCell

@end




#pragma mark -  衣橱 -> 我的衣橱 -> 搭配物件 cell         #############################################----------
@interface MDAddClothMatchObjCell : UITableViewCell

@end

@interface MDAddClothMatchObjCellItem : UICollectionViewCell

@end



#pragma mark -  衣橱 -> 我的衣橱 -> 搭配 tags 场所&天气 cell #############################################----------
@interface MDAddClothMatchTagCell : UITableViewCell

@property (nonatomic, strong) MDAddClothGroupTagModel *groupTag;

@end

@interface MDAddClothMatchTagCellItem : UICollectionViewCell

@property (nonatomic, strong) MDAddClothTagModel    *tagModel;

@end


