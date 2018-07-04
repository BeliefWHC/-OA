//
//  MessageViewController.m
//  索德OA
//
//  Created by sw on 18/5/15.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "MessageViewController.h"
#import "SwordUIBarButtonItem.h"
#import "RCDContactSelectedTableViewController.h"
#import "KxMenu.h"
#import "SWChatViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加获取新列表通知
    [self addAnyNotifyCenter];
    [self titleUpdate];
}
//注册通知

-(void)titleUpdate{
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"消息";
    self.navigationItem.title = @"消息";
    self.conversationListTableView.tableFooterView = [[UIView alloc]init];
    SwordUIBarButtonItem *rightBtn = [[SwordUIBarButtonItem alloc] initContainImage:[UIImage imageNamed:@"add"]
                                                                 imageViewFrame:CGRectMake(0, 0, 17, 17)
                                                                    buttonTitle:nil
                                                                     titleColor:nil
                                                                     titleFrame:CGRectZero
                                                                    buttonFrame:CGRectMake(0, 0, 17, 17)
                                                                         target:self
                                                                         action:@selector(showMenu:)];
    self.navigationItem.rightBarButtonItems = @[rightBtn];
    
}
/**
 *  弹出层
 *
 *  @param sender sender description
 */
- (void)showMenu:(UIButton *)sender {
    NSArray *menuItems = @[
                           
                           [KxMenuItem menuItem:@"发起聊天"
                                          image:[UIImage imageNamed:@"startchat_icon"]
                                         target:self
                                         action:@selector(pushChat:)],
                           
                           [KxMenuItem menuItem:@"创建群组"
                                          image:[UIImage imageNamed:@"creategroup_icon"]
                                         target:self
                                         action:@selector(pushContactSelected:)],
                     
#if RCDDebugTestFunction
                           [KxMenuItem menuItem:@"创建讨论组"
                                          image:[UIImage imageNamed:@"addfriend_icon"]
                                         target:self
                                         action:@selector(pushToCreateDiscussion:)],
#endif
                           ];
    
    UIBarButtonItem *rightBarButton = self.navigationItem.rightBarButtonItems[0];
    CGRect targetFrame = rightBarButton.customView.frame;
    CGFloat offset = [UIApplication sharedApplication].statusBarFrame.size.height > 20 ?  54 : 15;
    targetFrame.origin.y = targetFrame.origin.y + offset;
    if (IOS_FSystenVersion >= 11.0) {
        targetFrame.origin.x = self.view.bounds.size.width - targetFrame.size.width - 17;
    }
    [KxMenu setTintColor:HEXCOLOR(0x000000)];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:17]];
    [KxMenu showMenuInView:self.navigationController.navigationBar.superview
                  fromRect:targetFrame
                 menuItems:menuItems];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//发起聊天
-(void)pushChat :(id)sender{
    //发起单聊
    RCDContactSelectedTableViewController *contactSelectedVC = [[RCDContactSelectedTableViewController alloc] init];
//        contactSelectedVC.forCreatingDiscussionGroup = YES;
    contactSelectedVC.isAllowsMultipleSelection = NO;
    contactSelectedVC.titleStr = @"发起聊天";
    [self.navigationController pushViewController:contactSelectedVC animated:YES];
 
    
}
//创建群组聊天
-(void)pushContactSelected:(id)sender{
 
    RCDContactSelectedTableViewController *contactSelectedVC = [[RCDContactSelectedTableViewController alloc] init];
    contactSelectedVC.forCreatingGroup = YES;
    contactSelectedVC.isAllowsMultipleSelection = YES;
    contactSelectedVC.titleStr = @"选择联系人";
    [self.navigationController pushViewController:contactSelectedVC animated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (id)init {
    self = [super init];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[
                                            @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE),
                                            @(ConversationType_PUBLICSERVICE), @(ConversationType_GROUP)
                                            ]];
        
      
    }
    //聚合会话类型
    [self setCollectionConversationType:@[ @(ConversationType_SYSTEM) ]];
    return self;
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath

{
    SWChatViewController *rCC = [[SWChatViewController alloc]init];
    
    rCC.conversationType = model.conversationType;
    rCC.targetId = model.targetId;
    rCC.title = model.conversationTitle;

    [self.navigationController pushViewController:rCC animated:YES];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma maek 注册通知
-(void)addAnyNotifyCenter{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatelist) name:SEND_GET_FRIEND_LIST_SUCCESS object:nil];
    
}
-(void)updatelist{
    [self refreshConversationTableViewIfNeeded];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEND_GET_FRIEND_LIST_SUCCESS object:nil];

}

@end
