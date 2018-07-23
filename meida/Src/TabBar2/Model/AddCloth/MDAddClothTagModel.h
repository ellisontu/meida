//
//  MDAddClothTagModel.h
//  meida
//
//  Created by ToTo on 2018/7/23.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "BaseModel.h"

@class MDAddClothTagModel;
@interface MDAddClothGroupTagModel : BaseModel

@property (nonatomic, strong) NSMutableArray<MDAddClothTagModel *>   *tagsArr;

@end

@interface MDAddClothTagModel : BaseModel

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, assign) BOOL      isSelected;

@end
