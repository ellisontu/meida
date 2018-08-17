//
//  UserManager.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "UserManager.h"
#import <NSDate+DateTools.h>
//#import "SearchManager.h"
#import "MDCacheFileManager.h"
//#import "ApnsService.h"
//#import "MessageManager.h"
//#import "QYSDK.h"

#define kMaxWatermarkCount      1

static NSString *UserKey                = @"userInfo";
static NSString *OldUserKey             = @"user";
static NSString *SubcriteTime           = @"subcrite_time";
static NSString *LoginTime              = @"login_time";
static NSString *LoginSuccessTime       = @"login_success_time";

static NSString *IsAutoPlay             = @"auto_play";
static NSString *WatermarkCount         = @"publish_tip_watermark_cnt";
static NSString *isAllowUseViaWWAN     = @"allow_Use_ViaWWAN";

static NSString *SaveBrowseRecDateKey   = @"SaveBrowseRecDateKey";
static NSString *VideoBrowseRecordKey   = @"VideoBrowseRecord";
static NSString *PhotoBrowseRecordKey   = @"PhotoBrowseRecord";

static NSString *appGeTuiNotify         = @"appGeTuiNotifyIsOn";    /**< key 个推管理 */

@interface UserManager ()

@property (nonatomic, strong) UIImage       *head;
@property (nonatomic, strong) UIImage       *loading;

@end

@implementation UserManager

+ (UserManager *)sharedInstance
{
    static UserManager *userManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[UserManager alloc] init];
    });
    return userManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:UserKey];
        if (data) {
            _loginUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        else{
            _loginUser = [[UserModel alloc] init];
            [self archivertUserInfo];
        }
    }
    return self;
}


#pragma mark - 用户信息
+ (void)saveUserInfo:(id)jsonObj
{
    if ([jsonObj isKindOfClass:[UserModel class]]) {
        [[UserManager sharedInstance] setLoginUser:jsonObj];
    }
    else if ([jsonObj isKindOfClass:[NSDictionary class]]) {
        [[UserManager sharedInstance] setLoginUser:[[UserModel alloc] initWithDict:jsonObj]];
        // 会员会有此字段
        NSDictionary *member = [jsonObj objectForKey:@"member"];
        // 是否过期
        BOOL is_expire = [[member objectForKey:@"is_expire"] boolValue];
        // 此处操作是为了登录成功后第一时间刷新 TabBar2 会员页面数据
        if (!dictionaryIsEmpty(member) && !is_expire) {
            //LOGIN_USER.vipInfo = @1;
        }
    }
    
    [[UserManager sharedInstance] setLoginUID:[LOGIN_USER uid]];
    [[UserManager sharedInstance] archivertUserInfo];
    
    //获取该用户最大拍摄时长
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UserManager sharedInstance] requestMaxShootDuration];
    });
}

- (void)archivertUserInfo
{
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self.loginUser];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:UserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)logOut
{
    // 清理本地存储的搜索记录
    [self clearUserBrowseRecord];
    // 清空草稿箱
    [MDCacheFileManager clearDiskWithType:CacheDraft];
    
    [[UserManager sharedInstance] setLoginUser:nil];
    [[UserManager sharedInstance] setLoginUID:nil];
    [[UserManager sharedInstance].likeArray removeAllObjects];
    [[UserManager sharedInstance] setAutoPlay:NO];
    
    // 清空我的未读消息数，需要先退出登录，在进行清空
    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:SubcriteTime];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sinaAccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:UserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)updateUserInfoWithType:(SaveTypes)types Info:(id)info
{
    // 更新用户本地数据
    switch (types) {
        case SaveTheNickType:
        {
            [LOGIN_USER setNick:info];
        }
            break;
            
        case SaveTheIconType:
        {
            //[LOGIN_USER setIcon:info];
        }
            break;
            
        case SaveTheDescriptionsType:
        {
            //[LOGIN_USER setDesc:info];
        }
            break;
            
        case SaveTheSexType:
        {
            [LOGIN_USER setSex:[info integerValue]];
        }
            break;
            
        case SaveTheBackGroundType:
        {
            //[LOGIN_USER setBackground:info];
        }
            break;
        case SaveTheFollowType:
        {
            //NSInteger Attention = [[[[UserManager sharedInstance] loginUser] Attention] integerValue];
            //Attention += [info integerValue];
            //[LOGIN_USER setAttention:[NSString stringWithFormat:@"%zd",Attention]];
        }
            break;
            
        case SaveTheReleaseType:
        {
            //NSInteger uploadData = [[[[UserManager sharedInstance] loginUser] videos] integerValue];
            //uploadData += [info integerValue];
            //[LOGIN_USER setVideos:[NSString stringWithFormat:@"%zd",uploadData]];
        }
            break;
            
        case SaveTheColloectType:
        {
            //NSInteger collections = [[[[UserManager sharedInstance] loginUser] video_collections] integerValue];
            //collections += [info integerValue];
            //[LOGIN_USER setVideo_collections:[NSString stringWithFormat:@"%ld",collections]];
        }
            break;
            
        case SaveTheLipPrintType:
        {
            //NSInteger red = [[[UserManager sharedInstance] loginUser] red];
            //red += [info integerValue];
            //[LOGIN_USER setRed:red];
        }
            break;
            
        default:
            break;
    }
    [[UserManager sharedInstance] archivertUserInfo];
}

