//
//  Themes.h
//  meida
//
//  Created by ToTo on 2018/6/26.
//  Copyright © 2018年 ymfashion. All rights reserved.
//
//  此文件用于存放 APP中颜色、字体、图片等比较文艺的信息😊


#ifndef meida_Themes_h
#define meida_Themes_h

#pragma mark ------------------ 颜色 ------------------

#define kDefaultFontColorBlack              UIColorFromRGB(0x4c4c4c)
#define kDefaultFontColorRed                UIColorFromRGB(0xfe4545)
#define kDefaultFontColorGray               UIColorFromRGB(0x929292)
#define kDefaultFontColorLightGray          UIColorFromRGB(0x8c8c8c)

#define kDefaultBorderColor                 UIColorFromRGB(0xa8a8a8)
#define kDefaultTransparentBackgroundColor  RGBA(55,55,55,0.95)
#define kDefaultTextEditContainerBgColor    UIColorFromRGB(0x565656)
#define kDefaultTextEditSubContainerBgColor UIColorFromRGB(0x383838)
#define kDefaultColorGray                   UIColorFromRGB(0xe5e5e5)
#define kDefaultColorPink                   UIColorFromRGB(0xfff0f0)
#define COLOR_WITH_WHITE                    [UIColor whiteColor]
#define COLOR_WITH_BLACK                    [UIColor blackColor]
#define COLOR_WITH_CLEAR                    [UIColor clearColor]
#define COLOR_LIGHT_GRAY                    [UIColor lightGrayColor]
#define COLOR_WITH_ORANGE_RED               [Util colorWithHexString:@"#FF4500"]
#define COLOR_WITH_SEPARATOR                [Util colorWithHexString:@"#CACACA"]
#define COLOR_WITH_BORDER                   [Util colorWithHexString:@"#DEDEDE"]
#define COLOR_HEX_STR(HEXSTR)               [Util colorWithHexString:HEXSTR]
#define COLOR_LIGHT_BLACK                   [Util colorWithHexString:@"#222222"]
#define COLOR_TOAST_BACK                    [Util colorWithHexString:@"#ff5081"]
//#define COLOR_WITH_YELLOW                   [Util colorWithHexString:@"#ca912d"]
#define COLOR_WITH_DEF_BALCK                [Util colorWithHexString:@"#2f3739"]
#define COLOR_WITH_YELLOW_DARK              [Util colorWithHexString:@"#efd1af"]
// 胡扯个"贱人"又加了一个新的黄黄的色值！
#define COLOR_WITH_YELLOW                   [Util colorWithHexString:@"#fab464"]

#define kDefaultVolumeBarOrigin             UIColorFromRGB(0xf7d07e)
#define kDefaultVolumeBarMusic              UIColorFromRGB(0xd0c6ec)
#define kDefaultVolumeBarVoice              UIColorFromRGB(0x9cdaef)

//X: 0.0f -- 1.0f
//象牙黑
#define COLOR_LVORYBLACK_ALPHA(X) [UIColor colorWithRed:41/255.0f green:36/255.0f blue:33/255.0f alpha:X]

#pragma mark ------------------ 美哒新版UI颜色 ------------------
/**
 *  默认红色
 */
//#define RED                                 UIColorFromRGB(0xff3657)  // 确定使用新版RED
#define RED                                 UIColorFromRGB(0xff3167)

/**
 *  默认背景颜色（经久不衰的，一直沿用至今）
 */
//#define kDefaultBackgroundColor             UIColorFromRGB(0xefeff4)  // 确定使用新版kDefaultBackgroundColor
#define kDefaultBackgroundColor             [Util colorWithHexString:@"#f5f5f5"]

/**
 *  默认背景颜色（首页推荐达人卡片背景色）
 */
#define kDefaultBackgroundWhiteColor        UIColorFromRGB(0xfafafa)

/**
 *  默认背景颜色 (视频详情背景)
 */
#define kDefaultVideoDetailColor            UIColorFromRGB(0xc9c9d5)

/**
 *  默认分割线 浅色的
 */
#define kDefaultSeparationLineLightColor    UIColorFromRGB(0xefefef)

/**
 *  控件分割线   深色的
 *  控件不可点击状态
 *  三级文字颜色
 */
#define kDefaultSeparationLineColor         UIColorFromRGB(0xcccccc)

/**
 *  主要文字 标题名称
 */
#define kDefaultTitleColor                  UIColorFromRGB(0x222222)

/**
 *  次级文字 副标题
 *  按钮标题
 */
#define kDefaultSubTitleColor               UIColorFromRGB(0x808080)

/**
 *  三级标题文字
 */
#define kDefaultThirdTitleColor             UIColorFromRGB(0xcccccc)

/***********************我是华丽的分割线**************************/
/**
 *  商城  商品描述
 *  按钮标题
 */
#define kDefaultStoreDescColor               UIColorFromRGB(0x363636)


/**
 *  占位图的背景颜色
 */
#define kDefaultPlaceholderColor            UIColorFromRGB(0xf1f1f1)

#pragma mark ------------------ 获取颜色的方法 ------------------

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green : ((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue : ((float)(rgbValue & 0xFF))/255.0 alpha : a]

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]



#pragma mark ------------------ 图片 ------------------
#define IMAGE(imageName)        [UIImage imageNamed:imageName]
#define IMAGE_LOADING           IMAGE(@"loading")
#define IMAGE_USER              IMAGE(@"user_default")

#pragma mark ------------------ 字体 ------------------
#define FONT_SYSTEM_NORMAL(X)   [UIFont systemFontOfSize:X]
#define FONT_SYSTEM_BOLD(X)     [UIFont boldSystemFontOfSize:X]

#endif
