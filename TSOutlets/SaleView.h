//
//  SaleView.h
//  TSOutlets
//
//  Created by ZhuYiqun on 11/16/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "TempletView.h"

#import "DropDownListView.h"
#import "SearchTextView.h"
#import "EventEntity.h"

@protocol SaleViewDelegate;

@interface SaleView : TempletView<DropDownListViewDelegate, UIScrollViewDelegate, SearchTextViewDelegate>
{
    UIScrollView*                                           saleScrollView;
    CGFloat                                                 shifting;
    NSDateFormatter*                                        df;
    
    UIScrollView                                            *searchScrollView;
    SearchTextView                                          *searchView;
}

@property (weak, nonatomic)   id<SaleViewDelegate>          delegate;
@property (assign, nonatomic) int                           page;
@property (assign, nonatomic) int                           searchpage;
@property (retain, nonatomic) NSArray*                      eventListArray;
@property (retain, nonatomic) NSArray*                      eventSearchArray;

- (void)refreshSelf;
- (void)createEventListWithEventEntityArray;

- (void)addSearchList;
- (void)removeSearchList;
- (void)didSearch;

@end

@protocol SaleViewDelegate <NSObject>

- (void)saleView:(SaleView *)saleView didStartDragScrollView:(UIScrollView *)scrollView;
- (void)saleView:(SaleView *)saleView didTapEventButtonWithEventEntity:(EventEntity *)eventEntity;
- (void)saleView:(SaleView *)saleView didTapDropDownListOption:(SortType)option;

- (void)saleView:(SaleView *)saleView didSearch:(NSString *)string;
- (void)saleView:(SaleView *)saleView didStartTexting:(NSString *)string;
- (void)saleView:(SaleView *)saleView didEndTexting:(NSString *)string;
- (void)saleViewDidRefresh;

@end