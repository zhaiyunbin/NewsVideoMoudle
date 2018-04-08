//
//  VideoTableViewCell.m
//  NewsVideoMoudle
//
//  Created by jian.hu on 2018/3/29.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "VideoListViewController.h"
#import "XbTabBarViewController.h"
#import "UIColor+Hex.h"
@implementation VideoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
//        _hintView = [[UILabel alloc]init];
//        [_hintView setFont:[UIFont systemFontOfSize:14]];
//        [_hintView setText:@"更新了15条内容"];
//        [_hintView setTextColor:[UIColor whiteColor]];
//        _hintView.textAlignment = NSTextAlignmentCenter;
////        [_hintView setHidden:YES];
//        [_hintView setBackgroundColor:UIColorFrom16RGB(0x28ACFF)];
//        [self addSubview:_hintView];
//        [_hintView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_hintView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.mas_equalTo(0);
//            make.height.mas_equalTo(32);
//            make.width.mas_equalTo(kWidth);
//        }];
    //头像
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(15*widthRate, 15*widthRate, 345*widthRate, 173*widthRate);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowOpacity = 0.5;
    layer.shadowRadius = 4;
    layer.cornerRadius = 4;
    //这里self表示当前自定义的view
    [self.layer addSublayer:layer];

    UIImageView *avatarImageView = [[UIImageView alloc] init];
   
    
    avatarImageView.layer.cornerRadius = 4.0f;
//    avatarImageView.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色
//    avatarImageView.layer.shadowOpacity = 0.5;//设置阴影的透明度
//    avatarImageView.layer.shadowOffset = CGSizeMake(1, 1);//设置阴影的偏移量
//    avatarImageView.layer.shadowRadius = 5;//设置阴影的圆角
    avatarImageView.layer.masksToBounds =YES;
    [self addSubview:avatarImageView];
    self.avatarImageView = avatarImageView;
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
         make.left.mas_equalTo(15*heightRate);
        make.top.mas_equalTo(15*heightRate);
        make.width.mas_equalTo(345*widthRate);
        make.height.mas_equalTo(173*heightRate);

       
    }];

//    [avatarImageView.layer addSublayer:[UIColor setGradualChangingColor:avatarImageView fromColor:@"F3F5F8" toColor:@"D0D7DD"]];
//    _layouerimg =[CALayer layer];
//    _layouerimg.frame = CGRectMake(0, 0, 50*widthRate, 50*heightRate);
//    _layouerimg.cornerRadius =5;
//    _layouerimg.contents =[UIImage imageNamed:@"play"];
//    _layouerimg.masksToBounds =YES;
//    [avatarImageView.layer addSublayer:_layouerimg];

    
    UIImageView *playImageView = [[UIImageView alloc] init];
    playImageView.image = [UIImage imageNamed:@"play"];
    [self addSubview:playImageView];
   
    [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(avatarImageView);
         make.centerY.equalTo(avatarImageView);
        make.width.mas_equalTo(28*widthRate);
        make.height.mas_equalTo(28*heightRate);

    }];
    
    UIView *bgView = [[UIImageView alloc] init];
    bgView.backgroundColor = UIColorFrom16RGB(0xFFFFFF);
    bgView.alpha = 0.2;
    [self addSubview:bgView];
    
   
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatarImageView.mas_bottom).offset(-28);
        make.left.mas_equalTo(312*widthRate);
        make.width.mas_equalTo(38*widthRate);
        make.height.mas_equalTo(15*heightRate);

        
    }];
    
    _timeView = [[UILabel alloc] init];
    _timeView.text =@"3:10";
    _timeView.textColor = UIColorFrom16RGB(0xFDFDFD);
    [_timeView setFont:[UIFont systemFontOfSize:11]];
//    bgView.backgroundColor = UIColorFrom16RGB(0x03ffffff);
    [self addSubview:_timeView];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.centerY.equalTo(bgView);
    }];
    
    _titleView = [[UILabel alloc] init];
    _titleView.textColor = UIColorFrom16RGB(0xFFFFFF);
    [_titleView setFont:[UIFont boldSystemFontOfSize:15]];
    //    bgView.backgroundColor = UIColorFrom16RGB(0x03ffffff);
    [self addSubview:_titleView];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.bottom.equalTo(_timeView).offset(2);
         make.left.mas_equalTo(25*widthRate);
         make.right.mas_equalTo(_timeView.mas_left).offset(-10*widthRate);
        
    }];
    
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = UIColorFrom16RGB(0xEEEEEE);
//    bgView.alpha = 0.2;
    [self addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(avatarImageView.mas_bottom).offset(14);
        make.left.mas_equalTo(avatarImageView.mas_left);
            make.centerX.equalTo(self);
        //        make.top.mas_equalTo(20);
        make.width.equalTo(avatarImageView.mas_width);
        make.height.mas_equalTo(1);
    
        
    }];
    
    
    
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
