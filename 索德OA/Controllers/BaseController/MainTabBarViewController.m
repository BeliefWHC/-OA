//
//  MainTabBarViewController.m
//  索德OA
//
//  Created by sw on 18/5/15.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "AFHttpTool.h"
#import "RCDataBaseManager.h"
#import "RCDUserInfo.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

@interface MainTabBarViewController ()
{
    MBProgressHUD *hud;
}

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //这里出现的话第一次加载  然后下载通讯录  如果有 则不加载
        [self getFriendList];

    self.tabBar.translucent = NO;
    
}
-(void)getFriendList{
///获取最新的通讯录
    //如果存在这个登录用户的key 就需要重新下载通讯录
    if ([DEFAULTS objectForKey:APPFIRSTLOGIN]) {
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
    NSString *path = [NSBundle mainBundle].bundlePath;
    NSDictionary *dic = @{@"page":@"1",@"pageSize":@"1000"};
    NSString *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

    
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BPMX_LOCAL,BPMX,FRIEN_LIST_URL];
    
    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:url params:dic success:^(id response) {
        
        
        if (response[@"list"]) {
  
            
           
            //第一次获取到 然后存入数据库
            [DEFAULTS setObject:[NSString stringWithFormat:@"friend%@",[RCIMClient sharedRCIMClient].currentUserInfo.userId ]forKey:APPFIRSTLOGIN];
            NSString * timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
            [DEFAULTS setObject:timestamp forKey:FRIEND_LIST_UPTATE_TIME];
            [DEFAULTS synchronize];
            
            NSMutableArray *user = [RCDUserInfo mj_objectArrayWithKeyValuesArray:response[@"list"]];
            
            //发送通知  通讯录获取成功
            [[RCDataBaseManager shareInstance] insertFriendListToDB:user complete:^(BOOL result) {
                
                
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [SVProgressHUD showInfoWithStatus:@"信息获取成功"];
             
            });
            
            
            
            
        }
        
    } failure:^(NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showInfoWithStatus:@"信息获取失败，在通讯录刷新获取"];

            [hud hide:YES];
        });
        
    }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
///

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
