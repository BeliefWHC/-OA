//
//  SWChatViewController.m
//  索德OA
//
//  Created by sw on 18/6/11.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "SWChatViewController.h"
#import "RCDUIBarButtonItem.h"
#import "RCDGroupSettingsTableViewController.h"
#import "RCDHttpTool.h"

@interface SWChatViewController ()

@end

@implementation SWChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //重新加载返回按钮
    UIBarButtonItem *backButon =
    [[UIBarButtonItem alloc]initWithTitle:@"返回"  style:UIBarButtonItemStylePlain target:self action:@selector(backNew)];
    self.navigationItem.leftBarButtonItem = backButon;
    
    if (self.conversationType == ConversationType_GROUP) {
        [self setRightNavigationItem:[UIImage imageNamed:@"Group_icon"] withFrame:CGRectMake(0,0, 21, 19.5)];
    } else {
        [self setRightNavigationItem:[UIImage imageNamed:@"private"]
                           withFrame:CGRectMake(0, 0, 16, 18.5)];
    }

    
}
- (void)setRightNavigationItem:(UIImage *)image withFrame:(CGRect)frame {
    RCDUIBarButtonItem *rightBtn = [[RCDUIBarButtonItem alloc] initContainImage:image imageViewFrame:frame buttonTitle:nil
                                                                     titleColor:nil
                                                                     titleFrame:CGRectZero
                                                                    buttonFrame:frame
                                                                         target:self
                                                                         action:@selector(rightBarButtonItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
-(void)rightBarButtonItemClicked :(id)sender{
    //判断对话类型是 群组还是单聊
    if (self.conversationType == ConversationType_GROUP) {
        //如果是群组打开群组详细信息
        
        RCDGroupSettingsTableViewController *settingsVC =
        [RCDGroupSettingsTableViewController groupSettingsTableViewController];
        __block SWChatViewController *controller = self;
        [[RCDHttpTool shareInstance] getGroupByID:self.targetId successCompletion:^(RCDGroupInfo *group) {
            settingsVC.Group = group;
            
            [controller.navigationController pushViewController:settingsVC animated:YES];
        }];
        
        
    }
    else if(self.conversationType == ConversationType_PRIVATE){

    }

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
-(void)backNew{
    if (_needPopToRootView == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
        [super leftBarButtonItemPressed:nil];
    }
}

@end
