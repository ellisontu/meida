//
//  BaseJumpModel.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  这个只做跳转使用！ 这里只处理 scheme = 

#import "BaseModel.h"
@class YMWebViewVC;

typedef NS_ENUM(NSInteger, BaseJumpModelType) {
    BaseJumpModelTypeLogin,             /**< 登录 */
    BaseJumpModelTypeUnknow
};

@interface BaseJumpModel : BaseModel

@property (nonatomic, assign) BaseJumpModelType jumpType;

- (instancetype)initWithUrlString:(NSString *)urlString;

- (void)setJumpTypeByUrlString:(NSString *)urlString;

/**
 *  按类型跳转
 */
- (void)handelJump;

@end
