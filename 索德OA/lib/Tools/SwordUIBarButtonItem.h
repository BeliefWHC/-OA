//
//  SwordUIBarButtonItem.h
//  索德OA
//
//  Created by sw on 18/6/7.
//  Copyright © 2018年 sw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwordUIBarButtonItem : UIBarButtonItem


@property(nonatomic, strong) UIButton *button;
//初始化包含图片的
- (SwordUIBarButtonItem *)initWithLeftBarButton:(NSString *)title target:(id)target action:(SEL)method;

//初始化包含图片的UIBarButtonItem
- (SwordUIBarButtonItem *)initContainImage:(UIImage *)buttonImage
                          imageViewFrame:(CGRect)imageFrame
                             buttonTitle:(NSString *)buttonTitle
                              titleColor:(UIColor *)titleColor
                              titleFrame:(CGRect)titleFrame
                             buttonFrame:(CGRect)buttonFrame
                                  target:(id)target
                                  action:(SEL)method;

//初始化不包含图片的UIBarButtonItem
- (SwordUIBarButtonItem *)initWithbuttonTitle:(NSString *)buttonTitle
                                 titleColor:(UIColor *)titleColor
                                buttonFrame:(CGRect)buttonFrame
                                     target:(id)target
                                     action:(SEL)method;

//设置UIBarButtonItem是否可以被点击和对应的颜色
- (void)buttonIsCanClick:(BOOL)isCanClick
             buttonColor:(UIColor *)buttonColor
           barButtonItem:(SwordUIBarButtonItem *)barButtonItem;

//平移UIBarButtonItem
- (NSArray<UIBarButtonItem *> *)setTranslation:(UIBarButtonItem *)barButtonItem translation:(CGFloat)translation;

@end
