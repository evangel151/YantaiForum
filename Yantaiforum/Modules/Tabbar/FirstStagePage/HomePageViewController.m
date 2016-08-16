//
//  HomePageViewController.m
//  Yantaiforum
//
//  Created by sunxb on 16/7/21.
//  Copyright © 2016年 sunxb. All rights reserved.
//

#import "HomePageViewController.h"
#import <SVProgressHUD.h>
#import "HomePageBannerView.h"

#import "Mod_HomePage.h"
#import "Mod_MyFollows.h"
#import "Mod_HotActivity.h"

#import "MJPullTableView.h"
#import <SVProgressHUD.h>
#import "HomePageListCell.h"
#import "HomePageFocusBtnView.h"
#import "HTMLViewController.h"
#import "MyFollowsView.h"
#import "HotActivityView.h"

#import <RESideMenu/RESideMenu.h>

static CGFloat cellHeight = 80.0;

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    MJPullTableView * rootTableView;
    
    UIScrollView * rootScrollView;
    
    Mod_HomePage * homePageMod;
    
    NSMutableArray * bannerImgArr;
    NSMutableArray * bannerTextArr;
    
    UIView * topControlView;
    
    NSInteger preBtn;
    
    CGFloat preOffSet;//记录上次的偏移
    CGFloat startOffSet;
    CGFloat endOffSet;
    
}
@end

@implementation HomePageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.isRootPage = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    bannerImgArr = [[NSMutableArray alloc] init];
    bannerTextArr = [[NSMutableArray alloc] init];
    
    [self loadTopPageBtn];
    [self loadRootScrollView];
    [self startNetWorking];
    
    // Do any additional setup after loading the view.
}

- (void)loadNavigationBarView {
    [super loadNavigationBarView];
    UIImageView * titleImg = [[UIImageView alloc] initWithFrame:CGRectMake((__Screen_Width-164)/2.0, kStatusBarHeight, 164, 44)];
    titleImg.image = [UIImage imageNamed:@"navi_logo_164x44_"];
    [self.navbarView addSubview:titleImg];
    
    UIButton * iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(10, kStatusBarHeight+12, 20, 20);
    iconBtn.layer.cornerRadius = 10;
    iconBtn.layer.masksToBounds = YES;
    iconBtn.backgroundColor = [UIColor greenColor];
    iconBtn.tag = 2000;
    [iconBtn addTarget:self action:@selector(clickedOnNavBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navbarView addSubview:iconBtn];
    
    UIButton * weatherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weatherBtn.frame = CGRectMake(__Screen_Width-30, kStatusBarHeight+12, 20, 20);
    weatherBtn.layer.cornerRadius = 10;
    weatherBtn.layer.masksToBounds = YES;
    weatherBtn.backgroundColor = [UIColor redColor];
    weatherBtn.tag = 2001;
    [weatherBtn addTarget:self action:@selector(clickedOnNavBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navbarView addSubview:weatherBtn];
}

- (void)clickedOnNavBtn:(UIButton *)btn {
    if (btn.tag == 2000) {
        [self.sideMenuViewController presentLeftMenuViewController];
    }
    else if (btn.tag == 2001) {
        
    }
}

- (void)loadTopPageBtn {
    topControlView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarViewHeight, ScreenWidth, 30)];
    topControlView.userInteractionEnabled = YES;
    [self.view addSubview:topControlView];
    CGFloat topBtnWidth = ScreenWidth/3.0;
    NSArray * topTextArr = @[@"今日头条",@"我的关注",@"热门活动"];
    
    for (int i = 0; i < 3; i ++) {
        UIButton * topBtn = [[UIButton alloc] initWithFrame:CGRectMake(topBtnWidth*i, 0, topBtnWidth, 30)];
        [topBtn setTitle:topTextArr[i] forState:UIControlStateNormal];
        topBtn.tag = 1000+i;
        [topBtn addTarget:self action:@selector(clickedOnTopBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [topBtn setTitleColor:color(45, 160, 233) forState:UIControlStateNormal];
            topBtn.titleLabel.font = Font14;
        }
        else {
            [topBtn setTitleColor:color_717171 forState:UIControlStateNormal];
            topBtn.titleLabel.font = Font12;
        }
        [topControlView addSubview:topBtn];
        
    }
}

- (void)clickedOnTopBtn:(UIButton *)button {
    
    if (button.tag-1000 == preBtn) {
        return;
    }
    
    for (UIButton * subBtn in topControlView.subviews) {
        if (subBtn.tag == button.tag) {
            [subBtn setTitleColor:color(45, 160, 233) forState:UIControlStateNormal];
            [UIView animateWithDuration:0.2 animations:^{
                subBtn.transform = CGAffineTransformMakeScale(1.2,1.2);
                
            } completion:^(BOOL finished) {
                subBtn.transform = CGAffineTransformMakeScale(1,1);
                subBtn.titleLabel.font = Font14;
            }];
        }
        else {
            [subBtn setTitleColor:color_717171 forState:UIControlStateNormal];
            subBtn.titleLabel.font = Font12;
            
        }
    }
    rootScrollView.contentOffset = CGPointMake(ScreenWidth*(button.tag-1000), 0);
    preBtn = button.tag-1000;
    
    if (button.tag == 1001) {
        [self startFollowsNetWorking];
    }
    if (button.tag == 1002) {
        [self startHotActivity];
    }
    
}

#pragma mark 我的关注数据请求
- (void)startFollowsNetWorking {
    [YTHUD hudShow];
    NSString * apiStr = @"http://magapp.ytbbs.com/pro_group_contentattention?_token=3308211df41e3681029bb3d51b3a24e3&build=9.3.3.0&clienttype=ios&deviceid=E6A86C3B-D768-4A51-90F4-1FD04B51978C&network=WiFi&p=1&step=20&version=51";
    [YTNetRequest getRequestAPI:apiStr params:nil succeedBlock:^(NSURLSessionDataTask *task, id object) {
        Mod_MyFollows * followsMod = [[Mod_MyFollows alloc] initWithResponseJSONObject:object];
        MyFollowsView * myFollowsView = [[MyFollowsView alloc] initWithFrame:CGRectMake(__Screen_Width, 0, __Screen_Width, __Height_noTab)];
        myFollowsView.dataArr = [[NSArray alloc] initWithArray:followsMod.list];
        [myFollowsView followsViewLoadData];
        [rootScrollView addSubview:myFollowsView];
        [YTHUD hudHidden];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YTHUD hudHidden];
    }];
}

