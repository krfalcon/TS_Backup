//
//  ExchangeHistoryView.h
//  TSOutlets
//
//  Created by KDC on 15/11/25.
//  Copyright © 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"
#import "MemberCoreDataHelper.h"
#import "ExchangeHistoryEntity.h"

@protocol ExchangeHistoryViewDelegate;

@interface ExchangeHistoryView : TempletView<UIScrollViewDelegate>

{
    UIScrollView*               ehScrollView;
    NSDateFormatter*            df;
    NSDateFormatter*            df2;
}

@property (weak, nonatomic)  id<ExchangeHistoryViewDelegate>        delegate;
@property (strong, nonatomic) ExchangeHistoryEntity*                exchangeHistoryEntity;
@property (retain, nonatomic) NSArray*                              exchangeHistoryListArray;
@property(assign,nonatomic)   BOOL                                  hasExchange;

- (void)createExchangeHistoryWithExchangeHistoryArray;
- (void)createNoExchange;
- (void)refreshSelf;

@end

@protocol ExchangeHistoryViewDelegate <NSObject>

- (void)exchangeHistoryView:(ExchangeHistoryView *)exchangeHistoryView didStartDragScrollView:(UIScrollView *)scrollView;
- (void)exchangeHistoryViewDidTappedButton:(ExchangeHistoryView *)exchangeHistoryView withType:(ViewControllerType)type andParameter:(NSDictionary *)parameter;

- (void)exchangeHistoryView:(ExchangeHistoryView *)exchangeHistoryView didTapEventButtonWithExchangeEntity:(ExchangeEntity *)ExchangeEntity;
- (void)exchangeHistoryView:(ExchangeHistoryView *)exchangeHistoryView didTapisDealButtonWithExchangeHistoryEntity:(ExchangeHistoryEntity *)ety;

@end
