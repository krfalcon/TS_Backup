//
//  ExchangeInfoView.h
//  TSOutlets
//
//  Created by ZhuYiqun on 11/20/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "TempletView.h"

#import "EventEntity.h"
#import "CarouselScrollView.h"
#import "ExchangeEntity.h"
#import "MemberEntity.h"

@protocol ExchangeInfoViewDelegate;

@interface ExchangeInfoView : TempletView<UIScrollViewDelegate>
{
    UIScrollView                    *exchangeInfoScrollView;
}

- (void)getInfo:(MemberEntity *)memberEntity;

@property (weak,nonatomic)  id<ExchangeInfoViewDelegate>            delegate;
@property (retain,nonatomic) ExchangeEntity                         *exchangeEntity;
@property (retain, nonatomic) MemberEntity                          *memberEntity;

@end

@protocol ExchangeInfoViewDelegate <NSObject>

- (void)exchangeInfoView:(ExchangeInfoView *)exchangeInfoView didTapEventButtonWithEventEntity:(ExchangeEntity *)exchangeEntity;
- (void)exchangeInfoView:(ExchangeInfoView *)exchangeInfoView didTapExchangeButtonWithEventEntity:(ExchangeEntity *)exchangeEntity;


@end
