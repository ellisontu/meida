//
//  MDWebViewVC.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDWebViewVC.h"
#import <WebKit/WebKit.h>
#import "ShareManager.h"
#import "NSString+URLEncoding.h"

#define PROTOCOL_URL @"https://www.ymfashion.com/protocol.html?md_share=0"

@interface MDWebViewVC ()<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) NSString *shareImageUrl;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, assign) BOOL isFinishLoad;    /**< 标记页面是否加载完成 */
@property (nonatomic, strong) NSString *cookieStr;  /**< cookie 字符串(传给H5去注册) */
@property (nonatomic, assign) BOOL isAlert;         /**< 标记是否有 Alert 弹窗 */
@property (nonatomic, strong) NSString *jumpUlr;    /**< 标记跳转 jumpUrl */

@end

@implementation MDWebViewVC

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"__setNativeTitle"];
    // 删除所有 Cookie
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 测试获取cookie的地址
    //_urlString = @"https://h5.ymfashion.com/cookie_test";
    //_urlString = @"https://h5.ymfashion.com/jump_test";
    //_urlString = @"http://www.lookhanju.com";
    _urlString = _urlString ? _urlString : PROTOCOL_URL;
    DLog(@"_urlString = %@", _urlString);
    
    [self configHeaderView];
    
    [self initData];
    
    //[self removeWebViewDataCache];
    
    [self initWebView];
    
    //分享成功后回调
    MDWeakPtr(weakPtr, self);
    [ShareManager sharedInstance].shareFinishBlock = ^(NSString *platform, BOOL success) {
        if (!stringIsEmpty(weakPtr.cbMethod)) {
            NSString *shareState = success ? @"1" : @"0";
            DLog(@"%@('%@',%@)", weakPtr.cbMethod, platform, shareState);
            NSString *cb_method = [NSString stringWithFormat:@"%@(%@)", weakPtr.cbMethod, shareState];
            [weakPtr.webView evaluateJavaScript:cb_method completionHandler:nil];
        }
    };
    
    // H5调起原生支付操作完成后的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"H5GoodsPayCallBackMethod" object:nil];
    // H5调原生通讯录操作完事儿的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressBookReadFinish:) name:@"h5CallAddressBookCallBack" object:nil];
    
    
    
}
- (void)configHeaderView
{
    self.view.backgroundColor = kDefaultBackgroundColor;
    self.navigationController.navigationBarHidden = YES;
    [self setNavigationType:NavShowBackAndTitleAndRight];
    [self setTitle:@""];
    [self setRightBtnWith:nil image:IMAGE(@"right_top_share")];
    
    //当有二级页面时，点击关闭按钮直接退出 webView
    _closeBtn = [UIButton newAutoLayoutView];
    _closeBtn.hidden = YES;
    [_closeBtn setImage:IMAGE(@"c_close") forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    [_closeBtn autoSetDimensionsToSize:CGSizeMake(44.f, 44.f)];
    [_closeBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:44.f];
    [_closeBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kStatusBarHeight];
}

- (void)initWebView
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //config.preferences.minimumFontSize = 18;
    
    CGRect frame = CGRectMake(0, kHeaderHeight, SCR_WIDTH, self.view.height - kHeaderHeight - kTabBarBottomHeight);
    //_webView = [[WKWebView alloc] initWithFrame:frame];
    _webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
    [self.view addSubview:_webView];
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    //[self configCookie];
    
    NSString *newStr = [_urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //newStr = @"http://www.baidu.com";
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newStr]];
    
    [self configCookieWithRequest:_request];
    
    [_webView loadRequest:_request];
    
    // 此方法是告诉 H5 native 有 __setNativeTitle 方法和 showSendMsg 方法
    [_webView.configuration.userContentController addScriptMessageHandler:self name:@"__setNativeTitle"];
    //[_webView.configuration.userContentController addScriptMessageHandler:self name:@"showSendMsg"];
    // JS 端代码如下
    // window.webkit.messageHandlers.__setNativeTitle.postMessage('Title是冬瓜')
    // window.webkit.messageHandlers.showSendMsg.postMessage(['18866668888', 'Go Climbing This Weekend !!!'])
}

