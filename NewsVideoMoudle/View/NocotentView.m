//
//  NocotentView.m
//  NewsVideoMoudle
//
//  Created by jian.hu on 2018/4/4.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import "NocotentView.h"
#import "UIColor+Hex.h"
#import "Masonry.h"
#import "XbTabBarViewController.h"

@implementation NocotentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if(self = [super init]){
        [self setBackgroundColor:UIColorFrom16RGB(0xF6F6F6)];
        UIImageView *userIconView = [[UIImageView alloc]init];
        [userIconView setImage:[UIImage imageNamed:@"nocontentlog"]];
        
        [self addSubview:userIconView];
        [userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            //             make.centerY.equalTo(self);
            make.top.mas_equalTo(120*heightRate);
            make.width.mas_equalTo(100*widthRate);
            make.height.mas_equalTo(100*heightRate);
            
        }];
        UILabel *NameView = [[UILabel alloc]init];
        
        NameView.textColor = UIColorFrom16RGB(0xC4CDCE);
        [NameView setFont:[UIFont boldSystemFontOfSize:17]];
        NameView.text = @"目前暂无内容哦";
        [self addSubview:NameView];
        [NameView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(userIconView.mas_bottom).offset(30*heightRate);
        }];
        
        
        
    }
    return self;
}
    

@end
