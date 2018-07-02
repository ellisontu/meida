//
//  LSLocation.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const LocationCacheDic      = @"location_cache_dic";       /**< 地址缓存字典包含国家，省，市，区，街道 */
static NSString *const LocationCacheCountry  = @"location_cache_country";   /**< 缓存地址 国家 */
static NSString *const LocationCacheProvince = @"location_cache_province";  /**< 缓存地址 省 */
static NSString *const LocationCacheCity     = @"location_cache_city";      /**< 缓存地址 市 */
static NSString *const LocationCacheArea     = @"location_cache_area";      /**< 缓存地址 区 */
static NSString *const LocationCacheStreet   = @"location_cache_street";    /**< 缓存地址 街道 */


@interface LSLocation : NSObject

@property (nonatomic, strong) NSString *country;    /**< 国家 */
@property (nonatomic, strong) NSString *province;   /**< 省 */
@property (nonatomic, strong) NSString *city;       /**< 市 */
@property (nonatomic, strong) NSString *area;       /**< 区 */
@property (nonatomic, strong) NSString *street;     /**< 街道 */
@property (nonatomic, assign) double   longitude;   /**< 经度 */
@property (nonatomic, assign) double   latitude;    /**< 纬度 */
@property (nonatomic, strong) NSString *address;    /**< 地址信息 */


- (void)setAddress;

/**
 *  开始更新位置
 */
- (void)startUpdatingLocation;

/**
 *  结束更新位置
 */
- (void)stopUpdatingLocation;


@end

