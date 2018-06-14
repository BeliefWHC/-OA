//
//  MailListViewController.m
//  索德OA
//
//  Created by sw on 18/5/15.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "MailListViewController.h"
#import "RCDTableView.h"
#import "RCDContactTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "RCDUserInfo.h"
#import "DefaultPortraitView.h"
#import "AFHttpTool.h"
#import "RCDUtilities.h"
#import "MJExtension.h"
#import "RCDataBaseManager.h"
#import "RCDPersonDetailViewController.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "RaTreeModel.h"
#import "RATreeView.h"
#import "TreeContactCell.h"
#import "DepartmentViewController.h"

#define TITLE_ITEM_HEIGHT 40.f

typedef enum {
    AllFriend = 0,//所有人
    SameDepartment,//同一部门
    SwordOrgernize,//组织
    FrequnetContact//常联系
} ItemChoose;
@interface MailListViewController ()<RATreeViewDelegate,RATreeViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *hud;
}
@property(strong, nonatomic) NSMutableArray *matchFriendList;
@property(strong, nonatomic) NSArray *defaultCellsTitle;
@property(strong, nonatomic) NSArray *defaultCellsPortrait;
@property(nonatomic, assign) BOOL hasSyncFriendList;
@property(nonatomic, assign) BOOL isBeginSearch;
@property(nonatomic, strong) NSMutableDictionary *resultDic;
@property (nonatomic,strong) NSMutableArray *treeModelArr;
@property (nonatomic,strong)RATreeView *treeView;
@end


@implementation MailListViewController

-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
 
  self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
    [self titleUpdate];
    [self setUpSearchBar];
    //上方的别类

    [self setUpTitleView];
//    [self setUpOrgernizeContactTreeTable];
    //注释掉 加载默认
    [self setUpView];
    // initial data
    
    //测试


}
//设置条目栏目  同部门 组织 常用组 所有
-(void)setUpTitleView{
    
    CGRect searchBarFrame = self.searchFriendsBar.frame;
    CGFloat originY = CGRectGetMaxY(searchBarFrame);
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    WLog(@"status width - %f", rectStatus.size.width); // 宽度
    WLog(@"status height - %f", rectStatus.size.height); // 高度
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame ;
    WLog(@"nav width - %f", rectNav.size.width); // 宽度
    WLog(@"nav height - %f", rectNav.size.height); // 高度
    
    
    CGFloat top = originY;
    //每个Item宽高
    CGFloat W = SELF_VIEW_WIDTH/2;
    CGFloat H = TITLE_ITEM_HEIGHT;
    //每行列数
    NSInteger rank = 2;
    //每列间距
    CGFloat rankMargin = 1;
    //每行间距
    CGFloat rowMargin = 1;
    //Item索引 ->根据需求改变索引
    NSUInteger index = 4;
    NSArray *titleArr = @[@"所有人",@"同部门",@"组织",@"我的群组"];
    NSArray *titleImageArr = @[@"mecenterhot",@"mecenterhot",@"mecenterhot",@"mecenterhot"];
    //TIANt添加手势
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        UIView *speedView = [[UIView alloc] init];
        speedView.frame = CGRectMake(X, Y+top, W, H);
       
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 26, 26)];
        titleImage.image = [UIImage imageNamed:titleImageArr[i]];
        [speedView addSubview:titleImage];
        UILabel *itemTile = [[UILabel alloc]initWithFrame:CGRectMake(35 + 5,9 , 100, 22)];
        itemTile.text = titleArr[i];
        itemTile.font = [UIFont systemFontOfSize:14];
        [speedView addSubview:itemTile];
        speedView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeItem:)];
        speedView.tag = i + MAIL_CONTACT_ITEM_TAG;
        [speedView addGestureRecognizer:tap];
        [self.view addSubview:speedView];
    }


}
//更改栏位
-(void)changeItem :(UITapGestureRecognizer *)recognizer{
    UIView *chooseView = (UIView *)[recognizer view];
    long tag = chooseView.tag  - MAIL_CONTACT_ITEM_TAG;
    switch (tag) {
        case AllFriend:{
            //
            [self setUpView];
        }
          
            break;
        case SameDepartment:
            
            break;
        case SwordOrgernize:
            //
        {
            [self setUpOrgernizeContactTreeTable];
        }
            break;
        case FrequnetContact:
            
            break;
        default:
            break;
    }
    

}
//设置分级住址
-(void)setUpOrgernizeContactTreeTable{
    
    //删除旧的视图
    [self.friendsTabelView removeFromSuperview];
   
    
    

    
    [self.view addSubview:self.treeView];
    [self setTreeViewData];
    
    
    

}
-(void)titleUpdate{

  

    self.view.backgroundColor = HEXCOLOR(0xf0f0f6);
    self.title = @"通讯录";
    self.navigationItem.title = @"通讯录";
}
-(void)setUpSearchBar{
    UIImage *searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:32.0f];
    //设置顶部搜索栏的背景图片
    [self.searchFriendsBar setBackgroundImage:searchBarBg];
    //设置顶部搜索栏的背景色
    [self.searchFriendsBar setBackgroundColor:HEXCOLOR(0xf0f0f6)];
    
    //设置顶部搜索栏输入框的样式
    UITextField *searchField = [self.searchFriendsBar valueForKey:@"_searchField"];
    searchField.layer.borderWidth = 0.5f;
    searchField.layer.borderColor = [HEXCOLOR(0xdfdfdf) CGColor];
    searchField.layer.cornerRadius = 5.f;
    self.searchFriendsBar.placeholder = @"请输入姓名/首字母";
    
    self.defaultCellsTitle = [NSArray arrayWithObjects: @"群组(所有人)",nil];
    self.defaultCellsPortrait = [NSArray arrayWithObjects: @"defaultGroup",nil];
    
    self.isBeginSearch = NO;
    [self.view addSubview:self.searchFriendsBar];

    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置所有人显示
