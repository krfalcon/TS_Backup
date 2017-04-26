//
//  EventViewController.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/2.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "MotherViewController.h"

#import "EventEntity.h"

#import "EventShopView.h"
#import "EventMallView.h"
#import "SaleView.h"


@interface EventViewController : MotherViewController<EventShopViewDelegate, EventMallViewDelegate, SaleViewDelegate>
{
    NSArray*                                            originShopEventArray;
    NSArray*                                            rawShopEventArray;
    
    NSArray*                                            originSaleEventArray;
    NSArray*                                            rawSaleEventArray;
    
    
    NSDateFormatter*                                    df;
    
    EventMallView*                                      eventMallView;
    EventShopView*                                      eventShopView;
    SaleView*                                           saleView;
    
    NSString                                            *currentString;
    NSString                                            *saleString;
}

@property(assign,nonatomic) int                         currentPage;

@end
