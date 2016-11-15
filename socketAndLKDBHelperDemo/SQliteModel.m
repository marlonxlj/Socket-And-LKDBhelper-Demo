//
//  SQliteModel.m
//  socketAndLKDBHelperDemo
//
//  Created by m on 2016/11/15.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "SQliteModel.h"

@implementation ptInfo


@end

@implementation SQliteModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"userID":@"id",@"ptInfo":@"info"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"info":[ptInfo class]};
}

/**
 *
 *  @return 是否将父实体类的属性也映射到SQLITE库中
 */
+ (BOOL)isContainParent
{
    return YES;
}

/**
 * 设置数据库的表名，在查询的时候可以根据表名来查询
 * 我在使用的时候不知道为什么不成功。总是提示sqlite语法错误
 */
+ (NSString *)getTableName
{
    return @"SQLiteModel";
}

/**
 * 设置表的单个主键
 */
+ (NSString *)getPrimaryKey
{
    return @"userID";
}


@end