#pragma mark 热门活动
- (void)startHotActivity {
     [YTHUD hudShow];
    NSString * apiStr = @"http://magapp.ytbbs.com/pro_cms_activitylist?_token=3308211df41e3681029bb3d51b3a24e3&build=9.3.3.0&clienttype=ios&deviceid=E6A86C3B-D768-4A51-90F4-1FD04B51978C&network=WiFi&p=1&step=20&version=51";
    [YTNetRequest getRequestAPI:apiStr params:nil succeedBlock:^(NSURLSessionDataTask *task, id object) {
        Mod_HotActivity * hotActivityMod = [[Mod_HotActivity alloc] initWithResponseJSONObject:object];
        HotActivityView * hotActivityView = [[HotActivityView alloc] initWithFrame:CGRectMake(__Screen_Width*2, 0, __Screen_Width, __Height_noTab)];
        hotActivityView.dataArr = [[NSArray alloc] initWithArray:hotActivityMod.list];
        [hotActivityView loadHotActivityView];
        [rootScrollView addSubview:hotActivityView];
        [YTHUD hudHidden];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YTHUD hudHidden];
    }];
}

#pragma mark 添加底部scrollView
- (void)loadRootScrollView {
    rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarViewHeight+30, ScreenWidth, __Height_noTab-30)];
    rootScrollView.backgroundColor = [UIColor clearColor];
    rootScrollView.contentSize = CGSizeMake(ScreenWidth*3, 0);
    rootScrollView.pagingEnabled = YES;
    rootScrollView.showsVerticalScrollIndicator = NO;
    rootScrollView.showsHorizontalScrollIndicator = NO;
    rootScrollView.delegate = self;
    [self.view addSubview:rootScrollView];
    
    rootTableView = [[MJPullTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, __Height_noTab-30)];
    rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rootTableView.backgroundColor = [UIColor clearColor];
    rootTableView.rowHeight = cellHeight;
    rootTableView.delegate = self;
    rootTableView.dataSource = self;
    rootTableView.hidden = YES;
    [rootScrollView addSubview:rootTableView];
    
}


#pragma mark 数据请求
- (void)startNetWorking {
    [YTHUD hudShow];
    NSString * apiStr= @"http://magapp.ytbbs.com/pro_index_home?_token=3308211df41e3681029bb3d51b3a24e3&build=9.3.3.0&catid=10&clienttype=ios&deviceid=E6A86C3B-D768-4A51-90F4-1FD04B51978C&network=WiFi&p=1&step=20&version=51";
    
    [YTNetRequest getRequestAPI:apiStr params:nil succeedBlock:^(NSURLSessionDataTask *task, id object) {
        homePageMod = [[Mod_HomePage alloc] initWithResponseJSONObject:object];
        [self loadRootTableViewBanner];
        [rootTableView reloadData];
        rootTableView.hidden = NO;
        [YTHUD hudHidden];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [YTHUD hudHidden];
    }];
}

