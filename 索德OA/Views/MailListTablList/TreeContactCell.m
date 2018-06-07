//
//  TreeContactCell.m
//  索德OA
//
//  Created by sw on 18/5/30.
//  Copyright © 2018年 sw. All rights reserved.
//

#import "TreeContactCell.h"

@implementation TreeContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





- (void)setCellBasicInfoWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children{
    
    //有自孩子时显示图标
    if (children==0) {
        self.iconView.hidden = YES;
        
    }
    else { //否则不显示
        self.iconView.hidden = NO;
    }
    
    self.titleLable.text = title;
    self.iconView.image = [UIImage imageNamed:@"listclose"];
    
    self.titleLable.font = [UIFont systemFontOfSize:12];
    

    //每一层的布局
    CGFloat left = 10+(level)*30;
    
    //头像的位置
//    CGRect  iconViewFrame = self.iconView.frame;
//    
//    iconViewFrame.origin.x = left;
//    
//    self.iconView.frame = iconViewFrame;
    
    //title的位置
    CGRect titleFrame = self.titleLable.frame;
    
    titleFrame.origin.x = left;
    
    self.titleLable.frame = titleFrame;
    
    
    
}


@end
