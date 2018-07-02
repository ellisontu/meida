//
//  HandleOpenUrlManager.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandleOpenUrlManager : NSObject

@property (nonatomic, strong) NSString *cbMethod;   /**< 分享成功后回调的函数名 */

+ (HandleOpenUrlManager *)sharedInstance;

- (BOOL)hanleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApp;

@end
