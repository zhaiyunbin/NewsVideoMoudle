//
//  XbTabBarViewController.m
//  JHXBusinessApp
//
//  Created by jian.hu on 2018/3/5.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import "XbTabBarViewController.h"
#import "NewsViewController.h"
#import "VideoListViewController.h"
#import "Masonry.h"
#import "UIColor+Hex.h"




@interface XbTabBarViewController ()

@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIView * lineviewF;
@property (nonatomic,strong) UIView * lineviewT;

@property (nonatomic, strong) VideoListViewController *orderVC;
@property (nonatomic, strong) NewsViewController *codeVC;
@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation XbTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _orderVC =[[VideoListViewController alloc] init];
   _codeVC =[[NewsViewController alloc] init];
  

    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 70*heightRate, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 64)];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    [self addChildViewController:_orderVC];
    [self addChildViewController:_codeVC];
    
    [self fitFrameForChildViewController:_orderVC];
    //设置默认显示在容器View的内容
    [self.contentView addSubview:_orderVC.view];
    _currentVC = _orderVC;

    [self setupTabBar:2];
    
   }


- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    chileViewController.view.frame = frame;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/*
 * mode  0 ：微视频  1：最新闻 2:两个模块都有
 */
- (void)setupTabBar:(NSInteger )model{
    _uiview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 70*heightRate)]; ;
    _uiview.backgroundColor = [UIColor whiteColor];
//     [_uiview.layer addSublayer:[UIColor setGradualChangingColor:_uiview fromColor:@"F76B1C" toColor:@"FBDA61"]];
    [self.view addSubview:_uiview];

   if(model == 2)
   {
          for (int i = 0; i < 2; i++) {
           
           UIButton *button = [[UIButton alloc] init];
           
           [button setBackgroundColor:[UIColor clearColor]];
           if(i == 0){
               [button setTitle:@"微视频" forState:UIControlStateNormal] ;
           }else{
               [button setTitle:@"最新闻" forState:UIControlStateNormal] ;
           }
           
           //下面移动的线
           CGFloat l_x = 90*widthRate;
           CGFloat l_y = 68*heightRate;
           CGFloat l_w = 90*widthRate;
           CGFloat l_h = 2*heightRate;
           UIView *footLineView = [[UIView alloc] initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
           footLineView.backgroundColor = UIColorFrom16RGB(0x333333);
           [button addSubview:footLineView];
           
           //下面的线
           CGFloat l_x1 = 0;
           CGFloat l_y1 = 70*heightRate;
           CGFloat l_w1 = kWidth;
           CGFloat l_h1 = 1*heightRate;
           UIView *footLineViewLine = [[UIView alloc] initWithFrame:CGRectMake(l_x1, l_y1, l_w1, l_h1)];
           footLineViewLine.backgroundColor = UIColorFrom16RGB(0xDDDDDD);
           
           [button addSubview:footLineViewLine];
           
           if(button.isSelected){
               
               button.titleLabel.font = [UIFont boldSystemFontOfSize: 19.0];
           }else{
               //              [footLineView setHidden:YES];
               button.titleLabel.font = [UIFont systemFontOfSize: 17.0];
               
           }
           
           if(i == 0){
               _lineviewF = footLineView;
               [footLineView setHidden:NO];
               button.titleEdgeInsets = UIEdgeInsetsMake(15*heightRate, 80*widthRate,0,0);
               
           }else{
               _lineviewT = footLineView;
               [footLineView setHidden:YES];
               button.titleEdgeInsets = UIEdgeInsetsMake(15*heightRate, 0,0,80*widthRate);
           }
           
           
           
           
           [button setTitleColor:UIColorFrom16RGB(0x333333) forState:UIControlStateSelected];
           [button setTitleColor:UIColorFrom16RGB(0x555555) forState:UIControlStateNormal];
           button.adjustsImageWhenHighlighted = NO;
       
           
           CGFloat x = i * _uiview.frame.size.width / 2;
           button.frame = CGRectMake(x, 0, _uiview.frame.size.width / 2, _uiview.frame.size.height);
           
           [_uiview addSubview:button];
           
           //设置按钮的标记, 方便来索引当前的按钮,并跳转到相应的视图
           button.tag = i;
           
           [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
           
           //设置初始显示界面
           if (0 == i) {
               button.selected = YES;
               self.selectedBtn = button;  //设置该按钮为选中的按钮
           }
       }
   }else{
//       for (int i = 0; i < 2; i++) {
       
           UIButton *button = [[UIButton alloc] init];
           
           [button setBackgroundColor:[UIColor clearColor]];
           if(model == 0){
               [button setTitle:@"微视频" forState:UIControlStateNormal] ;
           }else if(model ==1){
               [button setTitle:@"最新闻" forState:UIControlStateNormal] ;
           }
       
           //下面移动的线
           CGFloat l_x = 90*widthRate;
           CGFloat l_y = 60*heightRate;
           CGFloat l_w = 90*widthRate;
           CGFloat l_h = 2*heightRate;
           UIView *footLineView = [[UIView alloc] initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
           footLineView.backgroundColor = UIColorFrom16RGB(0x333333);
           footLineView.hidden = YES;
           [button addSubview:footLineView];
           [footLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(button);
                make.top.mas_equalTo(l_y);
                make.width.mas_equalTo(l_w);
                make.height.mas_equalTo(l_h);
           }];
           //下面的线
           CGFloat l_x1 = 0;
           CGFloat l_y1 = 62*heightRate;
           CGFloat l_w1 = kWidth;
           CGFloat l_h1 = 1*heightRate;
           UIView *footLineViewLine = [[UIView alloc] initWithFrame:CGRectMake(l_x1, l_y1, l_w1, l_h1)];
           footLineViewLine.backgroundColor = UIColorFrom16RGB(0xDDDDDD);
           
           [_uiview addSubview:footLineViewLine];
           
           if(button.isSelected){
               
               button.titleLabel.font = [UIFont boldSystemFontOfSize: 19.0];
           }else{
               //              [footLineView setHidden:YES];
               button.titleLabel.font = [UIFont systemFontOfSize: 17.0];
               
           }
           

           _lineviewF = footLineView;
           [footLineView setHidden:YES];

       
           [button setTitleColor:UIColorFrom16RGB(0x333333) forState:UIControlStateSelected];
           [button setTitleColor:UIColorFrom16RGB(0x555555) forState:UIControlStateNormal];
           button.adjustsImageWhenHighlighted = NO;
            button.frame = CGRectMake(0, 0, _uiview.frame.size.width / 2, _uiview.frame.size.height);
           
           [_uiview addSubview:button];
       
          [button mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerX.equalTo(_uiview);
           make.width.mas_equalTo(_uiview.frame.size.width / 2);
           make.height.mas_equalTo( _uiview.frame.size.height);
        
          }];
       
           //设置按钮的标记, 方便来索引当前的按钮,并跳转到相应的视图
           button.tag = model;
           
           [button addTarget:self action:@selector(clickBtns:) forControlEvents:UIControlEventTouchUpInside];
           
           //设置初始显示界面
//           if (0 == 0) {
               button.selected = YES;
               self.selectedBtn = button;  //设置该按钮为选中的按钮
//           }
//       }
       
       if(model == 0){
           
         [self.contentView addSubview:_orderVC.view];
           
       }else if(model == 1){
          [self.contentView addSubview:_codeVC.view];
           
       }
       
   }
}

