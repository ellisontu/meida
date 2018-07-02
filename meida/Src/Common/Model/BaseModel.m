//
//  BaseModel.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithDict:(id)dict {
    if (self = [super init]) {
        
        NSString *clsString = NSStringFromClass([self class]);
        Class cls = NSClassFromString(clsString);
        self = [cls yy_modelWithDictionary:dict];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; }

- (NSString *)description
{
    return [self yy_modelDescription];
}



#pragma mark - 计算 model 高度
- (void)initModelHeight
{
    
}

@end