- (void)setUpView {
    [self.treeView removeFromSuperview];
    self.matchFriendList = [[NSMutableArray alloc] init];
    self.allFriendSectionDic = [[NSDictionary alloc] init];
    
    self.friendsTabelView.tableFooterView = [UIView new];
    self.friendsTabelView.backgroundColor = HEXCOLOR(0xf0f0f6);
    self.friendsTabelView.separatorColor = HEXCOLOR(0xdfdfdf);
    
    self.friendsTabelView.tableHeaderView =
    [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.friendsTabelView.bounds.size.width, 0.01f)];
    
    //设置右侧索引
    self.friendsTabelView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.friendsTabelView.sectionIndexColor = HEXCOLOR(0x555555);
    
    if ([self.friendsTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.friendsTabelView setSeparatorInset:UIEdgeInsetsMake(0, 14, 0, 0)];
    }
    if ([self.friendsTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.friendsTabelView setLayoutMargins:UIEdgeInsetsMake(0, 14, 0, 0)];
    }
    
       [self.friendsTabelView
     setBackgroundColor:[UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1]];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    [self.view addSubview:self.friendsTabelView];
    //更新数据源
        [self getAllFriendList];

}

-(RATreeView *)treeView{
    if (!_treeView) {
        CGRect searchBarFrame = self.searchFriendsBar.frame;
        CGFloat originY = CGRectGetMaxY(searchBarFrame);
        _treeView = [[RATreeView alloc]initWithFrame:CGRectMake(0, originY + TITLE_ITEM_HEIGHT * 2 + 2, self.view.bounds.size.width, self.view.bounds.size.height - searchBarFrame.size.height -TITLE_ITEM_HEIGHT * 2 - 2) style:RATreeViewStylePlain];
        _treeView.delegate = self;
        _treeView.dataSource = self;
        [_treeView registerNib:[UINib nibWithNibName:@"TreeContactCell" bundle:nil] forCellReuseIdentifier:@"TreeContactCell"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.frame = CGRectMake(0, 0, self.view.frame.size.width, 22);
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.frame = CGRectMake(13, 3, 200, 15);
        title.font = [UIFont systemFontOfSize:13.f];
        title.textColor = HEXCOLOR(0x999999);
        title.text = @"组织查询";
        [view addSubview:title];

        _treeView.treeHeaderView = view;
        _treeView.treeFooterView = [[UIView alloc]init];
    }

    return _treeView;
}

- (RCDTableView *)friendsTabelView {
    if (!_friendsTabelView) {
        CGRect searchBarFrame = self.searchFriendsBar.frame;
        CGFloat originY = CGRectGetMaxY(searchBarFrame);
  
        ;
        _friendsTabelView = [[RCDTableView alloc]
                             initWithFrame:CGRectMake(0, originY + TITLE_ITEM_HEIGHT * 2 + 2, self.view.bounds.size.width, self.view.bounds.size.height - searchBarFrame.size.height-TITLE_ITEM_HEIGHT * 2 - 2)
                             style:UITableViewStyleGrouped];
        
        _friendsTabelView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        if ([_friendsTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            _friendsTabelView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        if ([_friendsTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            _friendsTabelView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 0);
        }
        [_friendsTabelView setDelegate:self];
        [_friendsTabelView setDataSource:self];
        [_friendsTabelView setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_friendsTabelView setSectionIndexColor:[UIColor darkGrayColor]];
        [_friendsTabelView
         setBackgroundColor:[UIColor colorWithRed:240.0 / 255 green:240.0 / 255 blue:240.0 / 255 alpha:1]];
        //        _friendsTabelView.style = UITableViewStyleGrouped;
        //        _friendsTabelView.tableHeaderView=self.searchFriendsBar;
        // cell无数据时，不显示间隔线
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_friendsTabelView setTableFooterView:v];
    }
    return _friendsTabelView;
}
- (UISearchBar *)searchFriendsBar {
    if (!_searchFriendsBar) {
     
      
        _searchFriendsBar = [[UISearchBar alloc] initWithFrame:CGRectMake(2, 2 , ScreenWidth - 4, 28)];
        [_searchFriendsBar sizeToFit];
        [_searchFriendsBar setPlaceholder:@"搜索"];
        [_searchFriendsBar.layer setBorderWidth:0.5];
        [_searchFriendsBar.layer
         setBorderColor:[UIColor colorWithRed:235.0 / 255 green:235.0 / 255 blue:235.0 / 255 alpha:1].CGColor];
        [_searchFriendsBar setDelegate:self];
        [_searchFriendsBar setKeyboardType:UIKeyboardTypeDefault];
    }
    return _searchFriendsBar;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (section == 0) {
        if (_isBeginSearch == YES) {
            rows = 0;
        } else {
            rows = 2;
        }
    } else {
        NSString *letter = self.resultDic[@"allKeys"][section - 1];
        rows = [self.allFriendSectionDic[letter] count];
    }
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.resultDic[@"allKeys"] count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 22.f;
    }
    return 21.f;
}

//如果没有该方法，tableView会默认显示footerView，其高度与headerView等高
//另外如果return 0或者0.0f是没有效果的
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 22);
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
    title.frame = CGRectMake(13, 3, 200, 15);
    title.font = [UIFont systemFontOfSize:13.f];
    title.textColor = HEXCOLOR(0x999999);
    
    [view addSubview:title];
    
    if (section == 0) {
        title.text = @"所有联系人";
    } else {
        title.text = self.resultDic[@"allKeys"][section - 1];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *isDisplayID = [[NSUserDefaults standardUserDefaults] objectForKey:@"isDisplayID"];
    static NSString *reusableCellWithIdentifier = @"RCDContactTableViewCell";
    RCDContactTableViewCell *cell =
    [self.friendsTabelView dequeueReusableCellWithIdentifier:reusableCellWithIdentifier];
    if (cell == nil) {
        cell = [[RCDContactTableViewCell alloc] init];
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.nicknameLabel.text = [_defaultCellsTitle objectAtIndex:indexPath.row];
        [cell.portraitView
         setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [_defaultCellsPortrait
                                                                         objectAtIndex:indexPath.row]]]];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        if ([isDisplayID isEqualToString:@"YES"]) {
            cell.userIdLabel.text = [RCIM sharedRCIM].currentUserInfo.userId;
        }
        cell.nicknameLabel.text = [RCIM sharedRCIM].currentUserInfo.name;
        [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:[RCIM sharedRCIM].currentUserInfo.portraitUri]
                             placeholderImage:[UIImage imageNamed:@"contact"]];
    }
    if (indexPath.section != 0) {
        NSString *letter = self.resultDic[@"allKeys"][indexPath.section - 1];
        
        NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
        RCDUserInfo *userInfo = sectionUserInfoList[indexPath.row];
        if (userInfo) {
            if ([isDisplayID isEqualToString:@"YES"]) {
                cell.userIdLabel.text = userInfo.userId;
            }
            cell.nicknameLabel.text = userInfo.name;
            if ([userInfo.portraitUri isEqualToString:@""] || userInfo.portraitUri==nil) {
                DefaultPortraitView *defaultPortrait =
                [[DefaultPortraitView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                [defaultPortrait setColorAndLabel:userInfo.userId Nickname:userInfo.name];
                UIImage *portrait = [defaultPortrait imageFromView];
                cell.portraitView.image = portrait;
            } else {
                NSString *url = [NSString stringWithFormat:@"%@bpmx%@",BPMX_LOCAL,userInfo.portraitUri ];
                [cell.portraitView sd_setImageWithURL:[NSURL URLWithString:url]
                                     placeholderImage:[UIImage imageNamed:@"contact"]];
            }
        }
    }
    if ([RCIM sharedRCIM].globalConversationAvatarStyle == RC_USER_AVATAR_CYCLE &&
        [RCIM sharedRCIM].globalMessageAvatarStyle == RC_USER_AVATAR_CYCLE) {
        cell.portraitView.layer.masksToBounds = YES;
        cell.portraitView.layer.cornerRadius = 20.f;
    } else {
        cell.portraitView.layer.masksToBounds = YES;
        cell.portraitView.layer.cornerRadius = 5.f;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.portraitView.contentMode = UIViewContentModeScaleAspectFill;
    cell.nicknameLabel.font = [UIFont systemFontOfSize:15.f];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.5;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.resultDic[@"allKeys"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RCDUserInfo *user = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
//                RCDAddressBookViewController *addressBookVC = [RCDAddressBookViewController addressBookViewController];
//                [self.navigationController pushViewController:addressBookVC animated:YES];
                return;
            } break;
                
            case 1: {
//                RCDGroupViewController *groupVC = [[RCDGroupViewController alloc] init];
//                [self.navigationController pushViewController:groupVC animated:YES];
                return;
                
            } break;
                
            case 2: {
//                RCDPublicServiceListViewController *publicServiceVC = [[RCDPublicServiceListViewController alloc] init];
//                [self.navigationController pushViewController:publicServiceVC animated:YES];
                return;
                
            } break;
                
            case 3: {
//                RCDPersonDetailViewController *detailViewController = [[RCDPersonDetailViewController alloc] init];
//                [self.navigationController pushViewController:detailViewController animated:YES];
//                detailViewController.userId = [RCIM sharedRCIM].currentUserInfo.userId;
                return;
            }
                
            default:
                break;
        }
    }
    NSString *letter = self.resultDic[@"allKeys"][indexPath.section - 1];
    NSArray *sectionUserInfoList = self.allFriendSectionDic[letter];
    user = sectionUserInfoList[indexPath.row];
    if (user == nil) {
        return;
    }
    RCUserInfo *userInfo = [RCUserInfo new];
    userInfo.userId = user.userId;
    userInfo.portraitUri = user.portraitUri;
    userInfo.name = user.name;
    
    RCDPersonDetailViewController *detailViewController = [[RCDPersonDetailViewController alloc] init];
    detailViewController.userId = user.userId;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchFriendsBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
/**
 *  执行delegate搜索好友
 *
 *  @param searchBar  searchBar description
 *  @param searchText searchText description
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.matchFriendList removeAllObjects];
    if (searchText.length <= 0) {
//        [self sortAndRefreshWithList:[self getAllFriendList]];
    } else {
//        for (RCUserInfo *userInfo in [self getAllFriendList])
        {
            //忽略大小写去判断是否包含
            //whc
//            if ([userInfo.name rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
//                [[RCDUtilities hanZiToPinYinWithString:userInfo.name] rangeOfString:searchText
//                                                                            options:NSCaseInsensitiveSearch]
//                .location != NSNotFound) {
//                [self.matchFriendList addObject:userInfo];
//            }
        }
        [self sortAndRefreshWithList:self.matchFriendList];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchFriendsBar.showsCancelButton = NO;
    [self.searchFriendsBar resignFirstResponder];
    self.searchFriendsBar.text = @"";
    [self.matchFriendList removeAllObjects];
    //whc
//    [self sortAndRefreshWithList:[self getAllFriendList]];
    _isBeginSearch = NO;
    [self.friendsTabelView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (_isBeginSearch == NO) {
        _isBeginSearch = YES;
        [self.friendsTabelView reloadData];
    }
    self.searchFriendsBar.showsCancelButton = YES;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - 获取好友并且排序

- (void)getAllFriendList {
   //是否登录到 聊天服务器
    NSString *currentUserId = [RCIM sharedRCIM].currentUserInfo.userId;
    if (!currentUserId) {
        [SVProgressHUD showInfoWithStatus:@"获取失败"];
        return;
    }
    
    //判断是否需要重新加载通讯录
    if ([DEFAULTS objectForKey:APPFIRSTLOGIN] == nil) {
        hud.labelText = @"通讯录获取中...";
        [self getFriendsFromNet];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else{
        [self getFriendsFromBata];
    }
    
    
   
    
}

- (void)sortAndRefreshWithList:(NSArray *)friendList {
    //whc
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.resultDic = [RCDUtilities sortedArrayWithPinYinDic:friendList];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.allFriendSectionDic = self.resultDic[@"infoDic"];
            [self.friendsTabelView reloadData];
        });
    });
}

/**
 *  添加好友
 *
 *  @param sender sender description
 */
- (void)pushAddFriend:(id)sender {
   // whc
//    RCDSearchFriendViewController *searchFirendVC = [RCDSearchFriendViewController searchFriendViewController];
//    [self.navigationController pushViewController:searchFirendVC animated:YES];
}
-(void)getFriendsFromBata{

    
    NSMutableArray *userInfoList = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance] getAllFriends]];
   
    [self sortAndRefreshWithList:userInfoList];

    
}
//模拟网络加载状态
-(void)getFromJson{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dicList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    
    
}

