//
//  SQliteModel.h
//  socketAndLKDBHelperDemo
//
//  Created by m on 2016/11/15.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import <LKDBHelper.h>

@interface ptInfo : NSObject <YYModel>

/**发送者名字*/
@property (nonatomic, copy) NSString *sendName;
/**发送头像*/
@property (nonatomic, copy) NSString *headUrl;

@end

@interface SQliteModel : NSObject <YYModel>
/**用户ID*/
@property (nonatomic, copy) NSString *userID;
/**当前时间*/
@property (nonatomic, copy) NSString *ptime;
/**用户名字*/
@property (nonatomic, copy) NSString *userName;
/**联系方法*/
@property (nonatomic, copy) NSString *userPhone;

@property (nonatomic, strong) ptInfo *info;

@end