- (void)initData
{
    // 默认分享图片，在获取不到分享图片时用的
    _shareImage = IMAGE(@"QQShare.jpg");
}

// 清理缓存
// 在 WKWebsiteDataStore 出现之前（iOS 9 中才出现），WKWebView 是没有缓存，也无从清理。
- (void)removeWebViewDataCache
{
    if (IOS_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        // iOS 9 以后终于可以使用 WKWebsiteDataStore 来清理缓存
        NSSet *types = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,
                                             WKWebsiteDataTypeMemoryCache,
                                             //WKWebsiteDataTypeCookies,
                                             ]];
        NSDate *dateFrom = [NSDate date];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:dateFrom completionHandler:^{
            DLog(@"clear webView cache");
        }];
    }
    else {
        // iOS 8 可以通过清理 Library 目录下的 Cookies 目录来清除缓存
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:nil];
    }
}

//在 loadRequest 前执行
// 在使用 UIWebVIew 的时候我们并不关注 Cookie，因为在调用登录接口的时候无论是AFNetworking，还是其他，登录成功之后都会自动保存在[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies 中，以后再使用也会自动去获取（这里有个 UIWebView 的坑：访问的链接越多，如不处理Cookie，它会加载越来越多的无效 Cookie 导致内容急剧增大）。
- (void)configCookieWithRequest:(NSMutableURLRequest *)request
{
    [self configCookie];
    
    if (request.URL) {
        // NSMutableURLRequest 注入的PHP等动态语言直接能从$_COOKIE对象中获取到，但是js读取不到，浏览器也看不到
        NSDictionary *cookiesDic = [NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL]];
        if ([cookiesDic objectForKey:@"Cookie"]) {
            [request setValue:cookiesDic[@"Cookie"] forHTTPHeaderField:@"Cookie"];
            //[request addValue:cookiesDic[@"Cookie"] forHTTPHeaderField:@"Cookie"];
            NSDictionary *dic = request.allHTTPHeaderFields;
            DLog(@"allHTTPHeaderFields = %@", dic);
        }
    }
    
    // JS注入的Cookie，比如PHP代码在Cookie容器中取是取不到的， javascript document.cookie能读取到，浏览器中也能看到。
    // 将所有 Cookie 以 document.cookie = 'key=value'; 形式进行拼接
    NSString *cookieInApp = @"md_inApp=1";
    NSString *cookieAppVersion = [NSString stringWithFormat:@"md_appVersion=%@", kAppVersion];
    NSString *cookieValue = [NSString stringWithFormat:@"document.cookie = '%@'; document.cookie = '%@'", cookieInApp, cookieAppVersion];
    
    if (LOGIN_USER && !stringIsEmpty(LOGIN_USER.token) && !stringIsEmpty(LOGIN_USER.prefix) && LOGIN_USER.hashTimes) {
        NSString *cookieToken = [NSString stringWithFormat:@"md_token=%@", LOGIN_USER.token];
        NSString *cookiePrefix = [NSString stringWithFormat:@"md_prefix=%@", LOGIN_USER.prefix];
        NSString *cookieHashTimes = [NSString stringWithFormat:@"md_hashTimes=%@", LOGIN_USER.hashTimes];
        cookieValue = [NSString stringWithFormat:@"%@; document.cookie = '%@'; document.cookie = '%@'; document.cookie = '%@'", cookieValue, cookieToken, cookiePrefix, cookieHashTimes];
        
        _cookieStr = [NSString stringWithFormat:@"%@; %@; %@", cookieToken, cookiePrefix, cookieHashTimes];
    }
    
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieValue injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [_webView.configuration.userContentController addUserScript:cookieScript];
    
    NSDictionary *dic = request.allHTTPHeaderFields;
    DLog(@"allHTTPHeaderFields = %@", dic);
}

