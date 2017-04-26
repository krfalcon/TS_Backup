//
//  SaleViewController.h
//  TSOutlets
//
//  Created by ZhuYiqun on 11/16/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//
#import "MotherViewController.h"

#import "EventEntity.h"
#import "SaleView.h"

@interface SaleViewController : MotherViewController<SaleViewDelegate>
{
    NSArray*                                            originShopEventArray;
    NSArray*                                            rawShopEventArray;
    
    NSDateFormatter*                                    df;
    
    SaleView*                                           saleView;
    NSString                                            *currentString;
}

@property(assign,nonatomic) int                         currentPage;

@end
