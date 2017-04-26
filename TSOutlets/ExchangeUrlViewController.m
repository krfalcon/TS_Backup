//
//  ExchangeUrlViewController.m
//  TSOutlets
//
//  Created by KDC on 3/23/16.
//  Copyright © 2016 krfalcon. All rights reserved.
//

#import "ExchangeUrlViewController.h"

@interface ExchangeUrlViewController ()

@end

@implementation ExchangeUrlViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    MemberEntity *memberEntity = [MemberCoreDataHelper getMemberEntity];
    
    if (!exchangeUrlView) {
        exchangeUrlView = [[ExchangeUrlView alloc] initWithFrame:self.view.bounds];
        exchangeUrlView.exchangeTelephone = memberEntity.exchangeTelephone;
        exchangeUrlView.exchangePlace = memberEntity.exchangePlace;
        [exchangeUrlView getInfo:_exchangeHistoryEntity];
        [self.view addSubview:exchangeUrlView];
        
    }
}

@end
