//
//  OnlineDetailViewController.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/12.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "OnlineDetailViewController.h"

@interface OnlineDetailViewController ()

@end

@implementation OnlineDetailViewController

#pragma mark - InitView

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    memberAPI = [[MemberAPITool alloc] init];
    [memberAPI getOnlinePoints];
    [memberAPI getOnlinePointsHistory];
    _memberEntity = [memberAPI getMemberEntity];
    
    if (!onlinePointDetailView) {
        onlinePointDetailView = [[OnlinePointDetailView alloc] initWithFrame:self.view.bounds];
        //[onlinePointDetailView setDelegate:self];
        [self.view addSubview:onlinePointDetailView];
        
        onlinePointDetailView.scorehistoryArray = [[MemberCoreDataHelper getHistoryArray]
                                                   sortedArrayUsingComparator:^NSComparisonResult(HistoryEntity *obj1, HistoryEntity *obj2) {
                                                       NSComparisonResult result = [obj2.historyid compare:obj1.historyid];
                                                       return result;
                                                   }];
        
        //NSLog(@"%@",onlinePointDetailView.scorehistoryArray);
        //[onlinePointDetailView createScoreHistoryWithScoreHistoryArray];
        self.currentView = onlinePointDetailView;
        
        [onlinePointDetailView getInfo:_memberEntity];
        
    }
}

@end
