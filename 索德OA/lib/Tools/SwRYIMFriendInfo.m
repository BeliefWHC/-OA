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

@interface SwRYIMFriendInfo ()<RCIMUserInfoDataSource>

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
@end
