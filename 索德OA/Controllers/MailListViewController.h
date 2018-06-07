//
//  MailListViewController.h
//  索德OA
//
//  Created by sw on 18/5/15.
//  Copyright © 2018年 sw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDTableView.h"

@interface MailListViewController : UIViewController


@property(nonatomic, strong) UISearchBar *searchFriendsBar;
@property(nonatomic, strong) RCDTableView *friendsTabelView;

@property(nonatomic, strong) NSDictionary *allFriendSectionDic;

@property(nonatomic, strong) NSArray *seletedUsers;

@property(nonatomic, strong) NSString *titleStr;

@property(nonatomic, strong) void (^selectUserList)(NSArray<RCUserInfo *> *selectedUserList);

@end
