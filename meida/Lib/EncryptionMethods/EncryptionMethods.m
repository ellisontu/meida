//
//  EncryptionMethods.m
//  NightCafe
//
//  Created by zizp on 15/3/25.
//  Copyright (c) 2015年 Lucky_Truda. All rights reserved.
//

#import "EncryptionMethods.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

int32_t const MD_CHUNK_SIZE = 8 * 1024;

@implementation EncryptionMethods

#pragma mark - 16位MD5 - 加密方式
+ (NSString *)getMd5_16Bit_String:(NSString *)srcString
{
    //提取32位MD5散列的中间16位(去掉前8位和后8位)
    NSString *md5_32Bit_String = [self getMd5_32Bit_String:srcString];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    
    return result;
}


#pragma mark - 32位MD5 - 加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString
{
    const char *cStr = [srcString UTF8String];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}


#pragma mark - SHA1 - 加密方式
+ (NSString *)getSha1String:(NSString *)srcString
{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

#pragma mark - SHA256 - 加密方式
+ (NSString *)getSha256String:(NSString *)srcString
{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

#pragma mark - SHA384 - 加密方式
+ (NSString *)getSha384String:(NSString *)srcString
{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    
    CC_SHA384(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA384_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

#pragma mark - SHA512 - 加密方式
+ (NSString *)getSha512String:(NSString*)srcString
{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

/***-------- HMAC_SHA --------***/
#pragma mark - HMAC_MD5 - 加密方式
+ (NSData *)hmacMd5:(NSString *)hashString hmacKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [hashString cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_MD5_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgMD5, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

#pragma mark - HMAC_SHA1 - 加密方式
+ (NSData *)hmacSha1:(NSString *)hashString hmacKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [hashString cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

#pragma mark - HMAC_SHA224 - 加密方式
+ (NSData *)hmacSha224:(NSString *)hashString hmacKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [hashString cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA224_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA224, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

#pragma mark - HMAC_SHA256 - 加密方式
+ (NSData *)hmacSha256:(NSString *)hashString hmacKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [hashString cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

#pragma mark - HMAC_SHA384 - 加密方式
+ (NSData *)hmacSha384:(NSString *)hashString hmacKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [hashString cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA384_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA384, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

#pragma mark - HMAC_SHA512 - 加密方式
+ (NSData *)hmacSha512:(NSString *)hashString hmacKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [hashString cStringUsingEncoding:NSUTF8StringEncoding];
    uint8_t cHMAC[CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    return [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
}

#pragma mark - MD5 - NSData加密
+ (NSString *)dataMD5String:(NSData *)data
{
    unsigned char * md5Bytes = (unsigned char *)[[self _dataMD5:data] bytes];
    return [self _convertMd5Bytes2String:md5Bytes];
    
}

+ (NSString *)_convertMd5Bytes2String:(unsigned char *)md5Bytes {
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            md5Bytes[0], md5Bytes[1], md5Bytes[2], md5Bytes[3],
            md5Bytes[4], md5Bytes[5], md5Bytes[6], md5Bytes[7],
            md5Bytes[8], md5Bytes[9], md5Bytes[10], md5Bytes[11],
            md5Bytes[12], md5Bytes[13], md5Bytes[14], md5Bytes[15]
            ];
}

+ (NSData *)_dataMD5:(NSData *)data
{
    if(data == nil) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    for (int i = 0; i < data.length; i += MD_CHUNK_SIZE) {
        NSData *subdata = nil;
        if (i <= ((long)data.length - MD_CHUNK_SIZE)) {
            subdata = [data subdataWithRange:NSMakeRange(i, MD_CHUNK_SIZE)];
            CC_MD5_Update(&md5, [subdata bytes], (CC_LONG)[subdata length]);
        } else {
            subdata = [data subdataWithRange:NSMakeRange(i, data.length - i)];
            CC_MD5_Update(&md5, [subdata bytes], (CC_LONG)[subdata length]);
        }
    }
    unsigned char digestResult[CC_MD5_DIGEST_LENGTH * sizeof(unsigned char)];
    CC_MD5_Final(digestResult, &md5);
    return [NSData dataWithBytes:(const void *)digestResult length:CC_MD5_DIGEST_LENGTH * sizeof(unsigned char)];
}

@end
