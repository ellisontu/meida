//
//  MDChoosePhotosCtrl.h
//  meida
//
//  Created by ToTo on 2018/8/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//  选择图片及拍照 vc

#import "MDBaseViewController.h"

@interface MDChoosePhotosCtrl : MDBaseViewController

@property (nonatomic, strong) NSMutableArray *publishArr;   /**< 发布过来的 旧照片 */
@property (nonatomic, strong) NSMutableArray *deleteArr;    /**< 被删除的照片名 */

@end
