//
//  TreeContactCell.h
//  索德OA
//
//  Created by sw on 18/5/30.
//  Copyright © 2018年 sw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreeContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;//图标

@property (weak, nonatomic) IBOutlet UILabel *titleLable;//标题

//赋值
- (void)setCellBasicInfoWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children;



@end
