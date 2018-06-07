//
//  RaTreeModel.h
//  索德OA
//
//  Created by sw on 18/5/30.
//  Copyright © 2018年 sw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaTreeModel : NSObject

@property (nonatomic,copy) NSString *orgName;//标题

@property (nonatomic,strong) NSMutableArray *childOrgs;//子节点数组

@property (nonatomic,strong)NSString *orgId;
//初始化一个model
- (id)initWithName:(NSString *)name children:(NSArray *)array;

//遍历构造器
+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children;

@end


