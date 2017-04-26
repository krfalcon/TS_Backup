//
//  EventShopView.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/2.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"

#import "DropDownListView.h"
#import "SearchTextView.h"
#import "EventEntity.h"

@protocol EventShopViewDelegate;

@interface EventShopView : TempletView<DropDownListViewDelegate, UIScrollViewDelegate, SearchTextViewDelegate>
{
    UIScrollView*                                           eventScrollView;
    CGFloat                                                 shifting;
    NSDateFormatter*                                        df;
    
    UIScrollView                                            *searchScrollView;
    SearchTextView                                          *searchView;
}

@property (weak, nonatomic)   id<EventShopViewDelegate>     delegate;
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

@protocol EventShopViewDelegate <NSObject>

- (void)eventShopView:(EventShopView *)eventShopView didStartDragScrollView:(UIScrollView *)scrollView;
- (void)eventShopView:(EventShopView *)eventShopView didTapEventButtonWithEventEntity:(EventEntity *)eventEntity;
- (void)eventShopView:(EventShopView *)eventShopView didTapDropDownListOption:(SortType)option;

- (void)eventShopView:(EventShopView *)eventShopView didSearch:(NSString *)string;
- (void)eventShopView:(EventShopView *)eventShopView didStartTexting:(NSString *)string;
- (void)eventShopView:(EventShopView *)eventShopView didEndTexting:(NSString *)string; 
- (void)eventShopViewDidRefresh;

@end