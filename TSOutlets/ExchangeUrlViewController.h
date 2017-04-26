//
//  ExchangeUrlViewController.h
//  TSOutlets
//
//  Created by KDC on 3/23/16.
//  Copyright © 2016 krfalcon. All rights reserved.
//
#import "MotherViewController.h"

#import <UIKit/UIKit.h>
#import "ExchangeUrlView.h"
#import "ExchangeHistoryEntity.h"
#import "MemberEntity.h"

@interface ExchangeUrlViewController : MotherViewController
{
    ExchangeUrlView*                exchangeUrlView;
}

@property(retain,nonatomic) ExchangeHistoryEntity                          *exchangeHistoryEntity;

@end
