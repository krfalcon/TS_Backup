//
//  ParentViewController.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/1.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建coredata线程池
    [SingleCase singleCase].coredataOperationQueue = [[NSOperationQueue alloc] init];
    [SingleCase singleCase].coredataOperationQueue.name = @"coredata处理线程";
    [SingleCase singleCase].coredataOperationQueue.maxConcurrentOperationCount = 1;
    
    //添加Notification
    
    [self addNotificationObservers];
    
    //API
    
    [self initAPITools];
    
    //加载顶部和底部部件
    
    [self initHeadAndBottom];
    
    if ([apiDictionary[@"member"] checkAppGuideSign:GuideSign_App]) {
        //        GuideViewController *guideViewController = [[GuideViewController alloc] init];
        //        [self addChildViewController:guideViewController];
        //        [self.view addSubview:guideViewController.view];
    } else {
        GuideViewController *guideViewController = [[GuideViewController alloc] init];
        [self addChildViewController:guideViewController];
        [self.view addSubview:guideViewController.view];
    }
    
    //检测登陆状态
    
    loginStatus = [apiDictionary[@"member"] getLoginStatus];
    
    BindStatus = [apiDictionary[@"member"] getBindStatus];
    
    //ifLatestVersion = [self checkVersion];
    
    if (loginStatus) { [apiDictionary[@"member"] confirmAuthentication]; }
    
    //更新或初始化基础数据
    
    [apiDictionary[@"basic"] checkVersionOfApp];
    
    NSString *dateTime = [apiDictionary[@"member"] getLastUpdateDate];
    if (dateTime.length > 0) {
        [self initView];
        
        [apiDictionary[@"basic"] updateBasicInfoByDate:dateTime];
        [self lookForMessageCount];
        
    } else {
        [viewControllerContainer showLoadingView];
        
        [apiDictionary[@"basic"] getBasicInfoWithDeviceInfo:[apiDictionary[@"member"] getDeviceInfo]];
    }
    
    //处理未上传成功的日志
    
    [self handleLog];
    
}

- (void)initHeadAndBottom {
    viewControllerContainer = [[TempletView alloc] initWithFrame:self.view.bounds];
    [viewControllerContainer setBackgroundColor:AbsoluteWhite];
    [viewControllerContainer setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:viewControllerContainer];
    
    navi = [[NavigationView alloc] initWithFrame:self.view.bounds andColor:1 andTitle:@"首页"];
    [navi setDelegate:self];
    [self.view addSubview:navi];
    
    wheel = [[WheelView alloc] initWithFrame:self.view.bounds andType:@"ShopList" andColor:@"Blue"];
    [wheel setDelegate:self];
    [self.view addSubview:wheel];
    
    hideButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.2, self.view.frame.size.height * 0.94, self.view.frame.size.width * 0.6, self.view.frame.size.height * 0.06)];
    [hideButton setAlpha:0];
    //[hideButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
    [hideButton setUserInteractionEnabled:YES];
    [hideButton addTarget:self action:@selector(tappedHideButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideButton];
}

- (void)initView {
    IndexViewController *indexViewController = [[IndexViewController alloc] init];
    [indexViewController setDelegate:self];
    [indexViewController setThemeColor:@"Blue"];
    [self addChildViewController:indexViewController];
    [viewControllerContainer addSubview:indexViewController.view];
    
    currentViewController = indexViewController;
    
    viewControllerArray = [[NSMutableArray alloc] init];
    [viewControllerArray addObject:currentViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
    if ([self.view window] == nil)// 是否是正在使用的视图
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

#pragma mark - API Tools

- (void)initAPITools {
    apiDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[[BasicInfoAPITool alloc] init], @"basic",
                     [[MemberAPITool alloc] init], @"member",
                     [[ServiceAPITool alloc] init], @"service",
                     [[LogAPITool alloc] init], @"log", nil];
    
    [apiDictionary[@"basic"] setDelegate:self];
}

#pragma mark - Notification Observers

- (void)addNotificationObservers {
    //show tip observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTipViewWithMessage:) name:@"shouldShowTip" object:nil];
    //show record log observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordLog:) name:@"shouldRecordLog" object:nil];
    //member login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberLogin) name:@"memberLogin" object:nil];
    //member logout
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberLogout) name:@"memberLogout" object:nil];
    //need login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberLoginAgain) name:@"needLoginAgain" object:nil];
    //upload getui clientid
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadGetuiClientid) name:@"uploadGetuiClientid" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookForMessageCount) name:@"getNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageCount:) name:@"getMessageList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notLatestVersion) name:@"notLatestVersion" object:nil];
}