#pragma mark - 视频相关
- (BOOL)isAutoPlay
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:IsAutoPlay];
}

- (void)setAutoPlay:(BOOL)isAuto
{
    // 默认关闭自动播放
    [[NSUserDefaults standardUserDefaults] setBool:isAuto forKey:IsAutoPlay];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addPublishWatermarkShowedCnt
{
    NSInteger showedTimes = [[NSUserDefaults standardUserDefaults] integerForKey:WatermarkCount];
    if (showedTimes >= kMaxWatermarkCount) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:++showedTimes forKey:WatermarkCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)needShowWatermarkTip
{
    NSInteger showedTimes = [[NSUserDefaults standardUserDefaults] integerForKey:WatermarkCount];
    return showedTimes < kMaxWatermarkCount;
}


#pragma mark - 搜索浏览记录
- (void)saveUserBrowseRecordWithSearchContentID:(NSNumber *)contentID contentType:(BrowseTypes)contentType
{
    // 读出保存的内容
    NSMutableArray *br_arr = [self acquireUserBrowseRecordWithSearchContentType:contentType];
    // 第一次保存 保存当前时间戳
    if (br_arr.count == 0) {
        NSString *currentTimeStr = [Util getCurrentTime];
        [[NSUserDefaults standardUserDefaults] setObject:currentTimeStr forKey:SaveBrowseRecDateKey];
    }
    // 添加到数组
    [br_arr addObject:contentID];
    // 保存搜索记录
    switch (contentType) {
        case SaveTheSearchContentVideoType:
            [[NSUserDefaults standardUserDefaults] setObject:br_arr forKey:VideoBrowseRecordKey];
            break;
        case SaveTheSearchContentPhotoType:
            [[NSUserDefaults standardUserDefaults] setObject:br_arr forKey:PhotoBrowseRecordKey];
            break;
        case SaveTheSearchContentOtherType:
            break;
            
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)acquireUserBrowseRecordWithSearchContentType:(BrowseTypes)contentType
{
    NSMutableArray *browseRecordArr = [NSMutableArray array];
    // 间隔超过一天 清除保存的数据
    NSString *firstSaveTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:SaveBrowseRecDateKey];
    if (!stringIsEmpty(firstSaveTimeStr)) {
        NSTimeInterval firstSaveTime = [firstSaveTimeStr doubleValue];
        NSTimeInterval d_value = [[NSDate date] timeIntervalSince1970] - firstSaveTime;
        
        if (d_value / 3600 > 24) {
            [self clearUserBrowseRecord];
        }
    }
    
    // 获取保存的浏览记录
    switch (contentType) {
        case SaveTheSearchContentVideoType:
            browseRecordArr = [[NSUserDefaults standardUserDefaults] objectForKey:VideoBrowseRecordKey];
            break;
        case SaveTheSearchContentPhotoType:
            browseRecordArr = [[NSUserDefaults standardUserDefaults] objectForKey:PhotoBrowseRecordKey];
            break;
        case SaveTheSearchContentOtherType:
            break;
            
        default:
            break;
    }
    
    return [NSMutableArray arrayWithArray:browseRecordArr];
}

- (void)clearUserBrowseRecord
{
    // 清除本地保存的浏览记录
    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray array] forKey:PhotoBrowseRecordKey];
    [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray array] forKey:VideoBrowseRecordKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 推送消息
