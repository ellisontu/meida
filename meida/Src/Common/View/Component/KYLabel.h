//
//  TextLabel.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UnderlineStyle) {
    UnderlineStyleNone        = 0x00,
    UnderlineStyleSingle      = 0x01,
    UnderlineStyleThick       = 0x02,
    UnderlineStyleDouble      = 0x09,
};

@interface KYLabel : UILabel

/**行间距*/
@property (nonatomic, assign) CGFloat lineSpace;
/**字符间距*/
@property (nonatomic, assign) CGFloat letterSpace;
/**段后的间距*/
@property (nonatomic, assign) CGFloat paragraphSpacing;
/**段前的间距*/
@property (nonatomic, assign) CGFloat paragraphSpacingBefore;
/**首行缩进*/
@property (nonatomic, assign) CGFloat firstLineHeadIndent;
/**行间距的倍数*/
@property (nonatomic, assign) CGFloat lineHeightMultiple;
/**自适应高度*/
@property (nonatomic, assign) BOOL autoAdjustHeight;    //Default is NO;
/**复制功能*/
@property (nonatomic, assign) BOOL canCopy;             //Default is NO;

/**设置复制的标题*/
- (void)setCopyTitle:(NSString *)copyTitle;

/**设置下划线样式和范围*/
- (void)setUnderlineStyle:(UnderlineStyle)underlineStyle withRange:(NSRange)range;
- (void)setUnderlineStyle:(UnderlineStyle)underlineStyle withString:(NSString *)string;

/**设置删除线范围*/
- (void)setDeletelineWithRange:(NSRange)range;
- (void)setDeletelineWithString:(NSString *)string;

/**设置对应字符串范围的字体*/
- (void)setStringFont:(UIFont *)font withRange:(NSRange)range;
- (void)setStringFont:(UIFont *)font withString:(NSString *)string;

/**设置范围内字体的颜色*/
- (void)setStringColor:(UIColor *)color withRange:(NSRange)range;
- (void)setStringColor:(UIColor *)color withString:(NSString *)string;

@end
