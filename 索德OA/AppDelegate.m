//
//  AppDelegate.m
//  索德OA
//
//  Created by sw on 18/5/14.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFHttpTool.h"
#import "AFNetworking.h"
#import "BaseNavViewController.h"
#import "RCDataBaseManager.h"
#import "SVProgressHUD.h"
#import "SwRYIMFriendInfo.h"

@interface AppDelegate ()<RCIMUserInfoDataSource>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    LoginViewController *loginController = [[LoginViewController alloc]init];
    self.window.rootViewController = loginController;
    [self.window makeKeyAndVisible];
    
    
    
    //判断是否第一次登陆
   
    
  
 
    
    //设置用户信息源和群组信息源
//    [RCIM sharedRCIM].userInfoDataSource = self;
    
    [SwRYIMFriendInfo shared];
    ///融云测试
    return YES;
}

/**
 <#Description#>

 @param userId <#userId description#>
 @param completion <#completion description#>
 */

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
