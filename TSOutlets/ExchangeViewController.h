//
//  SaleViewController.h
//  TSOutlets
//
//  Created by ZhuYiqun on 11/16/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//
#import "MotherViewController.h"

#import "NavigationView.h"
#import "EventEntity.h"
#import "ExchangeEntity.h"
#import "ExchangeView.h"
#import "ExchangeHistoryView.h"
#import "MemberAPITool.h"

@interface ExchangeViewController : MotherViewController<ExchangeViewDelegate,ExchangeHistoryViewDelegate>
{
    NSArray*                                            originExchangeArray;
    NSArray*                                            rawExchangeArray;
    NSArray*                                            originExchangeHistoryArray;
    
    NSDateFormatter*                                    df;
    
    ExchangeView*                                       exchangeView;
    ExchangeHistoryView*                                exchangeHistoryView;
    NSString                                            *currentString;
    
    NSDictionary                                        *apiDictionary;
    
    BOOL                                                loginStatus;
    MemberAPITool*                                      memberAPI;
}

@property(assign,nonatomic) int                         currentPage;


@end
