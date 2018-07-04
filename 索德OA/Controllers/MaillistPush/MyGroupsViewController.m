//
//  MyGroupsViewController.m
//  索德OA
//
//  Created by sw on 18/6/14.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "MyGroupsViewController.h"

@interface MyGroupsViewController ()

@end

@implementation MyGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    // Do any additional setup after loading the view from its nib.
    [self setUpTiltle];
}
-(void)setUpTiltle{
    self.title = @"我的群组";

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

@end
