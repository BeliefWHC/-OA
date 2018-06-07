//
//  MessageViewController.m
//  索德OA
//
//  Created by sw on 18/5/15.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self titleUpdate];
}
-(void)titleUpdate{
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"消息";
    self.navigationItem.title = @"消息";
    self.conversationListTableView.tableFooterView = [[UIView alloc]init];
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
- (id)init {
    self = [super init];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[
                                            @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION)
                                        , @(ConversationType_GROUP)
                                            ]];
        
      
    }
    return self;
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath

{
    RCConversationViewController *rCC = [[RCConversationViewController alloc]init];
    
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

@end
