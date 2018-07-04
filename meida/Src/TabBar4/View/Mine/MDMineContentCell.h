//
//  MDMineContentCell.h
//  meida
//
//  Created by ToTo on 2018/7/3.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -  我的 -> tableView headView -> user info view #############################################----------
@interface MDMineContentHeadView : UIView

@end

#pragma mark -  我的 -> tableView cell -> user info view #############################################----------
@interface MDMineContentCommonCell : UITableViewCell

@property (nonatomic, strong) NSDictionary      *infoDict;  /**< 标题和type */

@end