//在 loadRequest 前执行
- (void)configCookie
{
    NSDictionary *inAppDic = @{NSHTTPCookieName:@"md_inApp",
                               NSHTTPCookieValue:@"1",
                               NSHTTPCookieDomain:@".ymfashion.com",
                               NSHTTPCookiePath:@"/"};
    NSHTTPCookie *cookieInApp = [NSHTTPCookie cookieWithProperties:inAppDic];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieInApp];
    
    NSDictionary *appVersionDic = @{NSHTTPCookieName:@"md_appVersion",
                                    NSHTTPCookieValue:kAppVersion,
                                    NSHTTPCookieDomain:@".ymfashion.com",
                                    NSHTTPCookiePath:@"/"};
    NSHTTPCookie *cookieAppVersion = [NSHTTPCookie cookieWithProperties:appVersionDic];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieAppVersion];
    
    
    if (LOGIN_USER && !stringIsEmpty(LOGIN_USER.token) && !stringIsEmpty(LOGIN_USER.prefix) && LOGIN_USER.hashTimes) {
        NSDictionary *tokenDic = @{NSHTTPCookieName:@"md_token",
                                   NSHTTPCookieValue:LOGIN_USER.token,
                                   NSHTTPCookieDomain:@".ymfashion.com",
                                   NSHTTPCookiePath:@"/"};
        NSHTTPCookie *cookieToken = [NSHTTPCookie cookieWithProperties:tokenDic];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieToken];
        
        NSDictionary *prefixDic = @{NSHTTPCookieName:@"md_prefix",
                                    NSHTTPCookieValue:LOGIN_USER.prefix,
                                    NSHTTPCookieDomain:@".ymfashion.com",
                                    NSHTTPCookiePath:@"/"};
        NSHTTPCookie *cookiePrefix = [NSHTTPCookie cookieWithProperties:prefixDic];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookiePrefix];
        
        NSDictionary *hashTimesDic = @{NSHTTPCookieName:@"md_hashTimes",
                                       NSHTTPCookieValue:[NSString stringWithFormat:@"%@", LOGIN_USER.hashTimes],
                                       NSHTTPCookieDomain:@".ymfashion.com",
                                       NSHTTPCookiePath:@"/"};
        NSHTTPCookie *cookieHashTimes = [NSHTTPCookie cookieWithProperties:hashTimesDic];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieHashTimes];
        
    }
    else {
        //未登录删除 以上3个 cookie
        [self deleteCookie];
    }
}

- (void)deleteCookie
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        if ([cookie.name isEqualToString:@"md_token"] || [cookie.name isEqualToString:@"md_prefix"] || [cookie.name isEqualToString:@"md_hashTimes"]) {
            [storage deleteCookie:cookie];
        }
    }
}

- (void)back:(id)sender
{
    if (_webView.canGoBack) {
        _closeBtn.hidden = NO;
        [_webView goBack];
    }
    else {
        _closeBtn.hidden = YES;
        if (_dismissBlock) {
            _dismissBlock();
        }
        [super back:nil];
    }
}

- (void)closeButtonAction
{
    if (_dismissBlock) {
        _dismissBlock();
    }
    [super back:nil];
}

- (void)rightBtnTapped:(id)sender
{
    if (!_isFinishLoad) {
        return;
    }
    if (![ShareManager sharedInstance].isShow) {
        NSString *jsMethod = @"__share()";
        [_webView evaluateJavaScript:jsMethod completionHandler:nil];
    }
}

- (void)getShareImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //NSString *shareImageUrl = shareImageUrl;
        NSData *shareImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self->_shareImageUrl]];
        self->_shareImage = [UIImage imageWithData:shareImageData];
    });
}

