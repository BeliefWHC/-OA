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
#import "RCDHttpTool.h"

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
//获取群信息 第一种方案在线取  第二种方案数据库取 初次加载的时候吧所有群组获取出来  减少内存全部外部拿取
    
    //开发者调自己的服务器接口根据userID异步请求数据
    if ([groupId integerValue] > 0) {
        [RCDHTTPTOOL getGroupByID:groupId
                successCompletion:^(RCDGroupInfo *group) {
                                    completion(group);
                }];
    }
 

    
    
}
@end
