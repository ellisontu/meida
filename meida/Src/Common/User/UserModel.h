//
//  UserModel.h
//  meida
//
//  Created by ToTo on 2018/6/24.
//  Copyright © 2018年 ymfashion. All rights reserved.
//

#import "BaseModel.h"

#define md_MALE 1
#define MD_FEMALE 2
#define MD_UNKNOWN 0
//1qq2微信3sina微博
typedef NS_ENUM(NSInteger, MDSourceType) {
    SourceTypeQQ = 1,
    SourceTypeWeChat,
    SourceTypeSina
};


@interface UserModel : BaseModel

@property (nonatomic, strong) NSString      *uid;           /**< userId */
@property (nonatomic, strong) NSString      *nick;          /**< 昵称 */
@property (nonatomic, assign) NSInteger     sex;            /**< 性别 1:男性 2:女性 3:未知 */
@property (nonatomic, strong) NSString      *password;      /**< 密码 */
@property (nonatomic, strong) NSString      *phone;         /**< 手机号 */

@property (nonatomic, strong) NSString      *longitude;     /**< 经度 */
@property (nonatomic, strong) NSString      *latitude;      /**< 纬度 */

+ (NSMutableArray *)decodeJsonArray:(id)json;

- (BOOL)isPhoneBinded;

@end
