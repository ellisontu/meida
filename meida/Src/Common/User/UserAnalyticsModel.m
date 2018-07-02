//
//  UserAnalyticsModel.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UserAnalyticsModel.h"
#import "UserAnalyticsManager.h"
//#import "JSONKit.h"
#import "MDDeviceManager.h"

@interface UserAnalyticsModel ()

@property (nonatomic, strong) NSMutableDictionary *baseModelDic;

@end

@implementation UserAnalyticsModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initModel];
        [self initBaseModelDictionary];
    }
    return self;
}

- (void)initModel
{
    _uid = stringIsEmpty(LOGIN_USER.uid) ? @"-1" : LOGIN_USER.uid;
    _app_version = kAppVersion;
    _timestamp = [Util getCurrentTime];
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _country = stringIsEmpty([MDDeviceManager sharedInstance].appLocation.country) ? @"未知" : [MDDeviceManager sharedInstance].appLocation.country;
    _province = stringIsEmpty([MDDeviceManager sharedInstance].appLocation.province) ? @"未知" : [MDDeviceManager sharedInstance].appLocation.province;
    _city = stringIsEmpty([MDDeviceManager sharedInstance].appLocation.city) ? @"未知" : [MDDeviceManager sharedInstance].appLocation.city;
    _manufacturer = @"Apple";
    NSArray *modeNamearray = getDeveiceModelName();
    _model = arrayIsEmpty(modeNamearray) ? @"未知" : [modeNamearray firstObject];
    _dev = filterValue([MDDeviceManager sharedInstance].deviceIden);
    _os = @"ios";
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    _os_version = stringIsEmpty(systemVersion) ? @"未知" : systemVersion;
    _screen_width = [NSString stringWithFormat:@"%.2f", SCR_WIDTH];
    _screen_height = [NSString stringWithFormat:@"%.2f", SCR_HEIGHT];
    _wifi = [[MDNetWorking sharedClient] isConnectedViaWiFi] ? @"1" : @"0";
    _carrier = getDeveiceNetworkName();
    _network_type = getDeveiceNetworkType();
}

- (void)initBaseModelDictionary
{
    // 埋点的公共信息
    _baseModelDic = [NSMutableDictionary dictionary];
    [_baseModelDic setObject:_uid forKey:@"uid"];
    [_baseModelDic setObject:_app_version forKey:@"_app_version"];
    [_baseModelDic setObject:_timestamp forKey:@"_timestamp"];
    [_baseModelDic setObject:_country forKey:@"_country"];
    [_baseModelDic setObject:_province forKey:@"_province"];
    [_baseModelDic setObject:_city forKey:@"_city"];
    [_baseModelDic setObject:_manufacturer forKey:@"_manufacturer"];
    [_baseModelDic setObject:_model forKey:@"_model"];
    [_baseModelDic setObject:_dev forKey:@"_dev"];
    [_baseModelDic setObject:_os forKey:@"_os"];
    [_baseModelDic setObject:_os_version forKey:@"_os_version"];
    [_baseModelDic setObject:_screen_width forKey:@"_screen_width"];
    [_baseModelDic setObject:_screen_height forKey:@"_screen_height"];
    [_baseModelDic setObject:_wifi forKey:@"_wifi"];
    [_baseModelDic setObject:_carrier forKey:@"_carrier"];
    [_baseModelDic setObject:_network_type forKey:@"_network_type"];
}

- (NSDictionary *)getShareAnlayzeInfo
{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:_baseModelDic];
    return dic;
}

- (NSDictionary *)configLogMessageDictionary
{
    if ([_tableName isEqualToString:UserAnalyticsTableName_user_play_video]) {
        [self configUserPlayVideo];
    }
    else if ([_tableName isEqualToString:UserAnalyticsTableName_user_click]) {
        if (_isReact) {
            [self configUserClick_React:_clickDic];
        }
        else {
            [self configUserClick_Native];
        }
    }
    else if ([_tableName isEqualToString:UserAnalyticsTableName_goods_access]) {
        [self configGoodsAccess];
    }
    else if ([_tableName isEqualToString:UserAnalyticsTableName_page_duration]) {
        [self configPageDuration];
    }
    else if ([_tableName isEqualToString:UserAnalyticsTableName_link]) {
        [self configH5Link];
    }
    NSDictionary *dic = @{@"table":_tableName, @"content":_baseModelDic};
    NSString *jsonStr = @"";//[dic JSONString];
    [UserAnalyticsManager saveAnalyzeDataWithMessageJsonString:jsonStr];
    
    return dic;
}

- (void)configUserPlayVideo
{
    // 埋点：视频播放时长
    if (!stringIsEmpty(_vid)) {
        [_baseModelDic setObject:_vid forKey:@"vid"];
    }
    if (!stringIsEmpty(_playtime)) {
        [_baseModelDic setObject:_playtime forKey:@"playtime"];
    }
    if (!stringIsEmpty(_duration)) {
        [_baseModelDic setObject:_duration forKey:@"duration"];
    }
    if (!stringIsEmpty(_track_info)) {
        [_baseModelDic setObject:_track_info forKey:@"track_info"];
    }
}

- (void)configUserClick_Native
{
    // 埋点：关注点击次数
    if (!stringIsEmpty(_action)) {
        [_baseModelDic setObject:_action forKey:@"action"];
    }
}

