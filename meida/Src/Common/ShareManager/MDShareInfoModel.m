//
//  MDShareInfoModel.m
//  meida
//
//  Created by ToTo on 2018/6/30.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDShareInfoModel.h"

@implementation MDShareInfoModel

- (instancetype)initWithShareInfoTitle:(NSString *)title text:(NSString *)text imageData:(NSData *)imageData shareUrl:(NSString *)shareUrl
{
    self = [super init];
    if (self) {
        NSString *sinaText = [NSString stringWithFormat:@"%@ %@", text, shareUrl];
        NSDictionary *dic_weibo = @{@"title":sinaText, @"imgData":imageData, @"url":shareUrl};
        NSDictionary *dic_weixin = @{@"title":title, @"content":text, @"imgData":imageData, @"url":shareUrl};
        NSDictionary *dic_timeline = @{@"title":title, @"content":text, @"imgData":imageData, @"url":shareUrl};
        NSDictionary *dic_qq = @{@"title":title, @"content":text, @"imgData":imageData, @"url":shareUrl};
        NSDictionary *dic_qqzone = @{@"title":title, @"content":text, @"imgData":imageData, @"url":shareUrl};
        
        _weibo = [[ShareTargetModel alloc] initWithShareInfoDic:dic_weibo];
        _weixin = [[ShareTargetModel alloc] initWithShareInfoDic:dic_weixin];
        _pengyouquan = [[ShareTargetModel alloc] initWithShareInfoDic:dic_timeline];
        _qq = [[ShareTargetModel alloc] initWithShareInfoDic:dic_qq];
        _qqzone = [[ShareTargetModel alloc] initWithShareInfoDic:dic_qqzone];
    }
    return self;
}

- (void)setPoster_thum_url:(NSString *)poster_thum_url
{
    _poster_thum_url = poster_thum_url;
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_poster_thum_url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (data) {
            self->_posterThumData = data;
            //_posterThumData = UIImageJPEGRepresentation(image, 0.7f);
            self->_posterThumImgH_W = image.size.height/image.size.width;
        }
    }];
}

- (void)setPoster_url:(NSString *)poster_url
{
    _poster_url = poster_url;
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_poster_url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (data) {
            //_posterData = UIImageJPEGRepresentation(image, 0.7f);
            self->_posterData = data;
        }
    }];
}

@end



@implementation ShareTargetModel

- (void)setIcon_url:(NSString *)icon_url
{
    _icon_url = icon_url;
    //_icon_url = [Util getImageStyleUrl:icon_url style:IMAGE_STYLE_POSTER];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_icon_url] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (data) {
            self->_iconData = data;
        }
    }];
}

- (instancetype)initWithShareInfoDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.title = [dic objectForKey:@"title"];
        self.content = [dic objectForKey:@"content"];
        self.target_url = [dic objectForKey:@"url"];
        self.icon_url = [dic objectForKey:@"img"];
        self.iconData = [dic objectForKey:@"imgData"];
    }
    return self;
}

@end
