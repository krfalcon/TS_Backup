//
//  WiFiViewController.m
//  TSOutlets
//
//  Created by KDC on 1/28/16.
//  Copyright © 2016 奚潇川. All rights reserved.
//

#import "WiFiViewController.h"

@interface WiFiViewController ()

@end

@implementation WiFiViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    if (!wifiView) {
        wifiView = [[WifiView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:wifiView];
        [wifiView getWifiInfoWithString:[ArticleCoreDataHelper getWifiInfo]];
        
        self.currentView = wifiView;
    }
}

@end
