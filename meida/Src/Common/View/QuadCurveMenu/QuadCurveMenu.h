//
//  QuadCurveMenu.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuadCurveMenuItem.h"


@protocol QuadCurveMenuDelegate;

//defult type is like this
/*       O
 *          O
 *             O
 *               O
 *
 *       0        O
 */
typedef enum
{
    QuadCurveMenuTypeUpAndRight = 0,
    QuadCurveMenuTypeUpAndLeft,
    QuadCurveMenuTypeDownAndRight,
    QuadCurveMenuTypeDownAndLeft,
    QuadCurveMenuTypeUp,
    QuadCurveMenuTypeDown,
    QuadCurveMenuTypeLeft,
    QuadCurveMenuTypeRight,
    QuadCurveMenuTypeDefault = QuadCurveMenuTypeUpAndRight
} QuadCureMenuType;

@interface QuadCurveMenu : UIView

@property (nonatomic, weak) id <QuadCurveMenuDelegate>delegate;

@property (nonatomic, strong) NSArray *menusArray;
@property (nonatomic, assign) BOOL expanding;
@property (nonatomic, assign) QuadCureMenuType type;


- (instancetype)initWithFrame:(CGRect)frame menus:(NSArray *)aMenusArray;

- (void)setType:(QuadCureMenuType)type;

- (void)setStartPoint:(CGPoint)startpoint;

@end


@protocol QuadCurveMenuDelegate <NSObject>

//点击 + 号按钮时执行
- (void)quadCurveMenuDidClickAddButton:(QuadCurveMenu *)menu;

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)index;

@end
