//
//  RCDUserInfo.m
//  RCloudMessage
//
//  Created by 杜立召 on 15/3/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDUserInfo.h"
#import "MJExtension.h"

@implementation RCDUserInfo

@synthesize name;



+ (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"userId":@"account",@"name":@"fullname",@"portraitUri":@"picture"};
    
}
@end
