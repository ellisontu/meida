//
//  EncryptionMethods.h
//  NightCafe
//
//  Created by zizp on 15/3/25.
//  Copyright (c) 2015年 Lucky_Truda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionMethods : NSObject

/**
 * 16位MD5 - 加密
 */
+ (NSString *)getMd5_16Bit_String:(NSString *)srcString;

/**
 * 32位MD5 - 加密
 */
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;

/**
 * SHA1 - 加密
 */
+ (NSString *)getSha1String:(NSString *)srcString;

/**
 * SHA256 - 加密
 */
+ (NSString *)getSha256String:(NSString *)srcString;

/**
 * SHA384 - 加密
 */
+ (NSString *)getSha384String:(NSString *)srcString;

/**
 * SHA512 - 加密
 */
+ (NSString *)getSha512String:(NSString *)srcString;

/**
 * HMAC_MD5 - 加密
 */
+ (NSData *)hmacMd5:(NSString *)hashString hmacKey:(NSString *)key;

/**
 * HMAC_SHA1 - 加密
 */
+ (NSData *)hmacSha1:(NSString *)hashString hmacKey:(NSString *)key;

/**
 * HMAC_SHA224 - 加密
 */
+ (NSData *)hmacSha224:(NSString *)hashString hmacKey:(NSString *)key;

/**
 * HMAC_SHA256 - 加密
 */
+ (NSData *)hmacSha256:(NSString *)hashString hmacKey:(NSString *)key;

/**
 * HMAC_SHA384 - 加密
 */
+ (NSData *)hmacSha384:(NSString *)hashString hmacKey:(NSString *)key;

/**
 * HMAC_SHA512 - 加密
 */
+ (NSData *)hmacSha512:(NSString *)hashString hmacKey:(NSString *)key;

/**
 * MD5 - NSData加密
 */
+ (NSString *)dataMD5String:(NSData *)data;

@end