#pragma mark - Handle Log

- (void)handleLog {
    [[SingleCase singleCase].coredataOperationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        [apiDictionary[@"log"] startUploadLog];
        if (loginStatus) {
            if ([apiDictionary[@"member"] checkFavoriteSync].length) {
                //NSLog(@"%@",[apiDictionary[@"member"] checkFavoriteSync]);
                [apiDictionary[@"member"] setFavoriteWithBrandID:[apiDictionary[@"member"] checkFavoriteSync]];
            }
            
            if (![apiDictionary[@"member"] checkMemberSync]) {
                MemberEntity *memberEntity = [apiDictionary[@"member"] getMemberEntity];
                [apiDictionary[@"member"] uploadMemberInfo:memberEntity];
                //if (memberEntity.portrait && !memberEntity.image) [apiDictionary[@"member"] uploadMemberPortrait:memberEntity.portrait];
            }
        }
    }]];
}

- (void)recordLog:(NSNotification *)notification {
    [apiDictionary[@"log"] addLogRecordWithModule:notification.object];
}

#pragma mark - Member Operation

- (void)memberLogin {
    loginStatus = YES;
}

- (void)memberBind {
    BindStatus = YES;
}

- (void)memberLogout {
    if (!loginStatus) {
        return;
    }
    if ([apiDictionary[@"member"] logoutMember]) {
        loginStatus = [apiDictionary[@"member"] getLoginStatus];
        [apiDictionary[@"member"] clearFavorite];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"登出成功！"];
        
        if ([currentViewController isMemberOfClass:[CollectionViewController class]] ||
            [currentViewController isMemberOfClass:[MemberInfoViewController class]] ||
            [currentViewController isMemberOfClass:[OfflineDetailViewController class]] ||
            [currentViewController isMemberOfClass:[MessageViewController class]] ||
            [currentViewController isMemberOfClass:[SigninRulerViewController class]] ||
            [currentViewController isMemberOfClass:[GameWheelViewController class]] ||
            [currentViewController isMemberOfClass:[ExchangeViewController class]] ||
            [currentViewController isMemberOfClass:[ReplyViewController class]]) {
            [self popToIndexViewController];
        }
    }
}

- (void)memberLoginAgain {
    if (!loginStatus) {
        return;
    }
    if ([apiDictionary[@"member"] logoutMember]) {
        loginStatus = [apiDictionary[@"member"] getLoginStatus];
        [apiDictionary[@"member"] clearFavorite];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"请重新登录！"];
        
        [self navigationViewDidTapMemberButton];
    }
}

- (void)uploadGetuiClientid {
    [apiDictionary[@"member"] uploadDeviceInfo];
}

- (void)lookForMessageCount {
    [apiDictionary[@"service"] getAllMessageCount];
}

- (void)getMessageCount:(NSNotification *)noti {
    if ([noti.object intValue] != 0 ) {
        [navi didGetMessage:YES];
    } else {
        [navi didGetMessage:NO];
    }
}

- (void)notLatestVersion {
    [navi didGetMessage:YES];
}

#pragma mark - View Controller Delegate

