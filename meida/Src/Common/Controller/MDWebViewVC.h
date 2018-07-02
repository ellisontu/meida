//
//  MDWebViewVC.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDBaseViewController.h"

@interface MDWebViewVC : MDBaseViewController

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, strong) NSString  *cbMethod;   /**< 回调的函数名 */
@property (nonatomic, strong) NSString  *paramsStr;

// H5 回调 cbMethod 函数
// cbMethod == h5 回调 paramsStr == 需要给h5传递参数
- (void)evaluateJavaScript:(NSString *)cbMethod paramsStr:(NSString *)paramsStr;


@end
