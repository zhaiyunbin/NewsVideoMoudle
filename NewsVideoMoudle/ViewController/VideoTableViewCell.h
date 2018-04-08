//
//  VideoTableViewCell.h
//  NewsVideoMoudle
//
//  Created by jian.hu on 2018/3/29.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface VideoTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) CALayer *layouerimg;

@property (nonatomic, strong) UILabel *timeView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UILabel *hintView;
@property(nonatomic , assign) int pageInde;

- (void)LW_gradientColorWithRed:(CGFloat)red
                          green:(CGFloat)green
                           blue:(CGFloat)blue
                     startAlpha:(CGFloat)startAlpha
                       endAlpha:(CGFloat)endAlpha
                      direction:(NSInteger)direction
                          frame:(CGRect)frame;
@end
