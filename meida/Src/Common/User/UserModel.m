//
//  UserModel.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)setUid:(NSString *)uid
{
    _uid = uid;
    //初始化一些默认配置
    _maxShootDuration = kMaxShootDuration;
    _id = _uid;
}

- (void)setId:(NSString *)id
{
    _id = id;
    
    _uid = _id;
}

- (void)setNick:(NSString *)nick
{
    _nick = nick;
    if (stringIsEmpty(nick)) {
        _nick = @"";
    }
}

- (void)setMobile:(NSString *)mobile
{
    _mobile = mobile;
    if (stringIsEmpty(mobile)) {
        _mobile = @"";
    }
}

- (void)setIcon_url:(NSString *)icon_url
{
    [self _setupIcon:icon_url];
}

- (void)setIcon:(NSString *)icon
{
    [self _setupIcon:icon];
}

- (void)setAvatar:(NSString *)avatar
{
    [self _setupIcon:avatar];
}

// 由于icon头像有三个字段，那个字段有，就用哪个字段。需要处理一下
- (void)_setupIcon:(NSString *)icon
{
    if (stringIsEmpty(icon)) {
        _icon = @"";
        _avatar = @"";
        _icon_url = @"";
    }
    else {
        _icon = icon;
        _avatar = icon;
        _icon_url = icon;
    }
}

- (void)setRecommend:(NSNumber *)recommend
{
    _recommend = recommend;
    
    _is_follow = _recommend;
}

- (void)setFans:(NSString *)fans
{
    _fans = fans;
    
    if (!stringIsEmpty(_fans)) {
        _fans_count = @([_fans integerValue]);
    }
    else {
        _fans_count = @0;;
    }
}

- (void)setVideos:(NSString *)videos
{
    _videos = videos;
    if (stringIsEmpty(videos)) {
        _videos = @"0";
    }
}

- (void)setCollections:(NSString *)collections
{
    _collections = collections;
    if (stringIsEmpty(collections)) {
        _collections = @"0";
    }
}

- (void)setOpenId:(NSString *)openId
{
    if (openId) {
        _openId = [NSString stringWithFormat:@"%@", openId];
    }
}

+ (NSMutableArray *)decodeJsonArray:(id)json
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (!json || [json isKindOfClass:[NSNull class]])
        return array;
    for (NSDictionary *dict in json) {
        //[array addObject:[UserModel decodeJson:dict]];
        [array addObject:[[UserModel alloc] initWithDict:dict]];
    }
    return array;
}

- (BOOL)isPhoneBinded
{
    if (self.mobile
        && self.mobile.length > 1
        && [[self.mobile substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}


@end