/**
 第一次加载 或者手动刷新朋友列表
 */
-(void)getFriendsFromNet{
    //网络请求获取
    
    [hud show:YES];
    
    
    NSDictionary *dic = @{@"page":@"1",@"pageSize":@"1000"};
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",BPMX_LOCAL,BPMX,FRIEN_LIST_URL];

    [AFHttpTool requestWihtMethod:RequestMethodTypePost url:url params:dic success:^(id response) {

        
        if (response[@"list"]) {
            
            
           
            
            
           
            //第一次获取到 然后存入数据库 
            [DEFAULTS setObject:[NSString stringWithFormat:@"friend%@",[RCIMClient sharedRCIMClient].currentUserInfo.userId ]forKey:APPFIRSTLOGIN];
            NSString * timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
            [DEFAULTS setObject:timestamp forKey:FRIEND_LIST_UPTATE_TIME];
            [DEFAULTS synchronize];
            
            NSMutableArray *user = [RCDUserInfo mj_objectArrayWithKeyValuesArray:response[@"list"]];
            
            
            [[RCDataBaseManager shareInstance] insertFriendListToDB:user complete:^(BOOL result) {
                
                
            }];
           
            [self sortAndRefreshWithList:user];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [SVProgressHUD showSuccessWithStatus:@"初始化通讯录成功"];
            });
            
            
            
            
        }
        
    } failure:^(NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:NO];
            [SVProgressHUD showErrorWithStatus:@"加载通讯录错误"];
            
        });
        
    }];


}