- (void)showOrHideShareBtnWithUrl:(NSString *)url
{
    //以后所有的 H5 页面，只要 url 中带有 md_share=0 的字样则不显示分享按钮，其它情况都显示
    NSString *urlQuery = [[NSURL URLWithString:url] query];
    NSArray *urlComponents = [urlQuery componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        if ([key isEqualToString:@"md_share"] && [value isEqualToString:@"0"]) {
            [self hideRightBtn];
            break;
        }
        else {
            [self showRigntBtn];
        }
    }
}

// H5 调用 native 方法时的代理方法
#pragma mark - WKScriptMessageHandler -
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:@"__setNativeTitle"]) {
        NSString *title = [NSString stringWithFormat:@"%@", message.body];
        [self setTitle:title];
    }
}

#pragma mark - WKNavigationDelegate -
// *******   页面跳转的代理方法有三种，分为（收到跳转与决定是否跳转两种）   *******
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 为了在登录后H5刷新请求能拿到登录态，在此添加 Cookie
    //[self configCookieWithRequest:[NSMutableURLRequest requestWithURL:navigationAction.request.URL]];
    
    NSString *method = NSStringFromSelector(_cmd);
    DLog(@"在发送请求之前，决定是否跳转  *******  %@  *******", method);
    
    NSString *stringUrl = [navigationAction.request.URL description];
    DLog(@"stringUrl = %@", stringUrl);
    //NSString *stringUrl = @"md://ymfashion/h5?method=share_v1&poster=${}&share_info=${分享信息}&cb=${回调函数名字}";
    //md://ymfashion/h5?method=take_photo&max=${最多多少张图片}cb=${回调函数名字}
    
    // 1. 处理和原生有业务交互的url 比如说: 分享/获取通讯录/支付呀/等等等
    if ([stringUrl hasPrefix:@"md://ymfashion/h5?"]) {
        [Util checkUrlParamsWithUrlString:stringUrl];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // 2. 处理登录
    else if ([stringUrl hasPrefix:@"md://ymfashion/params?login"]) {
        // 登录单独处理，因为方便登录成功后回调 js 方法
        [self handleLoginSchemeOpenUrl:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // 3. 处理应用跳转用的，jump_url
    else if ([stringUrl hasPrefix:@"md://ymfashion/params?"]) {
        [Util checkUrlParamsWithUrlString:stringUrl];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    // 4. 处理跳转 应用市场 jump_url
    else if ([stringUrl hasPrefix:@"https://itunes.apple.com/"]) {
        // itms://itunes.apple.com/us/app/%E9%9F%A9%E5%89%A7tv%E8%BF%B7/id1255085370?l=zh&ls=1&mt=8
        // 将 https:// 替换为 itms:// 或者 itms-apps://  (其中:itms是跳转到 iTunes Store  itms-apps是跳转到 App Store)
        NSString *openUrl = [stringUrl stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:@"itms-apps"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSString *method = NSStringFromSelector(_cmd);
    DLog(@"接收到服务器跳转请求之后调用  *******  %@  *******", method);
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSString *method = NSStringFromSelector(_cmd);
    DLog(@"在收到响应后，决定是否跳转  *******  %@  *******", method);
}

// *******   该代理提供的方法，可以用来追踪加载过程（页面开始加载、加载完成、加载失败）   *******
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSString *method = NSStringFromSelector(_cmd);
    DLog(@"页面开始加载  *******  %@  *******", method)
    
    NSString *url = [webView.URL absoluteString];
    
    [self showOrHideShareBtnWithUrl:url];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSString *method = NSStringFromSelector(_cmd);
    DLog(@"内容开始返回  *******  %@  *******", method)
    
    _isFinishLoad = YES;
}

// 页面加载完成之后调用（有时候此方法执行特别慢）
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSString *method = NSStringFromSelector(_cmd);
    DLog(@"页面加载完成  *******  %@  *******", method)
    
    _shareUrl = [webView.URL absoluteString];
    _shareTitle = webView.title;
    [self setTitle:_shareTitle];
    
    _isFinishLoad = YES;
    
    DLog(@"shareTitle = %@, shareUrl = %@", _shareTitle, _shareUrl);
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    NSString *method = NSStringFromSelector(_cmd);
    DLog(@"页面加载失败  *******  %@", method)
    [Util showMessage:@"页面加载失败" forDuration:1.5f inView:self.view];
}

#pragma mark - WKUIDelegate -
//- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
//{
//    NSString *method = NSStringFromSelector(_cmd);
//    DLog(@"创建一个新的webView时调用  *******  %@  *******", method);
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//
//    return nil;
//}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSString *method = NSStringFromSelector(_cmd);
    DLog(@"界面弹出警告框时调用  *******  %@  *******", method);
    //[self showMsg:message];
    DLog(@"message = %@", message);
    
    // 线上环境绝对不会弹 alert (晓晨说)
    if (URL_CONFIG == 3 || URL_CONFIG == 4) {
        _isAlert = YES;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            DLog(@"点击确定");
            if (![message isEqualToString:@"调用回调"] && !stringIsEmpty(_jumpUlr)) {
            }
            _isAlert = NO;
        }]];
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
    completionHandler();
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    NSString *method = NSStringFromSelector(_cmd);
    DLog(@"界面弹出确认框时调用  *******  %@  *******", method);
    //[self showMsg:message];
    DLog(@"message = %@", message);
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    NSString *method = NSStringFromSelector(_cmd);
    DLog(@"界面弹出输入框时调用  *******  %@  *******", method);
}


