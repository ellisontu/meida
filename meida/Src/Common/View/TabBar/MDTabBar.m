//
//  MDTabBar.m
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "MDTabBar.h"
#import "MDTabBarSubviews.h"
#import "MDTabBarManager.h"
#import <UIImage+GIF.h>

CGFloat const kOriginImageViewW = 27.f;
CGFloat const kOriginImageViewY = 4.5;
CGFloat const kOriginNameLabelY = 35.f;
CGFloat const kOriginNameLabelH = 12.f;
CGFloat const kNameFont         = 10.f;

@interface MDTabBar ()

/**
 *  记录当前选中的按钮
 */
@property (nonatomic, weak) MDTabBarButton *selectedButton;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *selImageArray;

@end

@implementation MDTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _imageArray = [[MDTabBarManager sharedInstance] tabbarImageNameArray];
        _selImageArray = [[MDTabBarManager sharedInstance] tabbarHighLightImageArray];
        
        [self _setupViews];
        [self _setupUpdateBlock];
        NSDictionary *lastZipParams = [[MDTabBarManager sharedInstance] zipParams];
        [[MDTabBarManager sharedInstance] checkIfNeedFecthImageWithZipParams:lastZipParams];
    }
    return self;
}

- (void)_setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [UIView newAutoLayoutView];
    view.backgroundColor = kDefaultSeparationLineLightColor;
    [self addSubview:view];
    [view autoSetDimensionsToSize:CGSizeMake(SCR_WIDTH, 0.5)];
    [view autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    
    NSArray *nameArray = [[MDTabBarManager sharedInstance] tabbarNameArray];
    for (NSInteger i = 0; i < _imageArray.count; i++) {
        // 创建button，实现点击。
        MDTabBarButton *button = ({
            
            MDTabBarButton *button = [MDTabBarButton buttonWithType:UIButtonTypeCustom];
            button.height = kTabBarHeight;
            button.tag = i+20;
            [button addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventTouchDown];
            
            button;
        });
        
        // 创建图片
        UIImageView *imageView = ({
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i+30;
            UIImage *image = nil;
            if ([MDTabBarManager sharedInstance].isDuringActive) {
                NSData *imageData = [NSData dataWithContentsOfFile:_imageArray[i]];
                image = [UIImage sd_animatedGIFWithData:imageData];
            }
            else {
                image = IMAGE(_imageArray[i]);
            }
            imageView.image = image;
            
            CGRect frame = imageView.frame;
            
            if ([MDTabBarManager sharedInstance].isDuringActive) {
                // 2017.8.30 版本 UI 要把 icon 加宽 （w:44）
                frame.size.height = 44.f * (image.size.height/image.size.width);
                frame.size.width = 44.f;
            }
            else {
                frame.size.height = image ? kOriginImageViewW*(image.size.height/image.size.width) : kOriginImageViewW;
                frame.size.width = kOriginImageViewW;
            }
            
            frame.origin.y = kOriginImageViewY+kOriginImageViewW-frame.size.height;
            imageView.frame = frame;
            
            //            CGPoint center = imageView.center;
            //            center.x = SCR_WIDTH/_imageArray.count/2.f;
            //            imageView.center = center;
            imageView.centerX = SCR_WIDTH/_imageArray.count/2.f;
            
            imageView;
        });
        
        // 创建名字label
        UILabel *nameLabel = ({
            
            UILabel *label = [[UILabel alloc] init];
            label.text = nameArray[i];
            label.font = FONT_SYSTEM_NORMAL(kNameFont);
            label.textColor = kDefaultTitleColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = i+40;
            
            CGRect frame = label.frame;
            frame.size.height = kOriginNameLabelH;
            frame.size.width = SCR_WIDTH/nameArray.count;
            frame.origin.y = kOriginNameLabelY;
            label.frame = frame;
            
            CGPoint center = label.center;
            center.x = SCR_WIDTH/_imageArray.count/2.f;
            label.center = center;
            
            label;
        });
        
        // 创建角标
        MDTabBarLabel *tipsLabel = ({
            
            MDTabBarLabel *label = [[MDTabBarLabel alloc] init];
            label.tag = (self.subviews.count/2) + 10;
            label.backgroundColor = [UIColor redColor];
            label.textColor = COLOR_WITH_WHITE;
            label.font = FONT_SYSTEM_NORMAL(13);
            label.adjustsFontSizeToFitWidth = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.masksToBounds = YES;
            label;
        });
        
        [self addSubview:button];
        [self addSubview:tipsLabel];
        [button addSubview:imageView];
        [button addSubview:nameLabel];
        
        if (i == 0) {
            [self _buttonAction:button];
        }
    }
    
}

