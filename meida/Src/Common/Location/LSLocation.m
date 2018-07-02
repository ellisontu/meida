//
//  LSLocation.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "LSLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface LSLocation ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation        *location;
@property (nonatomic, assign) BOOL              isUpdatingLocation; /**< 是否开启定位服务 */

@end

@implementation LSLocation

- (void)dealloc
{
    XLog(@"dealloc, stop updating");
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

- (void)setAddress
{
    NSString *province = filterValue(_province);
    NSString *city = filterValue(_city);
    NSString *area = filterValue(_area);
    NSString *street = filterValue(_street);
    _address = [NSString stringWithFormat:@"%@ %@ %@ %@", province, city, area, street];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        _locationManager = [[CLLocationManager alloc] init];
//        //为设置定位的精度
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        //距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序，它的单位是米
//        //_locationManager.distanceFilter = kCLDistanceFilterNone;
//        _locationManager.distanceFilter = 1000;
//        _locationManager.delegate = self;
//        
//        if (IS_IOS_8_ABOVE) {
//            //使用期间使用定位服务
//            [_locationManager requestWhenInUseAuthorization];
//            //始终使用定位服务
//            //[_locationManager requestAlwaysAuthorization];
//        }
    }
    return self;
}

- (void)startUpdatingLocation
{
    if (!_isUpdatingLocation) {
        [self.locationManager startUpdatingLocation];
        _isUpdatingLocation = YES;
    }
}

- (void)stopUpdatingLocation
{
    if (_isUpdatingLocation) {
        [self.locationManager stopUpdatingLocation];
        _isUpdatingLocation = NO;
    }
}

//反向地理位置编码
- (void)reverseGeocode:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!arrayIsEmpty(placemarks)) {
            CLPlacemark *placemark = [placemarks firstObject];
            NSDictionary *addressDic = placemark.addressDictionary;
            //eg. 太阳宫大厦   |   中国云南省丽江市永胜县光华傈僳族彝族乡
            //NSString *name = placemark.name;
            //eg. 中国            中国
            NSString *country = placemark.country;
            //eg. 北京市           云南省
            NSString *locality = placemark.locality;
            //eg. 朝阳区           nil
            NSString *subLocality = placemark.subLocality;
            //eg. 北京市           丽江市
            NSString *administrativeArea = placemark.administrativeArea;
            //eg. nil             永胜县
            NSString *subAdministrativeArea = placemark.subAdministrativeArea;
            //eg. 太阳宫中路12号
            NSString *thoroughfare = placemark.thoroughfare;
            //eg. 中国北京市朝阳区太阳宫镇太阳宫中路12号
            NSString *formattedAddressLines = [[addressDic objectForKey:@"FormattedAddressLines"] firstObject];
            XLog(@"地址信息 = %@", addressDic);
            _country = stringIsEmpty(country) ? @"未知" : country;
            if (stringIsEmpty(locality)) {
                if (stringIsEmpty(administrativeArea)) {
                    _province = @"未知";
                    _city = @"未知";
                    _area = @"未知";
                }
                else {
                    _province = administrativeArea;
                    _city = stringIsEmpty(subAdministrativeArea) ? @"未知" : subAdministrativeArea;
                    _area = @"未知";
                }
            }
            else {
                _province = locality;
                if (stringIsEmpty(subLocality)) {
                    _city = stringIsEmpty(administrativeArea) ? @"未知" : administrativeArea;
                    _area = stringIsEmpty(subAdministrativeArea) ? @"未知" : subAdministrativeArea;
                }
                else {
                    if ([locality isEqualToString:administrativeArea]) {
                        _city = administrativeArea;
                        _area = stringIsEmpty(subLocality) ? @"未知" : subLocality;
                    }
                    else {
                        if (stringIsEmpty(subLocality)) {
                            _city = stringIsEmpty(administrativeArea) ? @"未知" : administrativeArea;
                            _area = stringIsEmpty(subAdministrativeArea) ? @"未知" : subAdministrativeArea;
                        }
                        else {
                            _city = subLocality;
                            _area = stringIsEmpty(administrativeArea) ? @"未知" : administrativeArea;
                        }
                    }
                }
            }
            _street = stringIsEmpty(thoroughfare) ? @"未知" : thoroughfare;
            _address = stringIsEmpty(formattedAddressLines) ? @"未知" : formattedAddressLines;
            //缓存地理位置信息
            [self saveLocation];
        }
        else if (!error && arrayIsEmpty(placemarks)) {
            XLog(@"反向地理位置编码无结果");
        }
        else if (error) {
            XLog(@"反向地理位置编码失败：%@", error.localizedDescription);
        }
    }];
    
}

#pragma mark - CLLocationManagerDelegate -
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    self.location = [locations lastObject];
    self.longitude = _location.coordinate.longitude;
    self.latitude = _location.coordinate.latitude;
    [self reverseGeocode:_location];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    XLog(@"定位失败：%@", error.localizedDescription);
    XLog(@"***********使用缓存地理位置信息***********");
    //使用缓存地理位置信息
    NSDictionary *locationDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:LocationCacheDic];
    if (!dictionaryIsEmpty(locationDic)) {
        self.country  = [locationDic objectForKey:LocationCacheCountry];
        self.province = [locationDic objectForKey:LocationCacheProvince];
        self.city     = [locationDic objectForKey:LocationCacheCity];
        self.area     = [locationDic objectForKey:LocationCacheArea];
        self.street   = [locationDic objectForKey:LocationCacheStreet];
    }
    XLog(@"locationDic = %@", locationDic);
}

/**
 *  缓存最新地理位置信息
 */
- (void)saveLocation
{
    NSMutableDictionary *locationDic = [NSMutableDictionary dictionary];
    if (![_country isEqualToString:@"未知"]) {
        [locationDic setObject:_country forKey:LocationCacheCountry];
    }
    if (![_province isEqualToString:@"未知"]) {
        [locationDic setObject:_province forKey:LocationCacheProvince];
    }
    if (![_city isEqualToString:@"未知"]) {
        [locationDic setObject:_city forKey:LocationCacheCity];
    }
    if (![_area isEqualToString:@"未知"]) {
        [locationDic setObject:_area forKey:LocationCacheArea];
    }
    if (![_street isEqualToString:@"未知"]) {
        [locationDic setObject:_street forKey:LocationCacheStreet];
    }
    [[NSUserDefaults standardUserDefaults] setObject:locationDic forKey:LocationCacheDic];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  获取缓存地理位置信息（当获取不到地理位置时用到）
 *
 *  @param key 仅限：LocationCacheCountry、LocationCacheProvince、LocationCacheCity、LocationCacheArea、LocationCacheStreet
 *
 *  @return 对应key的值
 */
- (NSString *)getCacheLocationInfoByKey:(NSString *)key
{
    NSString *locationStr = nil;
    NSDictionary *locationDic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:LocationCacheDic];
    if (!dictionaryIsEmpty(locationDic)) {
        locationStr = [locationDic objectForKey:key];
    }
    
    return locationStr;
}

@end





