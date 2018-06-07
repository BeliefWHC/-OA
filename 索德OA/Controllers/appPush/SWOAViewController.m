//
//  SWOAViewController.m
//  索德OA
//
//  Created by sw on 18/6/5.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "SWOAViewController.h"
#import <WebKit/WebKit.h>
#import "WKProcessPool+SharedProcessPool.h"

@interface SWOAViewController ()
@property (strong,nonatomic)WKWebView *wkweb;

@end

@implementation SWOAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpOAweb];
}
-(void)setUpOAweb{
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@bpmx/weixin/index.html",BPMX_LOCAL]];
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        
        [cookieDic setObject:cookie.value forKey:cookie.name];
        
    }
    
    
    
    // cookie重复，先放到字典进行去重，再进行拼接
    NSString *JSESSIONID;
    for (NSString *key in cookieDic) {
        
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        
        [cookieValue appendString:appendString];
        if ([key isEqualToString:@"JSESSIONID"]) {
            JSESSIONID = [cookieDic valueForKey:key];
        }
        
    }
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url];
    [cookieValue deleteCharactersInRange:NSMakeRange(cookieValue.length - 1, 1)];

    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController* userContent = [[WKUserContentController alloc] init];
    WKUserScript *scrip = [[WKUserScript alloc]initWithSource:[NSString stringWithFormat:@"document.cookie ='loginAction=weixin;document.cookie = 'JSESSIONID=%@';'",JSESSIONID] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContent addUserScript:scrip];
    config.userContentController = userContent;
//    config.processPool = [WKProcessPool sharedProcessPool];
    self.wkweb = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];

//   char k =  'A';
//    char free[] = "ADDDDDfgfgfgAdfdfAsdfdsfA";
//    for (int i=0; i < strlen(free); i++) {
//        if (free[i] == k&&) {
//            
//        }
//    }
    

    
  
    [self.wkweb loadRequest:request];

    [self.view addSubview:self.wkweb];

}
///bpmx/weixin/
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

@end