- (void)configUserClick_React:(NSDictionary *)contentDic
{
    if (!dictionaryIsEmpty(contentDic)) {
        [_baseModelDic addEntriesFromDictionary:contentDic];
        //DLog(@"_baseModelDic = %@", _baseModelDic);
    }
}

- (void)configGoodsAccess
{
    // 埋点：商品详情页来源
    if (!stringIsEmpty(_g_id)) {
        [_baseModelDic setObject:_g_id forKey:@"g_id"];
    }
    if (!stringIsEmpty(_referer)) {
        [_baseModelDic setObject:_referer forKey:@"referer"];
    }
    if (!stringIsEmpty(_source)) {
        [_baseModelDic setObject:_source forKey:@"source"];
    }
}

- (void)configPageDuration
{
    if (_page_duration != nil) {
        [_baseModelDic setObject:_page_duration forKey:@"page_duration"];
    }
    if (!stringIsEmpty(_page_name)) {
        [_baseModelDic setObject:_page_name forKey:@"page_name"];
    }
}

- (void)configH5Link
{
    if (!stringIsEmpty(_source)) {
        [_baseModelDic setObject:_source forKey:@"source"];
    }
}

- (NSDictionary *)getUploadDataInfo
{
    // 埋点:上传数据
    if (!stringIsEmpty(_type)) {
        [_baseModelDic setObject:_type forKey:@"type"];
    }
    if (!stringIsEmpty(_time)) {
        [_baseModelDic setObject:_time forKey:@"time"];
    }
    if (!stringIsEmpty(_question)) {
        [_baseModelDic setObject:_question forKey:@"step"];
    }
    if (!stringIsEmpty(_upload_target)) {
        [_baseModelDic setObject:_upload_target forKey:@"upload_target"];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:_baseModelDic];
    return dict;
}

- (NSDictionary *)uploadEditVideoInfo
{
    // 埋点: 编辑视频
    if (!stringIsEmpty(_phase)) {
        /**
         *  编辑阶段: 目前根据 UI 区分 (5个界面)
         *
         *  1. 选择视频
         *  2. 合成视频
         *  3. 编辑内容
         *  4. 设置封面
         *  5. 发布视频
         */
        [_baseModelDic setObject:_phase forKey:@"phase"];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:_baseModelDic];
    return dict;
}

- (void)uploadEditVideoAndPhotoInfoWithPhase:(NSString *)phase subPhase:(NSString *)subPhase functionType:(NSInteger)functionType
{
    phase = stringIsEmpty(phase) ? @"未知" : phase;
    subPhase = stringIsEmpty(subPhase) ? @"0" : subPhase;
    _phase = [NSString stringWithFormat:@"%@-%@",phase,subPhase];
    
    [_baseModelDic setObject:_phase forKey:@"phase"];
    
    NSString *actionStr = @"";
    if (functionType == 1) {
        // 埋点: 编辑视频
        
        /**
         *  编辑阶段: 目前根据 UI 区分 (6个界面)
         *  1. 点击'录视频'
         *  2. 选择视频 (1. 选择视频   2. 拍摄视频)
         *  3. 合成视频 (1. 视频排序   2. 复制片段   3. 删除   4. 添加)
         *  4. 编辑内容 (1. 音乐编辑   2. 贴纸文字   3. 恢复)
         *  5. 设置封面 (1. 截取封面   2. 选择封面)
         *  6. 发布视频 (1. 添加标签   2. 保存草稿)
         */
        
        actionStr = @"editvideo";
    }
    else if (functionType == 2) {
        // 埋点: 编辑图片
        
        /**
         *  编辑阶段: 目前根据 UI 区分 (4个界面)
         *  1. 点击'拍照片'
         *  2. 选择图片 (1. 选择图片   2. 拍摄照片)
         *  3. 编辑图片 (1. 添加滤镜   2. 添加标签   3. 贴纸    0. 继续)
         *  4. 发布晒单 (1. 添加标签   2. 添加图片   3. 排序    4. 删除   5. 编辑)
         */
        
        actionStr = @"editphoto";
    }
    else if (functionType == 3) {
    
        /**
         *  编辑阶段: 目前根据 UI 区分 (5个界面)
         *  1. 点击'新发布'
         *  2. 预览大图 (1. 选择图片   2. 进入编辑)
         *  3. 选择图片 (1. 选择图片   2. 拍摄照片   3. 预览    4. 完成)
         *  4. 编辑图片 (1. 添加滤镜   2. 添加标签   3. 贴纸)
         *  5. 发布晒单 (1. 添加标签   2. 添加图片   3. 排序    4. 删除)
         */

        actionStr = @"editphoto_new";
    }
    
    NSString *jsonStr = @"";//[_baseModelDic JSONString];
    NSDictionary *para = @{@"content" : stringIsEmpty(jsonStr) ? @"" : jsonStr};
}

- (NSDictionary *)uploadPublishShareBuyMemoryWarning
{
    if (!stringIsEmpty(_m_w_sd_index)) {
        /**
         *  编辑阶段: 目前根据 UI 区分 (3个界面)
         *
         *  1. 选择图片
         *  2. 编辑图片
         *  3. 发布晒单
         */
        [_baseModelDic setObject:_m_w_sd_index forKey:@"sd_memoryWarnings"];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:_baseModelDic];
    return dict;
}

@end