- (void)pushViewControllerWithViewControllerType:(ViewControllerType)viewControllerType andParameter:(NSDictionary *)parameter {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldHideKeyboard" object:nil];
    
    switch (viewControllerType) {
        case ViewControllerTypeCollection:
        case ViewControllerTypeMemberInfo:
        case ViewControllerTypeOffline:
        case ViewControllerTypeOnline:
        case ViewControllerTypeMessage:
        case ViewControllerTypeReply:
        case ViewControllerTypeFeedback:
        case ViewControllerTypetappedGameButton:
            if (!loginStatus) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"请先登录！"];
                [self navigationViewDidTapMemberButton];
                return;
            }
            break;
        default:
            break;
    }
    
    switch (viewControllerType) {
#pragma mark -- shop
        case ViewControllerTypeShopList:
        {
            ShopViewController *shopViewController = [[ShopViewController alloc] init];
            [shopViewController setDelegate:self];
            [shopViewController setThemeColor:@"Blue"];
            [self addChildViewController:shopViewController];
            
            if (parameter != nil) {
                shopViewController.category = [NSString stringWithFormat:@"%@", [parameter valueForKey:@"category"]];
            }
            
            [navi createNextNavigationBarWithColor:ThemeBlue andTitle:@"品牌中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"ShopList_Button2" andColor:@"Blue" andButtonType:@"5"];
            
            nextViewController = shopViewController;
            break;
        }
        case ViewControllerTypeShopInfo:
        {
            [navi createNextNavigationBarWithColor:ThemeBlue andTitle:@"品牌详情" andIsIndex:NO];
            
            ShopEntity *shopEntity = [parameter objectForKey:@"entity"];
            ShopInfoViewController *shopInfoViewController = [[ShopInfoViewController alloc] init];
            [shopInfoViewController setDelegate:self];
            [shopInfoViewController setThemeColor:@"Blue"];
            shopInfoViewController.shopEntity = shopEntity;
            [self addChildViewController:shopInfoViewController];
            
            if (shopEntity.tableSet) {
                [wheel createNewWheelViewWithType:@"ShopInfo_Food_Button2" andColor:@"Blue" andButtonType:@"5"];
            } else {
                [wheel createNewWheelViewWithType:@"ShopInfo_Button2" andColor:@"Blue" andButtonType:@"5"];
            }
            
            nextViewController = shopInfoViewController;
            break;
        }
#pragma mark -- event
        case ViewControllerTypeEventMallList:
        {
            EventViewController *eventViewController = [[EventViewController alloc] init];
            eventViewController.currentPage = 1;
            [eventViewController setDelegate:self];
            [eventViewController setThemeColor:@"Red"];
            [self addChildViewController:eventViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"活动中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"Event_Button3" andColor:@"Red" andButtonType:@"5"];
            
            nextViewController = eventViewController;
            
            break;
        }
        case ViewControllerTypeEventShopList:
        {
            EventViewController *eventViewController = [[EventViewController alloc] init];
            eventViewController.currentPage = 2;
            [eventViewController setDelegate:self];
            [eventViewController setThemeColor:@"Red"];
            [self addChildViewController:eventViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"活动中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"Event_Button4" andColor:@"Red" andButtonType:@"5"];
            
            nextViewController = eventViewController;
            
            break;
        }
        case ViewControllerTypeSale:
        {
            EventViewController *eventViewController = [[EventViewController alloc] init];
            eventViewController.currentPage = 3;
            [eventViewController setDelegate:self];
            [eventViewController setThemeColor:@"Red"];
            [self addChildViewController:eventViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"优惠" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"Event_Button5" andColor:@"Red" andButtonType:@"5"];
            
            nextViewController = eventViewController;
            
            break;
        }
        case ViewControllerTypeEventInfo:
        {
            EventEntity *eventEntity = [parameter objectForKey:@"entity"];
            EventInfoViewController *eventInfoViewController = [[EventInfoViewController alloc] init];
            [eventInfoViewController setEventEntity:eventEntity];
            [eventInfoViewController setDelegate:self];
            [eventInfoViewController setThemeColor:@"Red"];
            [self addChildViewController:eventInfoViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"品牌活动" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = eventInfoViewController;
            
            break;
        }
        case ViewControllerTypeEventTheme:
        {
            EventEntity *eventEntity = [parameter objectForKey:@"entity"];
            EventThemeViewController *eventThemeViewController = [[EventThemeViewController alloc] init];
            [eventThemeViewController setEventEntity:eventEntity];
            [eventThemeViewController setDelegate:self];
            [eventThemeViewController setThemeColor:@"Red"];
            [self addChildViewController:eventThemeViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"商场活动" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = eventThemeViewController;
            
            break;
        }
#pragma mark -- video
        case ViewControllerTypeVideo:
        {
            VideoViewController *videoViewController = [[VideoViewController alloc] init];
            [videoViewController setDelegate:self];
            [videoViewController setThemeColor:@"Red"];
            [self addChildViewController:videoViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"视频专区" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"Event_Button4" andColor:@"Red" andButtonType:@"3"];
            
            nextViewController = videoViewController;
            
            break;
        }
            
#pragma mark -- game
        case ViewControllerTypeGame:
        {
            GameViewController *gameViewController = [[GameViewController alloc] init];
            [gameViewController setDelegate:self];
            [gameViewController setThemeColor:@"Red"];
            [self addChildViewController:gameViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"游戏中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"Red" andButtonType:@"0"];
            
            nextViewController = gameViewController;
            
            break;
        }
            
#pragma mark -- gameButton
        case ViewControllerTypetappedGameButton:
        {
            GameWheelViewController *gamewheelViewController = [[GameWheelViewController alloc] init];
            [gamewheelViewController setDelegate:self];
            [gamewheelViewController setThemeColor:@"Red"];
            [self addChildViewController:gamewheelViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"幸运摩天轮" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"Red" andButtonType:@"0"];
            
            nextViewController = gamewheelViewController;
            
            break;
            
        }
            
#pragma mark -- service
        case ViewControllerTypeService:
        {
            ServiceViewController *serviceViewController = [[ServiceViewController alloc] init];
            [serviceViewController setDelegate:self];
            [serviceViewController setThemeColor:@"Yellow"];
            [self addChildViewController:serviceViewController];
            
            [navi createNextNavigationBarWithColor:ThemeYellow andTitle:@"服务中心" andIsIndex:NO];
            
            if (parameter) {
                [serviceViewController wheelViewTappedButton5];
                [wheel createNewWheelViewWithType:@"Service_Button5" andColor:@"Yellow" andButtonType:@"5"];
            } else {
                [wheel createNewWheelViewWithType:@"Service_Button4" andColor:@"Yellow" andButtonType:@"5"];
            }
            
            nextViewController = serviceViewController;
            
            break;
        }
        case ViewControllerTypeReply:
        {
            ReplyViewController *replyViewController = [[ReplyViewController alloc] init];
            [replyViewController setDelegate:self];
            [replyViewController setThemeColor:@"Yellow"];
            [self addChildViewController:replyViewController];
            
            [navi createNextNavigationBarWithColor:ThemeYellow andTitle:@"客服中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"Yellow" andButtonType:@"0"];
            
            nextViewController = replyViewController;
            
            break;
        }
#pragma mark -- item
        case ViewControllerTypeItemList:
        {
            ItemViewController *itemViewController = [[ItemViewController alloc] init];
            [itemViewController setDelegate:self];
            [itemViewController setThemeColor:@"Blue"];
            [self addChildViewController:itemViewController];
            
            [navi createNextNavigationBarWithColor:ThemeBlue andTitle:@"单品推荐" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = itemViewController;
            
            break;
        }
        case ViewControllerTypeItemInfo:
        {
            ItemEntity *itemEntity = [parameter objectForKey:@"entity"];
            ItemInfoViewController *itemInfoViewController = [[ItemInfoViewController alloc] init];
            [itemInfoViewController setItemEntity:itemEntity];
            [itemInfoViewController setDelegate:self];
            [itemInfoViewController setThemeColor:@"Blue"];
            [self addChildViewController:itemInfoViewController];
            
            [navi createNextNavigationBarWithColor:ThemeBlue andTitle:@"单品详情" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = itemInfoViewController;
            
            break;
        }
/*
#pragma mark -- sale
        case ViewControllerTypeSale:
        {
            SaleViewController *saleViewController = [[SaleViewController alloc] init];
            [saleViewController setDelegate:self];
            [saleViewController setThemeColor:@"Red"];
            [self addChildViewController:saleViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"优惠" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = saleViewController;
            
            break;
        }
*/
#pragma mark -- exchange
        case ViewControllerTypeExchange:
        {
            ExchangeViewController *exchangeViewController = [[ExchangeViewController alloc] init];
            exchangeViewController.currentPage = 1;
            [exchangeViewController setDelegate:self];
            [exchangeViewController setThemeColor:@"Yellow"];
            [self addChildViewController:exchangeViewController];
            
            [navi createNextNavigationBarWithColor:ThemeYellow andTitle:@"兑换中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"Exchange_Button3" andColor:@"Yellow" andButtonType:@"3"];
            
            nextViewController = exchangeViewController;
            
            break;
        }
            
        case ViewControllerTypeExchangeHistory:
        {
            ExchangeViewController *exchangeViewController = [[ExchangeViewController alloc] init];
            exchangeViewController.currentPage = 2;
            [exchangeViewController setDelegate:self];
            [exchangeViewController setThemeColor:@"Yellow"];
            [self addChildViewController:exchangeViewController];
            
            [navi createNextNavigationBarWithColor:ThemeYellow andTitle:@"兑换中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"Exchange_Button4" andColor:@"Yellow" andButtonType:@"4"];
            
            nextViewController = exchangeViewController;
            
            break;
        }
            
        case ViewControllerTypeExchangeInfo:
        {
            ExchangeEntity *exchangeEntity = [parameter objectForKey:@"entity"];
            ExchangeInfoViewController *exchangeInfoViewController = [[ExchangeInfoViewController alloc] init];
            [exchangeInfoViewController setExchangeEntity:exchangeEntity];
            [exchangeInfoViewController setDelegate:self];
            [exchangeInfoViewController setThemeColor:@"Yellow"];
            [self addChildViewController:exchangeInfoViewController];
            
            [navi createNextNavigationBarWithColor:ThemeYellow andTitle:@"兑换礼品" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = exchangeInfoViewController;
            
            break;
        }
            
        case ViewControllerTypeExchangeUrl:
        {
            ExchangeHistoryEntity *ety = [parameter objectForKey:@"entity"];
            ExchangeUrlViewController *exchangeUrlViewController = [[ExchangeUrlViewController alloc] init];
            [exchangeUrlViewController setExchangeHistoryEntity:ety];
            [exchangeUrlViewController setDelegate:self];
            [exchangeUrlViewController setThemeColor:@"Yellow"];
            [self addChildViewController:exchangeUrlViewController];
            
            [navi createNextNavigationBarWithColor:ThemeYellow andTitle:@"兑换二维码" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = exchangeUrlViewController;
            
            break;
        }
            

#pragma mark -- food
        case ViewControllerTypeFood:
        {
            FoodViewController *foodViewController = [[FoodViewController alloc] init];
            [foodViewController setDelegate:self];
            [foodViewController setThemeColor:@"Red"];
            [self addChildViewController:foodViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"餐饮排队" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = foodViewController;
            
            break;
        }
        case ViewControllerTypeFoodReserve:
        {
            [navi createNextNavigationBarWithColor:ThemeBlue andTitle:@"品牌详情" andIsIndex:NO];
            
            ShopEntity *shopEntity = [parameter objectForKey:@"entity"];
            ShopInfoViewController *shopInfoViewController = [[ShopInfoViewController alloc] init];
            [shopInfoViewController setDelegate:self];
            [shopInfoViewController setShopEntity:shopEntity];
            [shopInfoViewController setThemeColor:@"Blue"];
            [self addChildViewController:shopInfoViewController];
            
            [shopInfoViewController switchToFoodReserveView];
            
            [wheel createNewWheelViewWithType:@"ShopInfo_Food_Button4" andColor:@"Blue" andButtonType:@"5"];
            
            nextViewController = shopInfoViewController;
            break;
        }
#pragma mark -- collection
        case ViewControllerTypeCollection:
        {
            CollectionViewController *collectionViewController = [[CollectionViewController alloc] init];
            [collectionViewController setDelegate:self];
            [collectionViewController setThemeColor:@"Blue"];
            [self addChildViewController:collectionViewController];
            
            [navi createNextNavigationBarWithColor:ThemeBlue andTitle:@"我的收藏" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = collectionViewController;
            break;
        }
#pragma mark -- message
        case ViewControllerTypeMessage:
        {
            MessageViewController *messageViewController = [[MessageViewController alloc] init];
            [messageViewController setDelegate:self];
            [messageViewController setThemeColor:@"Red"];
            [self addChildViewController:messageViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"消息盒子" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = messageViewController;
            break;
        }
#pragma mark -- points
        case ViewControllerTypeOnlineDetail:
        {
            OnlineDetailViewController *pointsViewController = [[OnlineDetailViewController alloc] init];
            [pointsViewController setDelegate:self];
            [pointsViewController setThemeColor:@"Red"];
            [self addChildViewController:pointsViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"会员中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = pointsViewController;
            break;
        }
        case ViewControllerTypeOfflineDetail:
        {
            OfflineDetailViewController *pointsViewController = [[OfflineDetailViewController alloc] init];
            [pointsViewController setDelegate:self];
            [pointsViewController setThemeColor:@"Red"];
            [self addChildViewController:pointsViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"会员中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = pointsViewController;
            break;
        }
        case ViewControllerTypeSigninRuler:
        {
            SigninRulerViewController *signinRulerViewController = [[SigninRulerViewController alloc] init];
            [signinRulerViewController setDelegate:self];
            [signinRulerViewController setThemeColor:@"Red"];
            [self addChildViewController:signinRulerViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"签到规则" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = signinRulerViewController;
            break;
            
        }
#pragma mark -- member
        case ViewControllerTypeMemberInfo:
        {
            MemberInfoViewController *memberInfoViewController = [[MemberInfoViewController alloc] init];
            [memberInfoViewController setDelegate:self];
            [memberInfoViewController setThemeColor:@"Red"];
            [self addChildViewController:memberInfoViewController];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"member" forKey:@"type"];
            [memberInfoViewController initFirstViewWithParameter:dic];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"会员中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"Member_Button4" andColor:@"Red" andButtonType:@"5"];
            
            nextViewController = memberInfoViewController;
            break;
        }
        case ViewControllerTypeOnline:
        {
            MemberInfoViewController *memberInfoViewController = [[MemberInfoViewController alloc] init];
            [memberInfoViewController setDelegate:self];
            [memberInfoViewController setThemeColor:@"Red"];
            [self addChildViewController:memberInfoViewController];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"online" forKey:@"type"];
            [memberInfoViewController initFirstViewWithParameter:dic];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"会员中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"Member_Button3" andColor:@"Red" andButtonType:@"5"];
            
            nextViewController = memberInfoViewController;
            break;
            
        }
            
            
        case ViewControllerTypeOffline:
        {
            MemberInfoViewController *memberInfoViewController = [[MemberInfoViewController alloc] init];
            [memberInfoViewController setDelegate:self];
            [memberInfoViewController setThemeColor:@"Red"];
            [self addChildViewController:memberInfoViewController];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"offline" forKey:@"type"];
            [memberInfoViewController initFirstViewWithParameter:dic];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"会员中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"Member_Button2" andColor:@"Red" andButtonType:@"5"];
            
            nextViewController = memberInfoViewController;
            break;
        }
        case ViewControllerTypeRegister:
        {
            MemberRegisterViewController *memberRegisterViewController = [[MemberRegisterViewController alloc] init];
            [memberRegisterViewController setDelegate:self];
            [memberRegisterViewController setThemeColor:@"Red"];
            [self addChildViewController:memberRegisterViewController];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"register" forKey:@"type"];
            [memberRegisterViewController initFirstViewWithParameter:dic];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"会员中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = memberRegisterViewController;
            break;
        }
        case ViewControllerTypeReset:
        {
            MemberRegisterViewController *memberRegisterViewController = [[MemberRegisterViewController alloc] init];
            [memberRegisterViewController setDelegate:self];
            [memberRegisterViewController setThemeColor:@"Red"];
            [self addChildViewController:memberRegisterViewController];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:@"reset" forKey:@"type"];
            [memberRegisterViewController initFirstViewWithParameter:dic];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"会员中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = memberRegisterViewController;
            break;
        }
#pragma mark -- navigation
        case ViewControllerTypeLocation:
        {
            LocationViewController *locationViewController = [[LocationViewController alloc] init];
            [locationViewController setDelegate:self];
            [locationViewController setThemeColor:@"Yellow"];
            [self addChildViewController:locationViewController];
            
            [navi createNextNavigationBarWithColor:ThemeYellow andTitle:@"导航" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = locationViewController;
            break;
        }
#pragma mark -- browser
        case ViewControllerTypeBrowser:
        {
            BrowserViewController *browserViewController = [[BrowserViewController alloc] init];
            [browserViewController setDelegate:self];
            [browserViewController setThemeColor:@"Blue"];
            [self addChildViewController:browserViewController];
            
            [navi createNextNavigationBarWithColor:ThemeBlue andTitle:@"汤山旅游" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"Blue" andButtonType:@"0"];
            
            nextViewController = browserViewController;
            break;
        }
#pragma mark -- Wifi
        case ViewControllerTypeWifi:
        {
            WiFiViewController *wifiViewController = [[WiFiViewController alloc] init];
            [wifiViewController setDelegate:self];
            [wifiViewController setThemeColor:@"Yellow"];
            [self addChildViewController:wifiViewController];
            
            [navi createNextNavigationBarWithColor:ThemeYellow andTitle:@"Wifi上网" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = wifiViewController;
            break;
            
        }
            
#pragma mark -- Map
        case ViewControllerTypeMap:
        {
            ShopEntity *shopEntity = [parameter objectForKey:@"entity"];
            MapViewController *mapViewController = [[MapViewController alloc] init];
            [mapViewController setDelegate:self];
            [mapViewController setThemeColor:@"Blue"];
            mapViewController.shopEntity = shopEntity;
            [self addChildViewController:mapViewController];
            
            [navi createNextNavigationBarWithColor:ThemeBlue andTitle:@"位置" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"" andButtonType:@"0"];
            
            nextViewController = mapViewController;
            break;
            
        }
#pragma mark -- set
        case ViewControllerTypeSet:
        {
            SetViewController *setViewController = [[SetViewController alloc] init];
            [setViewController setDelegate:self];
            [setViewController setThemeColor:@"Red"];
            [self addChildViewController:setViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"设置中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"Red" andButtonType:@"0"];
            
            nextViewController = setViewController;
            
            break;
        }
        case ViewControllerTypeSetFeedback:
        {
            SetFeedbackViewController *setFeedbackViewController = [[SetFeedbackViewController alloc] init];
            [setFeedbackViewController setDelegate:self];
            [setFeedbackViewController setThemeColor:@"Red"];
            [self addChildViewController:setFeedbackViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"设置中心" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"Red" andButtonType:@"0"];
            
            nextViewController = setFeedbackViewController;
            
            break;
        }
        case ViewControllerTypeSetAboutUs:
        {
            AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc] init];
            [aboutUsViewController setDelegate:self];
            [aboutUsViewController setThemeColor:@"Red"];
            [self addChildViewController:aboutUsViewController];
            
            [navi createNextNavigationBarWithColor:ThemeRed andTitle:@"关于我们" andIsIndex:NO];
            [wheel createNewWheelViewWithType:@"" andColor:@"Red" andButtonType:@"0"];
            
            nextViewController = aboutUsViewController;
            
            break;
        }
            
        default:
            break;
    }
    
    animating = YES;
    
    [viewControllerContainer addSubview:nextViewController.view];
    [viewControllerArray addObject:nextViewController];
    nextViewController.view.transform =  CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
    [wheel wheelAnimation];
    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         currentViewController.view.transform = CGAffineTransformMakeTranslation(-80, 0);
                         nextViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                         [navi changeNavigationBarWithRatio:0.f];
                     }
                     completion:^(BOOL finished){
                         [navi changeNavigationBarAddArray];
                         currentViewController.view.userInteractionEnabled = NO;
                         currentViewController = nextViewController;
                         nextViewController = nil;
                         
                         animating = NO;
                     }];
}

- (void)popViewController {
    animating = YES;
    if (!nextViewController) {
        nextViewController = [viewControllerArray objectAtIndex:(viewControllerArray.count - 2)];
    }
    if (!navi.hasNew) {
        [navi createBeforeNavigationBar];
    }
    [wheel getPreWheelView];
    [wheel wheelAnimation];
    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         currentViewController.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
                         nextViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                         
                         [navi changeNavigationBarWithRatio:0.f];
                     } completion:^(BOOL finished){
                         [currentViewController willMoveToParentViewController:nil];
                         [currentViewController.view removeFromSuperview];
                         [currentViewController removeFromParentViewController];
                         [viewControllerArray removeLastObject];
                         
                         [navi changeNavigationBarDeleteArray];
                         
                         currentViewController = nextViewController;
                         currentViewController.view.userInteractionEnabled = YES;
                         nextViewController = nil;
                         
                         animating = NO;
                     }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldHideKeyboard" object:nil];
}

- (void)popViewControllerWithRatio:(float)ratio {
    animating = YES;
    if (!navi.hasNew) {
        [navi createBeforeNavigationBar];
    }
    if (!nextViewController) {
        nextViewController = [viewControllerArray objectAtIndex:(viewControllerArray.count - 2)];
    }
    [wheel getPreWheelView];
    [wheel wheelAnimationWithRatio:ratio];
    
    [navi changeNavigationBarWithRatio:ratio];
    
    nextViewController.view.transform = CGAffineTransformMakeTranslation(- 80 * ratio, 0);

    //NSLog(@"%f", ratio);
    if (ratio == 0) {
        [currentViewController willMoveToParentViewController:nil];
        [currentViewController.view removeFromSuperview];
        [currentViewController removeFromParentViewController];
        [viewControllerArray removeLastObject];
        
        [navi changeNavigationBarDeleteArray];
        
        currentViewController = nextViewController;
        currentViewController.view.userInteractionEnabled = YES;
        nextViewController = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldHideKeyboard" object:nil];
        animating = NO;
    } else if (ratio == 1) {
        animating = NO;
    }
}

- (void)popToIndexViewController {
    animating = YES;
    nextViewController = [viewControllerArray objectAtIndex:0];
    int l = (int)viewControllerArray.count - 1;
    for (int i = 1; i < l; i++) {
        [[viewControllerArray objectAtIndex:1] willMoveToParentViewController:nil];
        [[[viewControllerArray objectAtIndex:1] view] removeFromSuperview];
        [[viewControllerArray objectAtIndex:1] removeFromParentViewController];
        [viewControllerArray removeObjectAtIndex:1];
    }
    
    [navi createFirstNavigationBar];
    [wheel getFirstWheelView];
    [wheel wheelAnimation];
    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         currentViewController.view.transform =  CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
                         nextViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
                         
                         [navi changeNavigationBarWithRatio:0.f];
                     } completion:^(BOOL finished){
                         [currentViewController willMoveToParentViewController:nil];
                         [currentViewController.view removeFromSuperview];
                         [currentViewController removeFromParentViewController];
                         [viewControllerArray removeLastObject];
                         
                         [navi changeNavigationBarDeleteArray];
                         
                         currentViewController = nextViewController;
                         currentViewController.view.userInteractionEnabled = YES;
                         nextViewController = nil;
                         
                         animating = NO;
                     }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldHideKeyboard" object:nil];
}

- (void)wheelViewShouldHide {
    [wheel wheelHide];
}

- (void)tappedHideButton
{
    if (wheel.isShow) {
        [wheel wheelHide];
    } else {
        [wheel wheelShow];
    }
}

#pragma mark - Alert & Tip

- (void)alertViewShowWithTheme:(NSString *)theme andContent:(UIView *)content {
    AlertView *alertView = [[AlertView alloc] initWithFrame:self.view.frame andTheme:theme andContent:content];
    alertView.alpha = 0;
    [self.view addSubview:alertView];
    
    [UIView animateWithDuration:0.2 animations:^{alertView.alpha = 1;}];
}

- (void)showTipViewWithMessage:(NSNotification *)notification {
    if (![notification.object isEqualToString:tip.messageLabel.text]) {
        tip = [[TipView alloc]initWithMessage:[notification object] andColor:navi.backgroundColor];
        [tip showTipView];
    }
}

#pragma mark - API Delegate

- (void)didGetBasicInfo {
    //NSLog(@"%@", @"finish loading");
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^(){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"初始化完成！"];
        [viewControllerContainer hideLoadingView];
        
        [self initView];
    }];
}

- (void)didUpdateBasicInfo {
}

#pragma mark - Head & Foot Delegate

- (void)navigationViewDidTapBackButton:(NavigationView *)navigationView {
    if (!animating) [self popViewController];
}

- (void)navigationViewDidTapQRCodeButton:(NavigationView *)navigationView {
    if (!animating) [(IndexViewController *) currentViewController tappedQRCodeButton];
}

- (void)navigationViewDidTapMemberButton {
    if (!animating) {
        MemberViewController *memberViewController = [[MemberViewController alloc] init];
        memberViewController.themeColor = currentViewController.themeColor;
        memberViewController.delegate = self;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldHideKeyboard" object:nil];
        
        [self addChildViewController:memberViewController];
        [self.view addSubview:memberViewController.view];
    }
}

- (void)wheelDidShow {
    hideButton.alpha = 1;
}

- (void)wheelDidHide {
    hideButton.alpha = 0;
}

- (void)wheelViewDidTapButton1:(WheelView *)wheelView {
    [currentViewController wheelViewTappedButton1];
}
- (void)wheelViewDidTapButton2:(WheelView *)wheelView {
    [currentViewController wheelViewTappedButton2];
}
- (void)wheelViewDidTapButton3:(WheelView *)wheelView {
    [currentViewController wheelViewTappedButton3];
}
- (void)wheelViewDidTapButton4:(WheelView *)wheelView {
    [currentViewController wheelViewTappedButton4];
}
- (void)wheelViewDidTapButton5:(WheelView *)wheelView {
    [currentViewController wheelViewTappedButton5];
}

@end
