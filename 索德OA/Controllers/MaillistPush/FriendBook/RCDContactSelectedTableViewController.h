//
//  RCDContactSelectedTableViewController.h
//  RCloudMessage
//
//  Created by Jue on 16/3/17.
//  Copyright © 2016年 RongCloud. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import <UIKit/UIKit.h>

@interface RCDContactSelectedTableViewController
    : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) NSArray *keys;

@property(nonatomic, strong) NSMutableDictionary *allFriends;

@property(nonatomic, strong) NSArray *allKeys;

@property(nonatomic, strong) NSString *titleStr;

@property(nonatomic, strong) NSMutableArray *addGroupMembers;

@property(nonatomic, strong) NSMutableArray *delGroupMembers;

@property(nonatomic, strong) NSString *groupId;

@property(nonatomic, assign) BOOL forCreatingGroup;

@property(nonatomic, assign) BOOL forCreatingDiscussionGroup;

@property(nonatomic, strong) NSMutableArray *addDiscussionGroupMembers;//添加成员

@property(nonatomic, strong) NSString *discussiongroupId;

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) void (^selectUserList)(NSArray<RCUserInfo *> *selectedUserList);

@property BOOL isAllowsMultipleSelection;//是否多选或者单聊

@property BOOL isHideSelectedIcon;

@end