//全能哥说可以去了，用不到了
- (void)recordLoginTime
{
    // 记录用户留存
    NSString *uid = LOGIN_USER ? [LOGIN_USER uid] : @"未知";
    if (stringIsEmpty(uid)) {
        uid = @"未知";
    }
    NSString *keyLoginSuccessTime = [NSString stringWithFormat:@"%@_%@", uid, LoginSuccessTime];
    NSString *keyLoginTimesKey = [NSString stringWithFormat:@"%@_%@", uid, LoginTime];
    
    NSString *loginSuccessTime = [[NSUserDefaults standardUserDefaults] stringForKey:keyLoginSuccessTime];
    NSString *curTime = [Util getCurrentTime];
    if([Util isSameDay:curTime :loginSuccessTime]) {
        return;
    }
    
    NSMutableArray *loginTimes = [[[NSUserDefaults standardUserDefaults] stringArrayForKey:keyLoginTimesKey] mutableCopy];
    if(!loginTimes){
        loginTimes = [[NSMutableArray alloc] init];
    }
    
    BOOL guard = NO;
    for (NSString *time in loginTimes) {
        if ([Util isSameDay:time :curTime]) {
            guard = YES;
        }
    }
    if (!guard) {
        [loginTimes addObject:curTime];
    }
    
    
    if (loginTimes.count > 0) {
        
        NSString *dateAdd = [loginTimes componentsJoinedByString:@","];
        
        NSArray *deveiceModelAry = getDeveiceModelName();
        NSString *telephoneType = @"";
        if (!arrayIsEmpty(deveiceModelAry)) {
            telephoneType = [deveiceModelAry firstObject];
        }
        NSString *networkType = @"";
        if (deveiceModelAry.count == 2) {
            networkType = [deveiceModelAry lastObject];
        }
        NSString *currentAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *dic = @{
                              @"platform"   :@"iOS",
                              @"uid"        :uid,
                              @"date_add"   :stringIsEmpty(dateAdd) ? @"未知" : dateAdd,
                              @"R"          :getDeveiceResolution(),
                              @"D"          :getDeveicePPI(),
                              @"C"          :getDeveiceCPU(),
                              @"M"          :getDeveiceMemory(),
                              @"V"          :getDeveiceSystemVersion(),
                              @"I"          :[Util getUUIDString],
                              @"IDFA"       :getDeveiceIDFA(),
                              @"T"          :telephoneType,
                              @"N"          :networkType,
                              @"CV"         :currentAppVersion
                               };
    }
}

#pragma mark - 获取最大拍摄时长 -
- (void)requestMaxShootDuration
{
}

#pragma mark - 个推通知管理
/**
 *  设置通知
 */
- (void)setAppGeTuiNotify:(BOOL)isOn
{
    NSString *appGeTuiNotifyWithUid = [NSString stringWithFormat:@"%@%@",appGeTuiNotify,[LOGIN_USER uid]];
    [[NSUserDefaults standardUserDefaults] setBool:!isOn forKey:appGeTuiNotifyWithUid];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)getAppGeTuiNotifyStatus
{
    // 默认打开，先取反
    NSString *appGeTuiNotifyWithUid = [NSString stringWithFormat:@"%@%@",appGeTuiNotify,[LOGIN_USER uid]];
    return ![[[NSUserDefaults standardUserDefaults] objectForKey:appGeTuiNotifyWithUid] boolValue];
}

//#pragma mark - 记录用户已经允许4g播放视频
//- (void)setAllowUseViaWWAN:(BOOL)isAllow
//{
//    // 默认是不允许
//    [[NSUserDefaults standardUserDefaults] setBool:isAllow forKey:isAllowUseViaWWAN];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//- (BOOL)isAllowUseViaWWAN
//{
//    return [[NSUserDefaults standardUserDefaults] boolForKey:isAllowUseViaWWAN];
//}
@end