- (UIImage *)GetImageWithColor:(UIColor *)color andHeight:(CGFloat)height {
    CGRect r = CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

//组织设置数据源 这个要网络加载
-(void)setTreeViewData {
    
  
   //是否需要下拉刷新
    
    if (!self.treeModelArr.count) {
        //仅仅加载一次
        NSString *path = [[NSBundle mainBundle] pathForResource:@"textorg.json" ofType:nil];
        
        //加载JSON文件
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        //将JSON数据转为NSArray或NSDictionary
        NSDictionary *dictmodel = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray *topOrgs = dictmodel[@"childOrgs"];
        RaTreeModel *superModel = [RaTreeModel mj_objectWithKeyValues:topOrgs[0]];
        [self.treeModelArr addObject:superModel];

    }
    
    [self.treeView reloadData];
}


#pragma mark treedelegate

//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    
    return 40;
}

//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    
    TreeContactCell *cell = (TreeContactCell *)[treeView cellForItem:item];
    cell.iconView.image = [UIImage imageNamed:@"listopen"];
    
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    
    TreeContactCell *cell = (TreeContactCell *)[treeView cellForItem:item];
    cell.iconView.image = [UIImage imageNamed:@"listclose"];
    
}

//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    
    
    NSLog(@"已经展开了");
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    
    NSLog(@"已经收缩了");
}

