//
//  MJRefreshNormalHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefreshNormalHeader.h"
#import "NSBundle+MJRefresh.h"
#import "Masonry.h"
#import "UIColor+Hex.h"


@interface MJRefreshNormalHeader()
{
    __unsafe_unretained UIImageView *_arrowView;
}
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (strong, nonatomic) UILabel *hintView;
@end

@implementation MJRefreshNormalHeader
#pragma mark - 懒加载子控件
- (UIImageView *)arrowView
{
//    
    
    if (!_arrowView) {
//        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[NSBundle mj_arrowImage]];
         UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
        
        [self addSubview:_arrowView = arrowView];
        
    }
  
   
    return _arrowView;
}

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    
    return _loadingView;
}
 //添加提示条
- (UILabel *)hintView
{
        if(!_hintView)
        {
            _hintView = [[UILabel alloc]init];
                    [_hintView setTag:1111];
            [_hintView setFont:[UIFont systemFontOfSize:14]];
            [_hintView setText:@"更新了15条内容"];
            [_hintView setTextColor:[UIColor whiteColor]];
            _hintView.textAlignment = NSTextAlignmentCenter;
            [_hintView setHidden:YES];
            [_hintView setBackgroundColor:UIColorFrom16RGB(0x28ACFF)];
            [self addSubview:_hintView];
            [_hintView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [_hintView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.mas_equalTo(_arrowView.mas_bottom).offset(35);
                make.height.mas_equalTo(30*heightRate);
                make.width.mas_equalTo(self.frame.size.width);
            }];
        }
    
    return _hintView;
}
#pragma mark - 公共方法
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
   
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    [self hintView];

    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;

    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
//    [UIView animateWithDuration:0.5 animations:^{
//        _hintView.center = CGPointMake(arrowCenterX, arrowCenterY);
//    } completion:^(BOOL finished) {
//        //平移结束添加抖动动画
////        [self shakeAnimation];
//    }];
//
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
        
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    
    self.arrowView.tintColor = self.stateLabel.textColor;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
//      [_hintView setHidden:YES];
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                self.arrowView.hidden = NO;
                //刷新完毕处理 提示条
                if(self.IsSuc){
                   
                    [_hintView setHidden:NO];
                }else{
                     self.hintView.hidden = YES;
                }
                
                 self.mj_h = MJRefreshHeaderHeight+62;
                int64_t delayInSeconds = 2;      // 延迟的时间
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                NSLog(@"inster:%f",insetT);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [_hintView setHidden:YES];
                   self.mj_h = MJRefreshHeaderHeight;
                });
                
            }];
        } else {
            [self.loadingView stopAnimating];
            self.arrowView.hidden = NO;
//            [_hintView setHidden:NO];
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
               
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.loadingView stopAnimating];
        self.arrowView.hidden = NO;
         self.hintView.hidden = YES;
       
//        [_hintView setHidden:NO];
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
       
//       [_hintView setHidden:NO];
//        [self.hintView startAnimating];
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startAnimating];
        self.arrowView.hidden = YES;
        self.hintView.hidden = YES;
        
    }
   
    
}
@end
