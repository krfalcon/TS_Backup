//
//  OfflineDetailViewController.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/12.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "OfflineDetailViewController.h"

@interface OfflineDetailViewController ()

@end

@implementation OfflineDetailViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
        rawOfflineHistoryArray = nil;
        [offlinePointDetailView removeFromSuperview];
    
        offlinePointDetailView = [[OfflinePointDetailView alloc] initWithFrame:self.view.bounds];
        //[onlinePointDetailView setDelegate:self];
        [self.view addSubview:offlinePointDetailView];
        
        self.currentView = offlinePointDetailView;

            rawOfflineHistoryArray = [MemberCoreDataHelper getOfflineHistory];
            originOfflineHistoryArray = [rawOfflineHistoryArray sortedArrayUsingComparator:^NSComparisonResult(OfflineHistoryEntity *obj1, OfflineHistoryEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.tradeTime compare:obj1.tradeTime];
                return result;
            }];
            
            offlinePointDetailView.offlineHistoryListArray = originOfflineHistoryArray;

        [offlinePointDetailView getInfo:nil];
}

@end