#pragma mark tree datasouce
//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    
    
    
    //获取cell
    TreeContactCell *cell = [treeView dequeueReusableCellWithIdentifier:@"TreeContactCell"];
    
    //当前item
    RaTreeModel *model = item;
    
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
    
    //赋值
    [cell setCellBasicInfoWith:model.orgName level:level children:model.childOrgs.count];
    
    return cell;
    
}

/**
 *  必须实现
 *
 *  @param treeView treeView
 *  @param item    节点对应的item
 *
 *  @return  每一节点对应的个数
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    RaTreeModel *model = item;
    
    if (item == nil) {
        
        return self.treeModelArr.count;
    }
    
    return model.childOrgs.count;
}
/**
 *必须实现的dataSource方法
 *
 *  @param treeView treeView
 *  @param index    子节点的索引
 *  @param item     子节点索引对应的item
 *
 *  @return 返回 节点对应的item
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    
    RaTreeModel *model = item;
    if (item==nil) {
        
        return self.treeModelArr[index];
    }
    
    return model.childOrgs[index];
}


//cell的点击方法
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    
    //获取当前的层
    NSInteger level = [treeView levelForCellForItem:item];
    
    //当前点击的model
    RaTreeModel *model = item;
    
    NSLog(@"点击的是第%ld层,name=%@",level,model.orgName);
    
}

//单元格是否可以编辑 默认是YES
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    
    return YES;
}

//编辑要实现的方法
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item {
    
    NSLog(@"编辑了实现的方法");
    
    
}

-(NSMutableArray *)treeModelArr{

    //请求网络数据
    
    if (!_treeModelArr) {
        _treeModelArr = [NSMutableArray array];
    }
    return _treeModelArr;
}

@end