- (void)clickBtns:(UIButton *)button {
//    if(button.tag == 0){
//        [self fitFrameForChildViewController:_orderVC];
//        [self transitionFromOldViewController:_currentVC toNewViewController:_orderVC];
//
//    }else if(button.tag == 1){
//        [self fitFrameForChildViewController:_codeVC];
//        [self transitionFromOldViewController:_currentVC toNewViewController:_codeVC];
//
//    }
    
}

//TabBar点击，切换界面
- (void)clickBtn:(UIButton *)button {
    
    if ((button.tag == 0 && _currentVC == _orderVC) || (button.tag == 1 && _currentVC == _codeVC)) {
        return;
    }
    //1.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    self.selectedBtn.font = [UIFont boldSystemFontOfSize: 17.0];
    //2.再将当前按钮设置为选中
    button.selected = YES;
    button.titleLabel.font = [UIFont boldSystemFontOfSize: 19.0];
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = button;
    
    //4.跳转到相应的视图控制器. (通过selectIndex参数来设置选中了那个控制器)
//    self.selectedIndex = button.tag;
    if(button.tag == 0){
//        [_lineviewF setHidden:NO];
//        [_lineviewT setHidden:YES];
        [self fitFrameForChildViewController:_orderVC];
        [self transitionFromOldViewController:_currentVC toNewViewController:_orderVC];
        [UIView animateWithDuration:0.3 animations:^{
            
            
            CGRect frame =_lineviewF.frame;
            frame.origin.x =90*widthRate;
            
            _lineviewF.frame = frame;
            
            
            
        }completion:^(BOOL isFinished){
            
            
            
        }];
        
    }else{
//        [_lineviewF setHidden:YES];
//        [_lineviewT setHidden:YES];
        [self fitFrameForChildViewController:_codeVC];
         [self transitionFromOldViewController:_currentVC toNewViewController:_codeVC];
        [UIView animateWithDuration:0.3 animations:^{
            
            
            
            CGRect frame =_lineviewF.frame;
            
            frame.origin.x =200*widthRate;
            
            _lineviewF.frame = frame;
            
            
            
        }completion:^(BOOL isFinished){
            
            
            
        }];
    }
    
}
//切换页面
- (void)transitionFromOldViewController:(UIViewController *)oldViewController toNewViewController:(UIViewController *)newViewController{
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newViewController didMoveToParentViewController:self];
            _currentVC = newViewController;
        }else{
            _currentVC = oldViewController;
        }
    }];
}






@end