- (void)loadRootTableViewBanner {
    for (Mod_HomePageBanner * bannerMod in homePageMod.jump_j1) {
        [bannerImgArr addObject:bannerMod.picurl];
        [bannerTextArr addObject:bannerMod.name];
//        NSLog(@"%@",bannerMod.picurl);
    }
    HomePageBannerView * bannerView = [[HomePageBannerView alloc] initWithFrame:CGRectMake(0, kNavBarViewHeight, ScreenWidth, 200) imageArr:bannerImgArr textArr:bannerTextArr];
    bannerView.bannerBlock = ^(NSInteger tapIndex){
        Mod_HomePageBanner * tapBannerModel = homePageMod.jump_j1[tapIndex];
        
        [self pushNewController:@"HTMLViewController" params:(NSMutableDictionary *)@{@"params_HTML":[NSString stringWithFormat:@"%@%@",YTHTTP_HEAD,tapBannerModel.jump_url]}];
    };
    rootTableView.tableHeaderView = bannerView;
}


#pragma mark tableView的delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return homePageMod.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"homePageCell";
    static NSString * btnCellID = @"focusBtnCell";
    if (indexPath.section == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:btnCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:btnCellID];
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth/2.0-1, ScreenWidth, 1)];
            lineView.backgroundColor = color(233, 233, 233);
            [cell.contentView addSubview:lineView];
        }
        HomePageFocusBtnView * focusBtnView = [[HomePageFocusBtnView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2.0) dataArr:homePageMod.jump_j3];
        [cell.contentView addSubview:focusBtnView];
        return cell;
    }
    else {
        NSArray * cellArr = [[NSBundle mainBundle] loadNibNamed:@"HomePageListCell" owner:self options:nil];
        HomePageListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = cellArr[0];
        }
        cell.model = homePageMod.list[indexPath.row];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ScreenWidth/2.0;
    }
    else {
        return cellHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        header.backgroundColor = [UIColor clearColor];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0;
    }
    return 0;
}

#pragma mark scrollView的delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == rootScrollView) {
        NSInteger index = scrollView.contentOffset.x/ScreenWidth;
        if (index == preBtn) {
            return;
        }
        for (UIButton * subBtn in topControlView.subviews) {
            if (subBtn.tag == 1000+index) {
                [subBtn setTitleColor:color(45, 160, 233) forState:UIControlStateNormal];
                [UIView animateWithDuration:0.2 animations:^{
                    subBtn.transform = CGAffineTransformMakeScale(1.2,1.2);
                    
                } completion:^(BOOL finished) {
                    subBtn.transform = CGAffineTransformMakeScale(1,1);
                    subBtn.titleLabel.font = Font14;
                }];
            }
            else {
                [subBtn setTitleColor:color_717171 forState:UIControlStateNormal];
                subBtn.titleLabel.font = Font12;
                
            }
        }
        preBtn = index;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == rootTableView) {
        // navigation & tabbar的效果
        if (preOffSet > scrollView.contentOffset.y && scrollView.contentOffset.y > 0) { // 下拉
            [UIView animateWithDuration:0.3 animations:^{
                [self.tabBarController.tabBar setFrame:CGRectMake(0, ScreenHeight-49, ScreenWidth, 49)];
                self.navbarView.frame = CGRectMake(0, 0, ScreenWidth, 64);
                topControlView.frame = CGRectMake(0, 64, ScreenWidth, 30);
                rootScrollView.frame = CGRectMake(0, kNavBarViewHeight+30, ScreenWidth, __Height_noTab-30);
                rootTableView.frame = CGRectMake(0, 0, ScreenWidth, __Height_noTab-30);
                self.navbarView.frame = CGRectMake(0, 0, ScreenWidth, 64);
                topControlView.frame = CGRectMake(0, 64, ScreenWidth, 30);
                self.navbarView.alpha = 1;
                self.titleLbl.alpha = 1;
            }];
        }
        else if(preOffSet < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) { // 上滑
            [UIView animateWithDuration:0.3 animations:^{
                [self.tabBarController.tabBar setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 49)];
                rootScrollView.frame = CGRectMake(0, 50, ScreenWidth, __Height_noTab-30+50);
                rootTableView.frame = CGRectMake(0, 0, ScreenWidth, __Height_noTab-30+50);
                self.navbarView.frame = CGRectMake(0, -44, ScreenWidth, 64);
                topControlView.frame = CGRectMake(0, 20, ScreenWidth, 30);
                self.navbarView.alpha = 0.9;
                self.titleLbl.alpha = 0;
                
            }];
        }
        preOffSet = scrollView.contentOffset.y;
        NSLog(@"-----%f",scrollView.contentOffset.y);
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == rootTableView) {
        NSLog(@"%f----%f---%f",ScreenHeight,self.tabBarController.tabBar.frame.origin.y,self.tabBarController.tabBar.frame.size.height);
        startOffSet = scrollView.contentOffset.y;
    }
//    NSLog(@"-!~~~---%f",scrollView.contentOffset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == rootTableView) {
        // end > start 上
        endOffSet = scrollView.contentOffset.y;
        
    }
//    NSLog(@"++++++%f",scrollView.contentOffset.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
