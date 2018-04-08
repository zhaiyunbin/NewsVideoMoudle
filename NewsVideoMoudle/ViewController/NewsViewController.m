//
//  NewsViewController.m
//  JHXApp
//
//  Created by zjc on 2017/11/13.
//
//

#import "NewsViewController.h"
#import <NewsFeedsUISDK/NewsFeedsUISDK.h>
#import <NewsFeedsSDK/NewsFeedsSDK.h>
#import <CommonCrypto/CommonCrypto.h>
//#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ArticleDetailViewController.h"
#import "XbTabBarViewController.h"

@interface NewsViewController ()  <NFeedsViewDelegate, NewsMarkReadDelegate,NFPicSetGalleryDelegate,NFVideoBrowserDelegate,NewsFeedsUISDKDelegate>

@property (nonatomic, strong) NFeedsView *feedsView;

@end

@implementation NewsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:NO animated:NO]; //设置隐藏
    
    //设置广告的presentViewController
     [self.view setBackgroundColor:[UIColor whiteColor]];
    [[NewsFeedsSDK sharedInstance] setAdPresentController:self];
    
    [NewsFeedsUISDK setDelegate:self];
    
    
    _feedsView = [NewsFeedsUISDK createFeedsView:self.navigationController delegate:self extraData:@"seperate"];
    _feedsView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64);
    
    [self.view addSubview:_feedsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if(self.tabBarController){
        XbTabBarViewController *tabvc = self.tabBarController;
        [tabvc.uiview setHidden:NO];
//        tabvc.tabBar.hidden = YES;
    }
    
}
#pragma mark - NFeedsViewDelegate.

- (void)newsListDidSelectNews:(NFeedsView *)pageControllerView newsInfo:(NFNewsInfo *)newsInfo extraData:(id)extraData {

//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    XbTabBarViewController *tabvc = self.tabBarController;
//    [tabvc.uiview setHidden:YES];
    if ([newsInfo.infoType isEqualToString:@"article"]) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
       
        ArticleDetailViewController *detailVC = [[ArticleDetailViewController alloc] initWithNews:newsInfo];
        [detailVC setHidesBottomBarWhenPushed:YES];
        detailVC.delegate = self;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if([newsInfo.infoType isEqualToString:@"picset"]) {
        NFPicSetGalleryViewController *browserVC = [NewsFeedsUISDK createPicSetGalleryViewController:newsInfo delegate:self extraData:@"PicSetGalleryViewController"];
        [browserVC setHidesBottomBarWhenPushed:YES];

        [self.navigationController pushViewController:browserVC animated:YES];
    } else if ([newsInfo.infoType isEqualToString:@"video"]) {
//         [self.navigationController setNavigationBarHidden:YES animated:NO];
        NFVideoBrowserViewController *videoBrowserVC = [NewsFeedsUISDK createVideoBrowserViewController:newsInfo delegate:self extraData:@"VideoBrowserViewController"];
//        [videoBrowserVC setHidesBottomBarWhenPushed:YES];

        [self.navigationController pushViewController:videoBrowserVC animated:YES];
    }
}

#pragma mark - NewsMarkReadDelegate.

- (void)markRead {
//       [self.navigationController setNavigationBarHidden:NO animated:NO];
//    XbTabBarViewController *tabvc = self.tabBarController;
//    [tabvc.uiview setHidden:YES];
    [_feedsView markReadNews];
}


#pragma mark - NFPicSetGalleryDelegate.

- (void)picSetDidLoadContent:(NFPicSetGalleryViewController *)browserController extraData:(id)extraData {
    [_feedsView markReadNews];
}

- (void)back:(NFPicSetGalleryViewController *)browserController extraData:(id)extraData {
     [self.navigationController setNavigationBarHidden:NO animated:NO];
    [browserController.navigationController popViewControllerAnimated:YES];
}

- (void)relatedNewsDidSelect:(NFPicSetGalleryViewController *)browserController newsInfo:(NFNewsInfo *)newsInfo extraData:(id)extraData {
    NFPicSetGalleryViewController *browserVC = [NewsFeedsUISDK createPicSetGalleryViewController:newsInfo delegate:self extraData:@"PicSetGalleryViewController"];
    
    [browserController.navigationController pushViewController:browserVC animated:YES];
}


