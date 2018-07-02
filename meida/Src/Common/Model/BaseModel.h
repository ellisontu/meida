//
//  BaseModel.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface BaseModel : NSObject <NSCoding>

@property (nonatomic, assign) CGFloat modelHeight;

- (instancetype)initWithDict:(id)dict;

- (void)initModelHeight;

@end
