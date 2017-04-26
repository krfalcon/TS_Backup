//
//  ParentViewController.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/1.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

//#import <UIKit/UIKit.h>

#import "TSOutlets-Swift.h"
#import "AppDelegate.h"

#import "NavigationView.h"
#import "WheelView.h"
#import "AlertView.h"
#import "TipView.h"

#import "GuideViewController.h"
#import "MemberViewController.h"

#import "IndexViewController.h"
#import "ShopViewController.h"
#import "ShopInfoViewController.h"
#import "EventViewController.h"
#import "EventInfoViewController.h"
#import "EventThemeViewController.h"
#import "VideoViewController.h"
#import "GameViewController.h"
#import "GameWheelViewController.h"
#import "SetViewController.h"
#import "SetFeedbackViewController.h"
#import "AboutUsViewController.h"
#import "ServiceViewController.h"
#import "SaleViewController.h"
#import "ExchangeViewController.h"
#import "ExchangeInfoViewController.h"
#import "ExchangeUrlViewController.h"
#import "ItemViewController.h"
#import "ItemInfoViewController.h"
#import "CollectionViewController.h"
#import "MessageViewController.h"
#import "MemberInfoViewController.h"
#import "MemberRegisterViewController.h"
#import "OnlineDetailViewController.h"
#import "SigninRulerViewController.h"
#import "OfflineDetailViewController.h"
#import "LocationViewController.h"
#import "ReplyViewController.h"
#import "BrowserViewController.h"
#import "WiFiViewController.h"
#import "MapViewController.h"

@interface ParentViewController : UIViewController
<
BasicInfoAPIToolDelegate,

MotherViewControllerDelegate,
NavigationViewDelegate,
WheelViewDelegate,
MemberViewControllerDelegate
>
{
    NavigationView          *navi;
    WheelView               *wheel;
    TipView                 *tip;
    
    UIButton                *hideButton;
    TempletView             *viewControllerContainer;
    
    MotherViewController    *currentViewController;
    MotherViewController    *nextViewController;
    NSMutableArray          *viewControllerArray;
    
    NSDictionary            *apiDictionary;
    NSDictionary            *appInfoDic;
    
    BOOL                    loginStatus;
    BOOL                    BindStatus;
    BOOL                    animating;
    BOOL                    ifLatestVersion;
}

- (void)handleLog;
- (void)lookForMessageCount;

@end
