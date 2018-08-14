//
//  MDLaunchAdModel.h
//  meida
//
//  Created by ToTo on 2018/7/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "BaseModel.h"

@interface MDLaunchAdModel : BaseModel


@property (nonatomic ,strong) NSString *imgUrl;
@property (nonatomic ,strong) NSString *videoUrl;
@property (nonatomic ,strong) NSString *linkUrl;
@property (nonatomic ,strong) NSString *extLinkUrl;
@property (nonatomic ,assign) NSInteger showTime;
@property (nonatomic, assign) NSTimeInterval validEndData;
@property (nonatomic, assign) NSTimeInterval validStartData;


@end

