//
//  SwRYIMFriendInfo.m
//  索德OA
//
//  Created by sw on 18/6/4.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "SwRYIMFriendInfo.h"
#import "RCDUserInfo.h"
#import "RCDataBaseManager.h"

static SwRYIMFriendInfo *swFriendInfo = nil;

@interface SwRYIMFriendInfo ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@end
@implementation SwRYIMFriendInfo

+(SwRYIMFriendInfo *)shared{


    if (swFriendInfo== nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{

            swFriendInfo = [[[self class] alloc] init];
        });
    }
    
    
    return swFriendInfo;
}
//重写构建方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        [RCIM sharedRCIM].userInfoDataSource = self;
        [RCIM sharedRCIM].groupInfoDataSource = self;
    }
    return self;
}


-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{

    
    
    if (userId ==  nil) {
        return;
    }
    
    
    RCDUserInfo *user = [[RCDataBaseManager shareInstance] getUserByUserId:userId];
    
    user.portraitUri = [NSString stringWithFormat:@"%@%@%@",BPMX_LOCAL,BPMX,user.portraitUri ];
    completion(user);
}
-(void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
{
//获取群信息 第一种方案在线取  第二种方案数据库取 初次加载的时候吧所有群组获取出来
    
    RCGroup *group = [[RCGroup alloc]initWithGroupId:groupId groupName:@"测试" portraitUri:@"https://b-ssl.duitang.com/uploads/item/201409/14/20140914161215_wWW2S.jpeg"];
    [[RCDataBaseManager shareInstance] getGroupByGroupId:@""];
    completion(group);
    
    
}
@end
