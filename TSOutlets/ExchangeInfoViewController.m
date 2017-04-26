//
//  ExchangeInfoViewController.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/20/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "ExchangeInfoViewController.h"

@interface ExchangeInfoViewController ()

@end

@implementation ExchangeInfoViewController

#pragma mark - Init View
- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    memberAPI = [[MemberAPITool alloc] init];
    _memberEntity   = [memberAPI getMemberEntity];
    
    if (!exchangeInfoView) {
        exchangeInfoView = [[ExchangeInfoView alloc] initWithFrame:self.view.bounds];
        [exchangeInfoView setDelegate:self];
        [exchangeInfoView setExchangeEntity:_exchangeEntity];
        [exchangeInfoView getInfo:_memberEntity];
        [self.view addSubview:exchangeInfoView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasExchanged) name:@"hasExchanged" object:nil];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"shouldRecordLog" object:[NSString stringWithFormat:@"Event: %@", _exchangeEntity.exchangeId]];
    }
}
/*
- (void)delayExchanged {
    [NSTimer scheduledTimerWithTimeInterval:10
                                     target:self
                                   selector:@selector(hasExchanged)
                                   userInfo:nil
                                    repeats:NO];
}*/

- (void)hasExchanged {
    [self popViewController];
    [memberAPI getExchangeHistory];
    //[self pushViewControllerWithViewControllerType:ViewControllerTypeExchange andParameter:nil];
}

#pragma mark - ExchangeInfo Views Delegate

- (void)exchangeInfoView:(ExchangeInfoView *)exchangeInfoView didTapEventButtonWithEventEntity:(ExchangeEntity *)exchangeEntity {
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:exchangeEntity, @"entity", nil];
    [self pushViewControllerWithViewControllerType:ViewControllerTypeExchangeInfo andParameter:parameter];
}

- (void)exchangeInfoView:(ExchangeInfoView *)exchangeInfoView didTapExchangeButtonWithEventEntity:(ExchangeEntity *)exchangeEntity {
    [memberAPI exchangeInfoViewDidTapExchangeWithExchangeEntity:exchangeEntity];
}

@end
