//
//  XbTabBarViewController.h
//  JHXBusinessApp
//
//  Created by jian.hu on 2018/3/5.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>
// 根据16位RBG值转换成颜色，格式:UIColorFrom16RGB(0xFF0000)
#define UIColorFrom16RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define widthRate kWidth/375
#define heightRate kHeight/667

@interface XbTabBarViewController : UIViewController
@property (nonatomic,copy)UIView * uiview;
@end
