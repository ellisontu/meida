//
//  CustomPageControl.m
//  meida
//
//  Created by ToTo on 2018/7/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "CustomPageControl.h"

@interface CustomPageControl ()

@property (nonatomic) CGSize itemSize;

@end

@implementation CustomPageControl

-(instancetype)initWithFrame:(CGRect)frame currentImage:(UIImage *)currentImage defaultImage:(UIImage *)defaultImage
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.currentImage = currentImage;
        self.defaultImage = defaultImage;
    }
    return self;
}
-(void) setItemPoints
{
    if (self.currentImage && self.defaultImage){
        self.itemSize = self.currentImage.size;
    }
    else{
        self.itemSize = CGSizeMake(8, 3.5);
    }
    
    if (self.pageSize.height && self.pageSize.width) {
        self.itemSize =self.pageSize;
    }
    for (int i=0; i<[self.subviews count]; i++) {
        UIView* item = [self.subviews objectAtIndex:i];
        item.frame = CGRectMake(item.frame.origin.x, item.frame.origin.y, self.itemSize.width, self.itemSize.height);
        if ([item.subviews count] == 0){
            UIImageView * view = [[UIImageView alloc]initWithFrame:item.bounds];
            view.contentMode = UIViewContentModeScaleAspectFit;
            [item addSubview:view];
        };
        
        UIImageView * view = item.subviews[0];
        if (i==self.currentPage){
            if (self.currentImage){
                view.image=self.currentImage;
                item.backgroundColor = [UIColor clearColor];
            }
            else{
                view.image = nil;
                item.backgroundColor = self.currentPageIndicatorTintColor;
            }
        }
        else if (self.defaultImage){
            view.image=self.defaultImage;
            item.backgroundColor = [UIColor clearColor];
        }
        else{
            view.image = nil;
            item.backgroundColor = self.pageIndicatorTintColor;
        }
    }
}
-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self setItemPoints];
}

@end

