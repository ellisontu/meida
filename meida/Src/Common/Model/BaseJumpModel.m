//
//  BaseJumpModel.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//
#import "BaseJumpModel.h"
@interface BaseJumpModel ()
@property (nonatomic, strong) NSString      *urlPrefix;         /**< 跳转 url 的前缀 */
@property (nonatomic, strong) NSDictionary  *paramDict;         /**< 用于存储跳转 url 里的各个参数 */
@property (nonatomic, strong) NSString      *urlString;
@end
//
@implementation BaseJumpModel


- (instancetype)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        [self setJumpTypeByUrlString:urlString];
    }
    return self;
}


- (void)setJumpTypeByUrlString:(NSString *)urlString
{

    _urlString = urlString;
    if (stringIsEmpty(urlString)) {
        self.jumpType = BaseJumpModelTypeUnknow;
        return;
    }
    if (urlString.length < 6) {
        return;
    }
    NSString *head = [urlString substringToIndex:5];
    NSString *subStr = [urlString substringFromIndex:5];
    if ([head isEqualToString:@"http:"]) {
        // 转换成https
        urlString = [NSString stringWithFormat:@"https:%@", subStr];
    }
    //[self configJumpTypeByUrlString:urlString baseString:baseStrHttps];
}

- (NSMutableDictionary *)urlParams:(NSString *)url
{
    //NSURL *nsurl = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *nsurl = [NSURL URLWithString:url];
    NSString *params = [nsurl query];
    
    NSArray *keyValueArray = [params componentsSeparatedByString:@"&"];
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    NSInteger index = 0;
    /*
    for (NSString *subStr in keyValueArray) {
        NSArray *parpamArray = [subStr componentsSeparatedByString:@"="];
        for (int i = 0; i < parpamArray.count; i+=2) {
            if (parpamArray.count == 1) {
                [mdict setObject:parpamArray[i] forKey:@"type"];
            }
            else {
                if (i+1 < parpamArray.count) {
                    if (index == 0) {
                        [mdict setObject:parpamArray[i] forKey:@"type"];
                        [mdict setObject:[parpamArray[i+1] URLDecodedString:kCFStringEncodingUTF8] forKey:@"jumpID"];
                    }
                    else {
                        [mdict setObject:[parpamArray[i+1] URLDecodedString:kCFStringEncodingUTF8] forKey:parpamArray[i]];
                    }
                }
                else {
                    return nil;
                }
            }
            index++;
        }
    }
     */
    return mdict;
}

- (void)configJumpTypeByUrlString:(NSString *)urlString baseString:(NSString *)baseString
{
    NSMutableDictionary *mdict = [self urlParams:urlString];
    if (!mdict) {
        return;
    }
    _paramDict = mdict;
}

- (void)handelJump
{
    switch (self.jumpType) {
        default:
            break;
    }
}

@end
