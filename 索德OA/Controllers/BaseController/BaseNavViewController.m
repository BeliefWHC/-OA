//
//  BaseNavViewController.m
//  索德OA
//
//  Created by sw on 18/5/18.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "BaseNavViewController.h"
#import "UIColor+RCColor.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviBarColaor];
    
   
}

-(void)setNaviBarColaor{
    [self.navigationBar setBarTintColor:[UIColor colorWithHexString:@"0099ff" alpha:1.0f]];
    UIFont *font = [UIFont systemFontOfSize:19.f];
    NSDictionary *textAttributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationBar setTitleTextAttributes:textAttributes];

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
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count==1) {
        viewController.hidesBottomBarWhenPushed = YES; //viewController是将要被push的控制器
    }
    [super pushViewController:viewController animated:animated];
}
@end