#pragma mark - NFVideoBrowserDelegate.

- (void)videoDidLoadContent:(NFVideoBrowserViewController *)browserController extraData:(id)extraData {
    
    [_feedsView markReadNews];
}

- (void)videoBack:(NFVideoBrowserViewController *)browserController extraData:(id)extraData {
    [browserController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - share
- (void)onShareClick:(NSDictionary *)shareInfo
                type:(NSInteger)type {
    NSMutableDictionary *userInfo = [@{} mutableCopy];
    [userInfo setObject:[NSString stringWithFormat:@"youliao://youliao.163yun.com?infoId=%@&infoType=%@&producer=%@", shareInfo[@"infoId"], shareInfo[@"infoType"], shareInfo[@"producer"]] forKey:@"iOSOpenUrl"];
    //        [userInfo setObject:@"https://itunes.apple.com/app/id893031254" forKey:@"iOSDownUrl"];
    [userInfo setObject:[NSString stringWithFormat:@"youliao://youliao.163yun.com?infoId=%@&infoType=%@&producer=%@", shareInfo[@"infoId"], shareInfo[@"infoType"], shareInfo[@"producer"]] forKey:@"androidOpenUrl"];
    
    NSString *newsImageUrl = shareInfo[@"thumbnail"];
    UIImage *thumbnail = nil;
    if (newsImageUrl) {
        //        thumbnail = [[SDImageCache sharedImageCache] imageFromCacheForKey: [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:newsImageUrl]]];
    }
    
    NSString *baseUrl;
    
    
    baseUrl = @"https://youliao.163yun.com";
    
    NSMutableString *url = [[NSString stringWithFormat:@"%@/h5/index.html#/info", baseUrl] mutableCopy];
    
    NSMutableDictionary *params = [@{} mutableCopy];
    [params setValuesForKeysWithDictionary:userInfo];
    [params setObject:@"1" forKey:@"fss"];
    
    [params setObject:appkey forKey:@"appkey"];
    [params setObject:scarrett forKey:@"secretkey"];
   // [[NewsFeedsSDK sharedInstance] startWithAppKey:@"f85916ad315943a1a6866648a45de93a" appSecret:@"3f8d5bf04fa54f708fbd9f704eefba50"];金华
    
    
    [params setObject:[[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000] stringValue] forKey:@"timestamp"];
    [params setObject:shareInfo[@"infoId"] forKey:@"infoid"];
    [params setObject:shareInfo[@"infoType"] forKey:@"infotype"];
    [params setObject:shareInfo[@"producer"] forKey:@"producer"];
    [params setObject:@"2" forKey:@"platform"];
    [params setObject:@"2" forKey:@"attachPlatform"];
    [params setObject:[NewsFeedsUISDK version] forKey:@"version"];
    [params setObject:shareInfo[@"source"] forKey:@"source"];
    NSMutableString *signature = [@"" mutableCopy];
    NSMutableString *queryString = [@"" mutableCopy];
    
    for (NSString *key in params) {
        NSString *value = params[key];
        [signature appendFormat:@"%@%@", key, value];
        if ([queryString isEqualToString:@""]) {
            [queryString appendFormat:@"%@=%@", key, [self encodeParameter:value]];
        } else {
            [queryString appendFormat:@"&%@=%@", key, [self encodeParameter:value]];
        }
    }
    [queryString appendFormat:@"&signature=%@", [self md5:signature]];
    
    [url appendFormat:@"?%@", queryString];
    //
    //    [WXApiRequestHandler sendLinkURL:url
    //                             TagName:shareInfo[@"infoType"]
    //                               Title:shareInfo[@"title"]
    //                         Description:shareInfo[@"summary"] ?  : shareInfo[@"source"]
    //                          ThumbImage:thumbnail
    //                             InScene:type];
    
}

- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)encodeParameter:(NSString *)originalPara {
    CFStringRef encodeParaCf = CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)originalPara, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    NSString *encodePara = (__bridge NSString *)(encodeParaCf);
    CFRelease(encodeParaCf);
    return encodePara;
}

@end
