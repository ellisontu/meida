//
//  NSString+Path.m
//  meida
//
//  Created by ToTo on 2018/7/10.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Path)
+(NSString*) getDocumentPath;
//返回 "document/dir/" 文件夹路径
-(NSString*) getPathForDocuments;


//返回 "document/dir/filename" 路径
-(NSString*) getPathForDocumentsinDir:(NSString*)dir;
//文件是否存在
-(BOOL) isFileExists;
//删除文件
-(BOOL)deleteWithFilepath;
//返回该文件目录下 所有文件名
-(NSArray*)getFilenamesWithDir;

@end
