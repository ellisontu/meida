//
//  MDExceptionManager.m
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDExceptionManager.h"
#import "MDCacheFileManager.h"

@interface MDExceptionModel : NSObject

@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSArray *stackSymbols;

@end

@implementation MDExceptionModel

@end


@implementation MDExceptionManager

+ (void)saveException:(NSException *)exception;
{
    MDExceptionModel *model = [[MDExceptionModel alloc] init];
    model.reason = [exception reason];
    model.stackSymbols = [exception callStackSymbols];
    
    if (LOGIN_USER) {
        model.uid = LOGIN_USER.uid;
        model.nickName = LOGIN_USER.nick;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    model.time = [formatter stringFromDate:[NSDate date]];
    
    NSString *jsonString = [model yy_modelToJSONString];
    
    NSError *error = nil;
    [jsonString writeToFile:[MDCacheFileManager cachePathWithType:CacheExceptionFile] atomically:YES encoding:NSUTF8StringEncoding error:&error];
}

+ (void)checkLocalException
{
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithContentsOfFile:[MDCacheFileManager cachePathWithType:CacheExceptionFile] encoding:NSUTF8StringEncoding error:&error];
    [self _postLocoalExceptionString:jsonString];
}

+ (void)_postLocoalExceptionString:(NSString *)jsonString
{
    if (stringIsEmpty(jsonString)) return;
    NSDictionary *para = @{@"exception" : jsonString};
    
}

@end
