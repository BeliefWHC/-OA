//
//  LoginViewController.m
//  索德OA
//
//  Created by sw on 18/5/14.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "MessageViewController.h"
#import "ApplicationViewController.h"
#import "ViewController1.h"
#import "MailListViewController.h"
#import "ManagementViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFHttpTool.h"
#import "AFNetworking.h"
#import "BaseNavViewController.h"
#import "MBProgressHUD.h"
#import "RCDataBaseManager.h"

@interface LoginViewController ()
{
    MBProgressHUD *hud;
}

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *rememberLoginBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateView];
    //添加键盘监听事件
//    [self addKeyObserver];

}

-(void)updateView{

    self.loginBtn.layer.cornerRadius = 15;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)loginAction:(id)sender {
    
    if (self.nameText.text.length  == 0 || self.passwordText.text.length == 0) {
        
        [self showAlerTitle:@"登陆错误" Message:@"请确定登录信息"];
        
        return;
    }
    RCNetworkStatus status = [[RCIMClient sharedRCIMClient] getCurrentNetworkStatus];
//判断连接网络
    if (RC_NotReachable == status){
        [self showAlerTitle:@"提示" Message:@"网络连接错误"];
        return;

    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中...";
    [hud show:YES];
    [self getIMToken];

    
    
   

    
    //
}
//登录 成功后

-(void)sucssesLogining{

    [hud hide:YES];
    
    MainTabBarViewController *main = [[MainTabBarViewController alloc]init];
    //加载viewController
    MessageViewController  *messageViewController = [[MessageViewController alloc]init];
    ApplicationViewController *applicationViewController = [[ApplicationViewController alloc]init];
    ViewController1 *v = [[ViewController1 alloc]init];
    MailListViewController *mailListViewController = [[MailListViewController alloc]init];
    ManagementViewController *managementViewController = [[ManagementViewController alloc]init];
    messageViewController.tabBarItem.image = [[UIImage imageNamed:@"gongzuo"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"gongzuo-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    applicationViewController.tabBarItem.image = [[UIImage imageNamed:@"modulecenter"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    applicationViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"modulecenterhot"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    v.tabBarItem.image = [[UIImage imageNamed:@"discovercenter"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    v.tabBarItem.selectedImage = [[UIImage imageNamed:@"discovercenterhot"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mailListViewController.tabBarItem.image = [[UIImage imageNamed:@"tongxunlu"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mailListViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tongxunlu-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    managementViewController.tabBarItem.image = [[UIImage imageNamed:@"mecenter"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    managementViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"mecenterhot"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    //设置title
    
    messageViewController.title = @"消息";
    applicationViewController.title = @"应用";
    v.title = @"微门户";
    mailListViewController.title = @"通讯录";
    managementViewController.title = @"我";
    //装载导航
    BaseNavViewController *messageViewControllerNav = [[BaseNavViewController alloc]initWithRootViewController:messageViewController];
     BaseNavViewController *applicationViewControllerNav = [[BaseNavViewController alloc]initWithRootViewController:applicationViewController];
     BaseNavViewController *vNav = [[BaseNavViewController alloc]initWithRootViewController:v];
     BaseNavViewController *mailListViewControllerNav = [[BaseNavViewController alloc]initWithRootViewController:mailListViewController];
     BaseNavViewController *managementViewControllerNav = [[BaseNavViewController alloc]initWithRootViewController:managementViewController];
    main.viewControllers = @[messageViewControllerNav,applicationViewControllerNav,vNav,mailListViewControllerNav,managementViewControllerNav];
    
    [self.navigationController pushViewController:messageViewControllerNav animated:YES];
    
    [self presentViewController:main animated:YES completion:^{
        
    }];

}
- (IBAction)remeberLoginStatue:(id)sender {
    
    static int flag = 0;
    if (flag == 1) {
        [self.rememberLoginBtn setImage:[UIImage imageNamed:@"选择框"] forState:UIControlStateNormal];
        flag --;
    }else{
     [self.rememberLoginBtn setImage:[UIImage imageNamed:@"选择框后"] forState:UIControlStateNormal];
        flag++;
    }
    
    
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



//获取token 登录成功后
-(void)getIMToken {
    
    
    
    NSString *name = self.nameText.text;
    NSString*passWord = self.passwordText.text;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *urlstr =@"https://api.cn.rong.io/user/getToken.json";
    
    NSDictionary *dic =@{@"userId":name,
                         
                         @"name":@"大王八",
                         
                         @"portraitUri":@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg"
                         
                         };
    
    //这几句是按融云的提示写的
    
    NSString * timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
    
    NSString * nonce = [NSString stringWithFormat:@"%d",arc4random()];
    
    NSString * appkey = APP_KEY;
    
    NSString *SignatureWillMD5 = [NSString stringWithFormat:@"%@%@%@",appkey,nonce,timestamp];//这个要加密
    
    NSString *Signature = [self MD5String:SignatureWillMD5]; //MD5加密
    
    //以下拼接请求内容
    
    [manager.requestSerializer setValue:appkey forHTTPHeaderField:@"App-Key"];
    
    [manager.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    
    [manager.requestSerializer setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    
    [manager.requestSerializer setValue:Signature forHTTPHeaderField:@"Signature"];
    
    [manager.requestSerializer setValue:@"5Ipr5x9y7IfF" forHTTPHeaderField:@"appSecret"];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //开始请求
    
    [manager POST:urlstr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //这里你就能得到token啦~
        
        NSLog(@"%@", responseObject);
        NSString *token = responseObject[@"token"];
        //保存默认用户
        [DEFAULTS setObject:name forKey:@"userName"];
        [DEFAULTS setObject:passWord forKey:@"userPwd"];
        [DEFAULTS setObject:token forKey:@"userToken"];
        [DEFAULTS synchronize];

        [[RCIM sharedRCIM] initWithAppKey:APP_KEY];
        
        [[RCIM sharedRCIM] connectWithToken:token     success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            
            [RCDataBaseManager shareInstance];
            //加载数据
            
            [self ceshiLogin];
           
        } error:^(RCConnectErrorCode status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlerTitle:@"错误" Message:@"连接聊天服务器错误"];
                [hud hide:YES];
            });
            
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlerTitle:@"错误" Message:@"token错误"];
                [hud hide:YES];
            });
           
            NSLog(@"token错误");
        }];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
}

- (NSString *)MD5String:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    
    unsigned char result[16];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    NSString * md5Str = [NSString stringWithFormat:
                         
                         @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                         
                         result[0], result[1], result[2], result[3],
                         
                         result[4], result[5], result[6], result[7],
                         
                         result[8], result[9], result[10], result[11],
                         
                         result[12], result[13], result[14], result[15]
                         
                         ];
    
    
    return md5Str;
    
}

-(void)ceshiLogin{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dic =@{@"username":@"000470",
                         
                         @"password":@"000000"
                         
                
                         
                         };
   
    NSString *url = [NSString stringWithFormat:@"%@%@",BPMX_LOCAL,BPMX_LOGIN];

    
    [manager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        WLog(@"%@",responseObject);
        NSNumber * k = responseObject[@"result"];
        if (k.intValue == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 通知主线程刷新 神马的
                [self sucssesLogining];
                
            });
        }
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [self showAlerTitle:@"错误" Message:@"登录失败"];
        });
       
    }];


}

-(void)showAlerTitle :(NSString*)title Message:(NSString*)message{

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              NSLog(@"action = %@", action);
                                                          }];
   
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    

}

@end
