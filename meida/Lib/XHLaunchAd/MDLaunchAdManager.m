//
//  MDLaunchAdManager.m
//  meida
//
//  Created by ToTo on 2018/7/6.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDLaunchAdManager.h"
#import "XHLaunchAd.h"
#import "AppDelegate.h"
#import "MDLaunchAdModel.h"
//#import "BrowserViewController.h"
//#import "OpenAdRequest.h"
//#import "UIViewController+TopViewController.h"
//#import <UMAnalytics/MobClick.h>

@interface MDLaunchAdManager()<XHLaunchAdDelegate>

//@property (nonatomic,strong)OpenAdRequest *openAdRequest;
@property (nonatomic,strong)MDLaunchAdModel *openAdInfo;

@property (nonatomic,assign) BOOL isExtLink;    //YES-外部链接，NO-内部链接

@end


@implementation MDLaunchAdManager

+(MDLaunchAdManager *)shareManager{
    
    static MDLaunchAdManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        instance = [[MDLaunchAdManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupXHLaunchAd];
    }
    return self;
}

-(void)setupXHLaunchAd
{
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    
    [XHLaunchAd setWaitDataDuration:3];
    
    //TODO: - 测试数据
    [[MDNetWorking sharedClient] requestWithPath:@"" params:nil httpMethod:MethodGet callback:^(BOOL rs, NSObject *obj) {
        if (rs) {
            
        }
    }];
    
}

-(void)judgeAdType{
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970]*1000;
    if (_openAdInfo.imgUrl!=nil && _openAdInfo.imgUrl.length > 5) {
        if (nowtime > _openAdInfo.validStartData && nowtime < _openAdInfo.validEndData)
        {
            [self loadAdImage];
        }

    }
    else if(_openAdInfo.videoUrl!=nil && _openAdInfo.videoUrl.length > 5){
        if (nowtime > _openAdInfo.validStartData && nowtime < _openAdInfo.validEndData) {
            [self loadAdVideo];
        }
        
    }
}

-(void)loadAdImage
{
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将自动进入window的RootVC
    //3.数据获取成功,初始化广告时,自动结束等待,显示广告
    //请求广告数据前,必须设置,否则会先进入window的RootVC
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = _openAdInfo.showTime;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    imageAdconfiguration.imageNameOrURLString = _openAdInfo.imgUrl;
    //缓存机制(仅对网络图片有效)
    //为告展示效果更好,可设置为XHLaunchAdImageCacheInBackground,先缓存,下次显示
    imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
    //    //广告点击打开链接
    //    imageAdconfiguration.extLinkUrl = _openAdInfo.extLinkUrl;
    //    //广告点击内部链接链接
    //    imageAdconfiguration.linkUrl = _openAdInfo.linkUrl;
    
    self.isExtLink = _openAdInfo.linkUrl?NO:YES;
    
    imageAdconfiguration.openModel = _openAdInfo.linkUrl?_openAdInfo.linkUrl:_openAdInfo.extLinkUrl;
    
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate =ShowFinishAnimateNone;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeTimeText;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    
    //显示开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
}

-(void)loadAdVideo
{
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将自动进入window的RootVC
    //3.数据获取成功,初始化广告时,自动结束等待,显示广告
    //[XHLaunchAd setWaitDataDuration:3];//请求广告数据前,必须设置,否则会先进入window的RootVC
    //配置广告数据
    XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration new];
    //广告停留时间
    videoAdconfiguration.duration = _openAdInfo.showTime;
    //广告frame
    videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告视频URLString/或本地视频名(请带上后缀)
    //注意:视频广告只支持先缓存,下次显示
    videoAdconfiguration.videoNameOrURLString = _openAdInfo.videoUrl;
    //视频缩放模式
    videoAdconfiguration.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //    //广告点击内部链接
    //    videoAdconfiguration.linkUrl = _openAdInfo.linkUrl;
    //
    //    //广告点击打开链接
    //    videoAdconfiguration.extLinkUrl = _openAdInfo.extLinkUrl;
    
    videoAdconfiguration.openModel = _openAdInfo.linkUrl?_openAdInfo.linkUrl:_openAdInfo.extLinkUrl;
    
    self.isExtLink = _openAdInfo.linkUrl?NO:YES;
    
    //广告显示完成动画
    videoAdconfiguration.showFinishAnimate =ShowFinishAnimateNone;
    //后台返回时,是否显示广告
    videoAdconfiguration.showEnterForeground = NO;
    //跳过按钮类型
    videoAdconfiguration.skipButtonType = SkipTypeTimeText;
    
    [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
    
    
}

- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint
{
    
    if (!openModel || ((NSString*)openModel).length == 0) {
        
        return;
    }
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    for(UIView *idView in appDelegate.window.subviews){
//        if (idView.tag == VIEWINWINDOWTAG){
//            [idView removeFromSuperview];
//        }
//    }
//
//    if (self.isExtLink) {//外部链接
//
//        [MobClick event:IF_AD_EXTLINKURL_CLICK];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(NSString*)openModel]];
//    }
//    else{//内部链接
//
//        [MobClick event:IF_AD_LINKURL_CLICK];
//        BrowserViewController *VC = [[BrowserViewController alloc] init];
//        //VC.URLString = openURLString;
//        //此处不要直接取keyWindow
//
//        [VC openUrl:(NSString*)openModel];
//
//        UIViewController *topmostVC = [UIViewController topViewController];
//        VC.hidesBottomBarWhenPushed = YES;
//        [topmostVC.navigationController pushViewController:VC animated:YES];
//
//    }
}

@end