- (void)_setupUpdateBlock
{
    MDWeakPtr(weakPtr, self);
    MDWeakPtr(weakManager, [MDTabBarManager sharedInstance]);
    [MDTabBarManager sharedInstance].tabBarFetchSuccessBlock = ^(){
        weakPtr.imageArray = [weakManager tabbarImageNameArray];
        weakPtr.selImageArray = [weakManager tabbarHighLightImageArray];
        
        for (int i = 0; i < weakPtr.imageArray.count; i++) {
            MDTabBarButton *button = [weakPtr viewWithTag:i+20];
            UIImageView *imageView = [button viewWithTag:i+30];
            UIImage *image = nil;
            if (weakManager.isDuringActive) {
                if (button.isSelected) {
                    NSData *imageData = [NSData dataWithContentsOfFile:weakPtr.selImageArray[i]];
                    image = [UIImage sd_animatedGIFWithData:imageData];
                }
                else {
                    NSData *imageData = [NSData dataWithContentsOfFile:weakPtr.imageArray[i]];
                    image = [UIImage sd_animatedGIFWithData:imageData];
                }
                // 2017.8.30 版本 UI 要把 icon 加宽 （w:44）
                imageView.height = image ? 44.f*(image.size.height/image.size.width) : kOriginImageViewW;
                imageView.width = 44.f;
            }
            else {
                if (button.isSelected) {
                    image = IMAGE(weakPtr.selImageArray[i]);
                }
                else {
                    image = IMAGE(weakPtr.imageArray[i]);
                }
                imageView.height = image ? kOriginImageViewW*(image.size.height/image.size.width) : kOriginImageViewW;
                imageView.width = kOriginImageViewW;
            }
            imageView.image = image;
            imageView.y = kOriginImageViewY+kOriginImageViewW-imageView.height;
            imageView.centerX = SCR_WIDTH/self->_imageArray.count/2.f;
        }
    };
}

- (void)_buttonAction:(MDTabBarButton *)button
{
    NSInteger from = self.selectedButton.tag-20;
    NSInteger to = button.tag-20;
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectFrom:to:)]) {
        [self.delegate tabBar:self didSelectFrom:from to:to];
    }
    
    _selectedIndex = to;
    
    if (from >= 0 || from < _imageArray.count) {
        UILabel *nameLabel = [_selectedButton viewWithTag:from+40];
        UIImageView *imageView = [_selectedButton viewWithTag:from+30];
        nameLabel.textColor = kDefaultTitleColor;
        if ([MDTabBarManager sharedInstance].isDuringActive) {
            NSData *imageData = [NSData dataWithContentsOfFile:_imageArray[from]];
            UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
            imageView.image = image;
            // 2017.8.30 版本 UI 要把 icon 加宽 （w:44）
            //imageView.height = kOriginImageViewW*(image.size.height/image.size.width);
            imageView.height = 44.f*(image.size.height/image.size.width);
            imageView.width = 44.f;
        }
        else {
            imageView.image = IMAGE(_imageArray[from]);
            imageView.height = kOriginImageViewW;
            imageView.width = kOriginImageViewW;
        }
        imageView.y = kOriginImageViewY+kOriginImageViewW-imageView.height;
        imageView.centerX = SCR_WIDTH/_imageArray.count/2.f;
    }
    
    if (to >= 0 && to < _imageArray.count) {
        UILabel *nameLabelSel = [button viewWithTag:to+40];
        UIImageView *imageViewSel = [button viewWithTag:to+30];
        nameLabelSel.textColor = RED;
        if ([MDTabBarManager sharedInstance].isDuringActive) {
            NSData *imageData = [NSData dataWithContentsOfFile:_selImageArray[to]];
            UIImage *image = [UIImage sd_animatedGIFWithData:imageData];
            imageViewSel.image = image;
            // 2017.8.30 版本 UI 要把 icon 加宽 （w:44）
            //imageViewSel.height = kOriginImageViewW*(image.size.height/image.size.width);
            imageViewSel.height = 44.f*(image.size.height/image.size.width);
            imageViewSel.width = 44.f;
        }
        else {
            imageViewSel.image = IMAGE(_selImageArray[to]);
            imageViewSel.height = kOriginImageViewW;
            imageViewSel.width = kOriginImageViewW;
        }
        imageViewSel.y = kOriginImageViewY+kOriginImageViewW-imageViewSel.height;
        imageViewSel.centerX = SCR_WIDTH/_imageArray.count/2.f;
    }
    
    // 1.让当前选中的按钮取消选中
    self.selectedButton.selected = NO;
    
    // 2.让新点击的按钮选中
    button.selected = YES;
    
    // 3.新点击的按钮就成为了"当前选中的按钮"
    self.selectedButton = button;
}

#pragma mark - 外部接口
- (void)setBadge:(NSString *)badge atIndex:(NSInteger)index
{
    if (index >= _imageArray.count) {
        return;
    }
    MDTabBarLabel *label = [self viewWithTag:index+10];
    label.hidden = stringIsEmpty(badge);
    [label setText:badge index:index style:MDTabBarStyleNumber];
}

- (void)setPointBadgeHidden:(BOOL)hidden atIndex:(NSInteger)index
{
    if (index >= _imageArray.count) {
        return;
    }
    MDTabBarLabel *label = [self viewWithTag:index+10];
    label.hidden = hidden;
    [label setText:nil index:index style:MDTabBarStyleCircle];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex == _selectedIndex) return;
    _selectedIndex = selectedIndex;
    MDTabBarButton *button = [self viewWithTag:selectedIndex+20];
    [self _buttonAction:button];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < _imageArray.count; i++) {
        MDTabBarButton *button = [self viewWithTag:i+20];
        CGRect frame = button.frame;
        // 设置frame
        CGFloat buttonW = SCR_WIDTH/_imageArray.count;
        CGFloat buttonX = i*buttonW;
        frame.origin.x = buttonX;
        frame.size.width = buttonW;
        button.frame = frame;
    }
}

@end