#pragma mark - 处理登录 后期给提取出去 -
// 处理登录 Scheme
- (void)handleLoginSchemeOpenUrl:(NSURL *)url
{
    
    NSString *urlQuery = [url query];
    NSArray *urlComponents = [urlQuery componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
        [parameterDic setObject:value forKey:key];
    }
    NSString *urlHost = [url host];
    if ([urlHost isEqualToString:@"ymfashion"]) {
        
        NSString *login = [parameterDic objectForKey:@"login"];
        if ([login isEqualToString:@"1"]) {
            //回调的函数名
            _cbMethod = [parameterDic objectForKey:@"cb"];
            // 弹出登录框
        }
    }
}

#pragma mark - 关于部分业务落处理后需要 通知回调js method代码的处理 ####################################
/**
 H5 调取原生通讯录后 回调执行动作
 */
- (void)addressBookReadFinish:(NSNotification *)notify
{
    if (notify && [notify.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *addressBookdict = (NSDictionary *)notify.object;
        NSString *cbMethod = @"__load_address_book";
        NSString *params = [self dictToJson:addressBookdict];
        [self evaluateJavaScript:cbMethod paramsStr:params];
    }
    
}

/**
 H5 调取原生支付 支付成功或者失败后 回调执行动作
 */
- (void)paySuccess:(NSNotification *)notify
{
    // 执行回调
    if (!stringIsEmpty(self.cbMethod)) {
        [self evaluateJavaScript:self.cbMethod paramsStr:self.paramsStr];
    }
}

/**
 执行js code
 */
- (void)evaluateJavaScript:(NSString *)cbMethod paramsStr:(NSString *)paramsStr
{
    if (!stringIsEmpty(cbMethod)) {
        // 拼接参数 字符串
        NSString *params = stringIsEmpty(paramsStr) ? @"" :  [NSString stringWithFormat:@"'%@'",paramsStr];
        // 拼接方法 js string
        NSString *javaScript = [NSString stringWithFormat:@"%@(%@)", cbMethod,params];
        // 执行
        DLog(@"javaScript string ===== %@",javaScript);
        [_webView evaluateJavaScript:javaScript completionHandler:nil];
    }
}

// 转换 用户信息数组 json
- (NSString *)dictToJson:(NSDictionary *)dict
{
    if (!dict) return @"";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
