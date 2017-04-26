//
//  ExchangeInfoViewController.h
//  TSOutlets
//
//  Created by ZhuYiqun on 11/20/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "MotherViewController.h"

#import "EventEntity.h"
#import "ExchangeInfoView.h"
#import "ExchangeEntity.h"

#import "MemberAPITool.h"

@interface ExchangeInfoViewController : MotherViewController<ExchangeInfoViewDelegate>
{
    ExchangeInfoView*                                               exchangeInfoView;
    
    MemberAPITool*                                                  memberAPI;
}


@property(retain,nonatomic) ExchangeEntity                          *exchangeEntity;
@property (strong, nonatomic) MemberEntity                          *memberEntity;

@end
