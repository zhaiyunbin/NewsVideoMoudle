//
//  VideoListViewController.m
//  NewsVideoMoudle
//
//  Created by jian.hu on 2018/3/28.
//  Copyright © 2018年 xiaobu. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoTableViewCell.h"
#import <NewsFeedsUISDK/NewsFeedsUISDK.h>
#import <NewsFeedsSDK/NewsFeedsSDK.h>
#import <NewsFeedsSDK/NFNews.h>
#import "Masonry.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Hex.h"
#import "NocotentView.h"

@interface VideoListViewController () <UITableViewDelegate, UITableViewDataSource,NFeedsViewDelegate,NFPicSetGalleryDelegate,NFVideoBrowserDelegate,NewsFeedsUISDKDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *nocontentView;
//@property (nonatomic, strong) NFNews *dataSource;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation VideoListViewController
static NSString * const VideoListViewCellIdentify = @"VideoListViewCellIdentify";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NewsFeedsSDK sharedInstance] setAdPresentController:self];
    [NewsFeedsUISDK setDelegate:self];

    
    UITableView *tableView =  [[UITableView alloc] initWithFrame:self.view.bounds];
    [tableView setHidden:NO];
    
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.rowHeight = 203.0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    [tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:VideoListViewCellIdentify];
    //    tableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:tableView];
    self.tableView = tableView;
     
    
    _nocontentView =  [[NocotentView alloc]init];
    [self.view addSubview:_nocontentView];
    [_nocontentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(kHeight);
        make.width.mas_equalTo(kWidth);
        
    }];
    
    
    [tableView.mj_footer beginRefreshing];
//    [tableView.h]
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upFreshLoadMoreData)];
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downFreshloadData)];
    [self downFreshloadData];
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_nocontentView addGestureRecognizer:tapGesturRecognizer];
    
    
}


-(void)tapAction:(id)tap

{
    [self downFreshloadData];
  
    
}
-(void)viewWillAppear:(BOOL)animated{
    

}

- (void)videoBack:(NFVideoBrowserViewController *)browserController extraData:(id)extraData {
    [browserController.navigationController popViewControllerAnimated:YES];
}
- (void)downFreshloadData
{
    
    [[NewsFeedsSDK sharedInstance] loadChannelsWithBlock:^(NFChannels *channelList, NSError *error) {
        if (error) {
            //网络请求加载失败
            [self.tableView.mj_header endRefreshing:NO];
            
            return;
        }
        if(!channelList){
            [self.tableView setHidden:YES];
            [_nocontentView setHidden:NO];
            return;
        }
        
        //网络请求加载成功
        [[NewsFeedsSDK sharedInstance] loadNewsWithChannel:channelList.channels[channelList.channels.count-1] pageSize:20 loadType:0 block:^(NFNews *newsList, NSError *error) {
            //MOD[2018-1-18] 新闻列表曝光 zyb
            if (error) {
                //网络请求加载失败
                return;
            }
            
       
            NSMutableArray  *LIST = newsList.infos;
            [LIST addObjectsFromArray:_dataSource];
            _dataSource = LIST;
         
            if(!_dataSource){
                [self.tableView setHidden:YES];
                [_nocontentView setHidden:NO];
            }else{
                [self.tableView setHidden:NO];
                [_nocontentView setHidden:YES];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing:YES];
            
        }];
        
    }];
}

- (void)upFreshLoadMoreData
{
    
    
    [[NewsFeedsSDK sharedInstance] loadChannelsWithBlock:^(NFChannels *channelList, NSError *error) {
        if (error) {
            //网络请求加载失败
            [self.tableView.mj_footer endRefreshing:NO];
            
            return;
        }
        
        //网络请求加载成功
        [[NewsFeedsSDK sharedInstance] loadNewsWithChannel:channelList.channels[channelList.channels.count-1] pageSize:20 loadType:0 block:^(NFNews *newsList, NSError *error) {
            //MOD[2018-1-18] 新闻列表曝光 zyb
            if (error) {
                //网络请求加载失败
                return;
            }
            [_dataSource addObjectsFromArray:newsList.infos];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing:YES];
            
        }];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //         [self.navigationController setNavigationBarHidden:YES animated:NO];
      NFNewsInfo *info =[_dataSource objectAtIndex:indexPath.row];
    NFVideoBrowserViewController *videoBrowserVC = [NewsFeedsUISDK createVideoBrowserViewController:info delegate:self extraData:@"VideoBrowserViewController"];
//            [videoBrowserVC setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:videoBrowserVC animated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoListViewCellIdentify forIndexPath:indexPath];
    
//
//    cell.nameLabel.text = orderItem.SKU_NAME;
//    cell.timeview.text  =  [NSString stringWithFormat:@"核销时间: %@",orderItem.USE_TIME];
//
//    NSString *strValue=[NSString stringWithFormat:@"%0.2f", orderItem.UNIT_PRICE];
//    cell.codePriceView.text = [NSString stringWithFormat:@"¥%@",strValue];
    if(indexPath.row == 0){
        

    }else{

        
        
    }
    
    NFNewsInfo *info =[_dataSource objectAtIndex:indexPath.row];
    NSLog(@"title1:%@title2:%@",info.videos[0].cover,info.videos[0].largeCover);    
    if(info.videos[0].cover){
        NSURL *url = [NSURL URLWithString:info.videos[0].cover];
        NSString *host = url.host;
        NSString *imgurl = info.videos[0].cover;
        if([host isEqualToString:@"vimg.nosdn.127.net"]){
            
            NSString *str= [info.videos[0].cover substringFromIndex:5];
            imgurl = [NSString stringWithFormat:@"http%@",str];
            NSLog(@"title:%@",imgurl);
        }
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:imgurl]
                                placeholderImage:[UIImage imageNamed:@"bgcolor"]];
//        cell.layouerimg.contents = cell.avatarImageView.image;
//         [cell.avatarImageView bringSubviewToFront:cell.avatarImageView.image];
    }else{
        NSURL *url = [NSURL URLWithString:info.videos[0].largeCover];
        NSString *host = url.host;
        NSString *imgurl = info.videos[0].cover;
        if([host isEqualToString:@"vimg.nosdn.127.net"]){
            
            NSString *str= [info.videos[0].largeCover substringFromIndex:5];
            imgurl = [NSString stringWithFormat:@"https%@",str];
        }
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:imgurl]
                                placeholderImage:[UIImage imageNamed:@"bgcolor"]];
//        cell.layouerimg.contents = cell.avatarImageView.image;
//        [cell.avatarImageView bringSubviewToFront:cell.avatarImageView.image];
    }
    cell.timeView.text =[self timeFormatted:info.videos[0].duration];
    cell.titleView.text = info.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end
