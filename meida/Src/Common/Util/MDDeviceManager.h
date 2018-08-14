//
//  MDDeviceManager.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSLocation.h"

@class MDNavigationController;

@interface MDDeviceManager : NSObject

//@property (nonatomic, strong) UIWindow *window;
//@property (nonatomic, strong) MDNavigationController *navigation;
@property (nonatomic, strong) LSLocation *appLocation;
@property (nonatomic, strong) NSString *deviceToken;    /**< 需要在网络请求头里放 */
@property (nonatomic, strong) NSString *deviceIden;     /**< 获取设备标识符 */

+ (MDDeviceManager *)sharedInstance;

@end
