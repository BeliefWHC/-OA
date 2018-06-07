//
//  ApplicationViewController.m
//  索德OA
//
//  Created by sw on 18/5/15.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "ApplicationViewController.h"
#import "ApplicationCell.h"
#import "SVProgressHUD.h"
#import "SWOAViewController.h"
@interface ApplicationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic)NSMutableArray *appDataArr;
@property (strong,nonatomic)UICollectionView * appsCollectionView;

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self titleUpdate];
    //不使用button 使用collection
//    [self loadMyApplication];
    //初始化数据源
    [self setData];
    
    
}
-(void)setData{
    //测试数组图片
    NSArray *image = @[@"oatitle",@"mestitle",@"erptitle",@"daiban",@"weibotitle",@"qiandao"];

    self.appDataArr = [NSMutableArray arrayWithArray:image];
//    red="0.97772435897435894" green="0.97772435897435894" blue="0.97772435897435894" alpha="1"
    self.view.backgroundColor  = [UIColor colorWithRed:0.97772435897435894 green:0.97772435897435894 blue:0.97772435897435894 alpha:1];
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    
    //2.初始化collectionView
    self.appsCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:self.appsCollectionView];
    self.appsCollectionView.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
  
    [self.appsCollectionView registerNib:[UINib nibWithNibName:@"ApplicationCell" bundle:nil] forCellWithReuseIdentifier:@"ApplicationCell"];
    

//    //注册UICollectionElementKindSectionFooter  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
//    [self.appsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusableView"];
    
 
    
    
   
    
    //4.设置代理
    self.appsCollectionView.delegate = self;
    self.appsCollectionView.dataSource = self;
    
  
}

-(void)loadMyApplication{
    // 状态栏(statusbar)
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    WLog(@"status width - %f", rectStatus.size.width); // 宽度
    WLog(@"status height - %f", rectStatus.size.height); // 高度
    // 导航栏（navigationbar）
    CGRect rectNav = self.navigationController.navigationBar.frame ;
    WLog(@"nav width - %f", rectNav.size.width); // 宽度
    WLog(@"nav height - %f", rectNav.size.height); // 高度

    
    CGFloat top = rectNav.size.height + rectStatus.size.height;
//加载服务器上我的可用图标
    //每个Item宽高
    CGFloat W = SELF_VIEW_WIDTH/4;
    CGFloat H = SELF_VIEW_WIDTH/4;
    //每行列数
    NSInteger rank = 4;
    //每列间距
    CGFloat rankMargin = 1;
    //每行间距
    CGFloat rowMargin = 1;
    //Item索引 ->根据需求改变索引
    NSUInteger index = 20;
    
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = (i / rank) * (H +rowMargin);
        //Item top
        UIView *speedView = [[UIView alloc] init];
        speedView.backgroundColor = [UIColor blueColor];
        speedView.frame = CGRectMake(X, Y+top, W, H);
        [self.view addSubview:speedView];  
    }
}
-(void)titleUpdate{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"应用";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.appDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ApplicationCell *cell = (ApplicationCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationCell" forIndexPath:indexPath];
    
    cell.titileImage.image = [UIImage imageNamed:self.appDataArr[indexPath.row]];
    NSArray *title = @[@"OA",@"MES",@"ERP",@"我的代办",@"工作微博",@"移动签到"];

    cell.titleLabel.text = title[indexPath.row];
    
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //每个Item宽高
    CGFloat W = (SELF_VIEW_WIDTH -4)/4;
    CGFloat H = (SELF_VIEW_WIDTH -4)/4;
    return CGSizeMake(W, H);
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(SELF_VIEW_WIDTH, 1000);
//}
////通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
//    headerView.backgroundColor =[UIColor whiteColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
//    label.text = @"这是collectionView的头部";
//    label.font = [UIFont systemFontOfSize:20];
//    [headerView addSubview:label];
//    return headerView;
//}


//header的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}




//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[[SWOAViewController alloc]init] animated:YES];
        
    }
    else{
        [SVProgressHUD showInfoWithStatus:@"开发中"];
    }
//    ApplicationCell *cell = (ApplicationCell *)[collectionView cellForItemAtIndexPath:indexPath];
}




@end
