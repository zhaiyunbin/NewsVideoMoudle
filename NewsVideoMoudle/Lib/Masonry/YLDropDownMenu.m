//
//  YLDropDownMenu.m
//  YLDrowDownMenu
//
//  Created by Bing on 16/6/29.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import "YLDropDownMenu.h"

@interface YLDropDownMenu()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;


@property( nonatomic , retain)UILabel* title;
@property(nonatomic ,retain ) UIImageView* icon;

@end

@implementation YLDropDownMenu


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        //UILabel* lbl = [[ UILabel alloc] initWithFrame:frame];
        
        //lbl.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        
    }
    return self;
}

- (void)createView{
  
    
    self.topView = [[UIView alloc] initWithFrame:self.bounds];
    self.topView.backgroundColor =[UIColor clearColor];
   [self addSubview:self.topView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 15, self.bounds.size.width -10, 44*self.dataSource.count) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.bounces = NO;//禁止tableView弹性效果
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.bounds];
    [backImageView setImage:[UIImage imageNamed:@"moreBack"]];
    [self.topView addSubview:backImageView];
    
    [self addSubview:self.tableView];
}

- (void)removeViewFromSuperView{
    [self.topView removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    NSDictionary* dict = self.dataSource[indexPath.row];
    NSString* icon = [dict objectForKey:@"icon"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"title"] ];
    cell.textLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if( icon )
    {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }else
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    
   
    if( icon )
    {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 25, 25)];
        [imageView setImage:[UIImage imageNamed:icon]];
        [cell addSubview:imageView];
    }
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.bounds.size.height-1, cell.bounds.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1];
    [cell addSubview:line];
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    self.finishBlock(self.dataSource[indexPath.row]);
}


@end
