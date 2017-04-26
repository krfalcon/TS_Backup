//
//  SaleView.h
//  TSOutlets
//
//  Created by ZhuYiqun on 11/19/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "TempletView.h"

#import "DropDownListView.h"
#import "SearchTextView.h"
#import "ExchangeEntity.h"

@protocol ExchangeViewDelegate;

@interface ExchangeView : TempletView<DropDownListViewDelegate, UIScrollViewDelegate, SearchTextViewDelegate>
{
    UIScrollView*                                           exScrollView;
    CGFloat                                                 shifting;
    NSDateFormatter*                                        df;
    
    UIScrollView                                            *searchScrollView;
    SearchTextView                                          *searchView;
}

@property (weak, nonatomic)   id<ExchangeViewDelegate>          delegate;
@property (assign, nonatomic) int                           page;
@property (assign, nonatomic) int                           searchpage;
@property (retain, nonatomic) NSArray*                      eventListArray;
@property (retain, nonatomic) NSArray*                      eventSearchArray;
@property (strong, nonatomic) ExchangeEntity*               exchangeEntity;

- (void)refreshSelf;
- (void)createEventListWithExchangeEntityArray;

- (void)addSearchList;
- (void)removeSearchList;
- (void)didSearch;

@end

@protocol ExchangeViewDelegate <NSObject>

- (void)exchangeView:(ExchangeView *)exchangeView didStartDragScrollView:(UIScrollView *)scrollView;
- (void)exchangeView:(ExchangeView *)exchangeView didTapEventButtonWithExchangeEntity:(ExchangeEntity *)ExchangeEntity;
- (void)exchangeView:(ExchangeView *)exchangeView didTapDropDownListOption:(SortType)option;

- (void)exchangeView:(ExchangeView *)exchangeView didSearch:(NSString *)string;
- (void)exchangeView:(ExchangeView *)exchangeView didStartTexting:(NSString *)string;
- (void)exchangeView:(ExchangeView *)exchangeView didEndTexting:(NSString *)string;
- (void)exchangeViewDidRefresh;

@end