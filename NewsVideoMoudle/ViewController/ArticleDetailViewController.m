//
//  ArticleDetailViewController.m
//  NewsFeedsUIDemo
//
//  Created by shoulei ma on 2017/10/13.
//  Copyright © 2017年 NetEase. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import <NewsFeedsSDK/NewsFeedsSDK.h>
#import <NewsFeedsUISDK/NewsFeedsUISDK.h>
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <CommonCrypto/CommonCrypto.h>
//#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
//#import "KeyConfiguration.h"
#import "NewsViewController.h"


@interface ArticleDetailViewController () <NFArticleDetailViewDelegate,NFArticleGalleryDelegate>

@property (nonatomic, strong) NFNewsInfo *newsInfo;
@property (nonatomic, strong) NFArticleDetailView *articledetailView;

@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation ArticleDetailViewController


- (instancetype)initWithNews:(NFNewsInfo *)newsInfo {
    if (self = [super init]) {
        _newsInfo = newsInfo;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _articledetailView = [NewsFeedsUISDK createArticleDetailView:_newsInfo delegate:self extraData:@"articledetailView"];
    [self.view addSubview:_articledetailView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //MOD[2018-1-26] 防止图片颜色被修改 zyb
    [barButtonItem setImage:[[UIImage imageNamed:@"blueback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIBarButtonItem *rightBarItem= [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"share2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(onClickedShareBtn)];
    //end
    self.navigationItem.rightBarButtonItem = rightBarItem;
//
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.title = _newsInfo.source;

}

-(void)back
{
  
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)onClickedShareBtn{
    
    
    NSMutableDictionary *userInfo = [@{} mutableCopy];
    [userInfo setObject:[NSString stringWithFormat:@"youliao://youliao.163yun.com?infoId=%@&infoType=%@&producer=%@", self.newsInfo.infoId, self.newsInfo.infoType, self.newsInfo.producer] forKey:@"iOSOpenUrl"];
    [userInfo setObject:[NSString stringWithFormat:@"youliao://youliao.163yun.com?infoId=%@&infoType=%@&producer=%@",  self.newsInfo.infoId, self.newsInfo.infoType, self.newsInfo.producer] forKey:@"androidOpenUrl"];
    
    NSString *newsImageUrl = self.newsInfo.thumbnails[0];
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
    
    [params setObject:[[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000] stringValue] forKey:@"timestamp"];
    [params setObject:self.newsInfo.infoId forKey:@"infoid"];
    [params setObject:self.newsInfo.infoType forKey:@"infotype"];
    [params setObject:self.newsInfo.producer forKey:@"producer"];
    [params setObject:@"2" forKey:@"platform"];
    [params setObject:@"2" forKey:@"attachPlatform"];
    [params setObject:[NewsFeedsUISDK version] forKey:@"version"];
    [params setObject:self.newsInfo.source forKey:@"source"];
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
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    // NSArray* imageArray = @[[[NSBundle mainBundle] pathForResource:@"D45" ofType:@"jpg"]];
    
    //优先使用平台客户端分享
//    [shareParams SSDKEnableUseClientShare];
//    //设置微博使用高级接口
//    //2017年6月30日后需申请高级权限
//    //    [shareParams SSDKEnableAdvancedInterfaceShare];
//    //    设置显示平台 只能分享视频的YouTube MeiPai 不显示
//    NSArray *items = @[
//                       @(SSDKPlatformSubTypeWechatSession),
//
//                       @(SSDKPlatformSubTypeWechatTimeline),
//
//                       ];
//
//    //设置简介版UI 需要  #import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//    //    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
//
//    NFNewsImage*newImgage =   self.newsInfo.thumbnails[0];
//    [shareParams SSDKSetupShareParamsByText:self.newsInfo.summary? self.newsInfo.summary:@""
//                                     images:newImgage.url
//                                        url:[NSURL URLWithString:url]
//                                      title:self.newsInfo.title
//                                       type:SSDKContentTypeWebPage];
//    [ShareSDK showShareActionSheet:self.view
//                             items:items
//                       shareParams:shareParams
//               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//                   switch (state) {
//
//                       case SSDKResponseStateBegin:
//                       {
//                           //设置UI等操作
//                           break;
//                       }
//                       case SSDKResponseStateSuccess:
//                       {
//                           //Instagram、Line等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
//                           if (platformType == SSDKPlatformTypeInstagram)
//                           {
//                               break;
//                           }
//
//
//
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//
//                           break;
//                       }
//                       case SSDKResponseStateFail:
//                       {
//
//                           break;
//                       }
//                       case SSDKResponseStateCancel:
//                       {
//                       }
//                       default:
//                           break;
//                   }
//               }];
//
//
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _articledetailView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
}
- (void)dealloc {
    //注意：此处非常重要，不然无法采集用户的浏览信息
    // [_articledetailView trackArticleBrowseEnd];
}


#pragma mark - delegate.

- (void)relatedNewsDidSelect:(NFArticleDetailView *)detailView
                    newsInfo:(NFNewsInfo *)newsInfo
                   extraData:(id)extraData {
    ArticleDetailViewController *detailViewController = [[ArticleDetailViewController alloc] initWithNews:newsInfo];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

- (void)webImageDidSelect:(NFArticleDetailView *)detailView
               imageArray:(NSArray<NFNewsDetailImage *> *)imageArray
                  atIndex:(NSUInteger)index
                    frame:(CGRect)frame
                extraData:(id)extraData {
    _imageArray = [imageArray copy];
    
    NFArticleGalleryViewController *browserVC = [NewsFeedsUISDK createArticleGalleryViewController:imageArray imageIndex:index delegate:self extraData:@"ArticleGalleryViewController"];
    
    [self presentViewController:browserVC animated:YES completion:nil];
}

- (void)articleDidLoadContent:(NFArticleDetailView *)detailView extraData:(id)extraData {
    __weak typeof(self)weakSelf = self;
    
    [[NewsFeedsSDK sharedInstance] hasRead:self.newsInfo.infoId block:^(BOOL hasRead) {
        if (!hasRead) {
            //MOD[2018-1-18] 新闻点击事件曝光 zyb
            [[NFTracker sharedTracker] trackNewsClick:_newsInfo];
            //end
            [[NewsFeedsSDK sharedInstance] markRead:weakSelf.newsInfo.infoId];
            if ([weakSelf.delegate respondsToSelector:@selector(markRead)]) {
                [weakSelf.delegate markRead];
            }
        }
    }];
}

- (void)onIssueReport:(NFArticleDetailView *)detailView issueDesc:(NSString *)issueDescription extraData:(id)extraData {
    
}

- (void)onIssueReportFinished:(NFArticleDetailView *)detailView extraData:(id)extraData {
    
}

//- (void)onWebShareClick:(NFArticleDetailView *)detailView
//                   newsDetail:(NFNewsDetail *)detail
//                   type:(NSInteger)type
//              extraData:(id)extraData {
//
//}

- (void)back:(NFArticleGalleryViewController *)browserController extraData:(id)extraData {
    [browserController dismissViewControllerAnimated:YES completion:nil];
}
-(void)onWebShareClick:(NFArticleDetailView *)detailView newsDetail:(NSDictionary *)shareInfo type:(NSInteger)type extraData:(id)extraData{
    
    
    
    NSMutableDictionary *userInfo = [@{} mutableCopy];
    [userInfo setObject:[NSString stringWithFormat:@"youliao://youliao.163yun.com?infoId=%@&infoType=%@&producer=%@", shareInfo[@"infoId"], shareInfo[@"infoType"], shareInfo[@"producer"]] forKey:@"iOSOpenUrl"];
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

    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台(前提是在AppDelegate中成功注册）
     **/
    //创建分享参数
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//
//        [shareParams SSDKSetupShareParamsByText:[shareInfo objectForKey:@"title"]
//                                         images:[shareInfo objectForKey:@"thumbnail"]
//                                            url:[NSURL URLWithString:url]
//                                          title:[shareInfo objectForKey:@"summary"]
//                                           type:SSDKContentTypeWebPage];
//        //进行分享
//    [ShareSDK share:type?SSDKPlatformSubTypeWechatTimeline:SSDKPlatformSubTypeWechatSession
//             parameters:shareParams
//         //        [ShareSDK share:SSDKPlatformTypeSinaWeibo
//         //             parameters:shareParams
//         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//      
//             switch (state) {//判断分享是否成功
//                 case SSDKResponseStateSuccess:{
////                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
////                                                                         message:nil
////                                                                        delegate:nil
////                                                               cancelButtonTitle:@"确定"
////                                                               otherButtonTitles:nil];
////                     [alertView show];
//                     break;
//                 }
//                 case SSDKResponseStateFail:{
////                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
////                                                                         message:[NSString stringWithFormat:@"%@", error]
////                                                                        delegate:nil
////                                                               cancelButtonTitle:@"确定"
////                                                               otherButtonTitles:nil];
////                     [alertView show];
//                     break;
//                 }
//                 case SSDKResponseStateCancel:{
////                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
////                                                                         message:nil
////                                                                        delegate:nil
////                                                               cancelButtonTitle:@"确定"
////                                                               otherButtonTitles:nil];
////                     [alertView show];
//                     break;
//                 }
//                 default:
//                     break;
//             }
//         }];
//    
//    
    
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

