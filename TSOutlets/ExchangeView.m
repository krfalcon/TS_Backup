//
//  SaleView.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/16/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "ExchangeView.h"
#import "MJRefresh.h"

#define buttonHeight 130.0f

@implementation ExchangeView

- (void)initView {
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    exScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight + 60 * self.scale, self.frame.size.width, self.frame.size.height - (self.titleHeight + 60))];
    [exScrollView setDelegate:self];
    [self addSubview:exScrollView];
    
    DropDownListView *ddlView = [[DropDownListView alloc] initWithFrame:CGRectMake(0, self.titleHeight, 155 * self.scale, 60 * self.scale) andSelections:3 andColor:ThemeYellow];
    [ddlView setDelegate:self];
    [self addSubview:ddlView];
    
    searchView = [[SearchTextView alloc] initWithFrame:CGRectMake(160 * self.scale, self.titleHeight, exScrollView.frame.size.width - 170 * self.scale, 60 * self.scale) andColor:ThemeYellow_255_142_107];
    [searchView setDelegate:self];
    [self addSubview:searchView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"updateExchange" object:nil];
    
    //[exScrollView addHeaderWithTarget:self action:@selector(refresh)];
}

- (void)refresh {
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeViewDidRefresh)]) {
        [_delegate exchangeViewDidRefresh];
    }
}

- (void)refreshSelf {
    //[exScrollView headerEndRefreshing];
    
    [self createEventListWithExchangeEntityArray];
}

- (void)createEventListWithExchangeEntityArray {
    for (id d in exScrollView.subviews) {
        if (![d isMemberOfClass:[MJRefreshHeaderView class]]) [d removeFromSuperview];
    }
    //[[eventScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _page = 0;
    shifting = 0;
    
    [self addListButton];
}

- (void)addListButton {
    if (_eventListArray.count == 0) return;
    
    if (_page * 10 + 10 < _eventListArray.count) {
        for (int i = 0; i < 10; i++) {
            ExchangeEntity *ety = (ExchangeEntity *)[_eventListArray objectAtIndex:i + _page * 10];
            [exScrollView addSubview:[self createListButtonWithFrame:CGRectMake(30 * self.scale, (10 + i * (buttonHeight + 20) + _page * 1200) * self.scale + shifting, self.frame.size.width - 60 * self.scale, buttonHeight * self.scale) andShopEntity:ety andTag:i + _page * 10]];
        }
        
        _page += 1;
        [exScrollView setContentSize:CGSizeMake(exScrollView.frame.size.width, _page * 1400 * self.scale + 130 * self.scale)];
    } else if (_page * 10 < _eventListArray.count) {
        for (int i = _page * 10; i < _eventListArray.count; i++) {
            ExchangeEntity *ety = (ExchangeEntity *)[_eventListArray objectAtIndex:i];
            [exScrollView addSubview:[self createListButtonWithFrame:CGRectMake(30 * self.scale, (10 + i * (buttonHeight + 20)) * self.scale + shifting, self.frame.size.width - 60 * self.scale, buttonHeight * self.scale) andShopEntity:ety andTag:i]];
        }
        
        _page += 1;
        [exScrollView setContentSize:CGSizeMake(exScrollView.frame.size.width, _eventListArray.count * 140 * self.scale + 130 * self.scale > exScrollView.frame.size.height ? _eventListArray.count * 140 * self.scale + 130 * self.scale : exScrollView.frame.size.height + 1)];
    } else {
        return;
    }
}

- (UIButton *)createListButtonWithFrame:(CGRect)frame andShopEntity:(ExchangeEntity *)exchangeEntity andTag:(int)tag{
    UIButton *eventView = [[UIButton alloc] initWithFrame:frame];
    eventView.clipsToBounds = YES;
    [eventView setTag:tag];
    [exScrollView addSubview:eventView];
    
    //        UIView *eventView = [[UIView alloc] initWithFrame:CGRectMake(20 * self.scale, 10 * self.scale + i * 120 * self.scale, self.frame.size.width - 40 * self.scale, buttonHeight * self.scale)];
    //        eventView.clipsToBounds = YES;
    //        [eventScrollView addSubview:eventView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5 * self.scale , 5 * self.scale , eventView.frame.size.width - 10 * self.scale , eventView.frame.size.height)];
    backView.layer.cornerRadius = backView.frame.size.width / 20;
    backView.layer.masksToBounds = YES;
    backView.userInteractionEnabled = NO;
    backView.backgroundColor = ThemeYellow_255_235_216;
    backView.tag = -1;
    [eventView addSubview:backView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0 * self.scale, 0, eventView.frame.size.width , 35 * self.scale)];
    titleView.layer.cornerRadius = 35.f / 2 * self.scale;
    titleView.userInteractionEnabled = NO;
    titleView.backgroundColor = ThemeYellow;
    [eventView addSubview:titleView];
    
    UILabel *chName = [[UILabel alloc] initWithFrame:titleView.bounds];
    [chName setBackgroundColor:AbsoluteClear];
    [chName setText:exchangeEntity.title];
    [chName setTextAlignment:NSTextAlignmentCenter];
    [chName setTextColor:AbsoluteWhite];
    [chName setFont:[UIFont boldSystemFontOfSize:20 * self.scale]];
    [eventView addSubview:chName];

    
    UILabel *onlinePointLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0 * self.scale + backView.frame.size.width / 2 , 30 * self.scale, backView.frame.size.width / 2, eventView.frame.size.height - 50 * self.scale)];
    [onlinePointLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    [onlinePointLabel setBackgroundColor:AbsoluteClear];
    [onlinePointLabel setText:[NSString stringWithFormat:@"线上积分%@",exchangeEntity.needOnlinePoint]];
    [onlinePointLabel setTextColor:ThemeRed_103_014_014];
    [onlinePointLabel setFont:[UIFont systemFontOfSize:18 * self.scale]];
    [eventView addSubview:onlinePointLabel];
    
    UILabel *offlinePointLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0 * self.scale + backView.frame.size.width / 2 , 55 * self.scale, backView.frame.size.width / 2, eventView.frame.size.height - 50 * self.scale)];
    [offlinePointLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    [offlinePointLabel setBackgroundColor:AbsoluteClear];
    [offlinePointLabel setText:[NSString stringWithFormat:@"线下积分%@",exchangeEntity.needOfflinePoint]];
    [offlinePointLabel setTextColor:ThemeRed_103_014_014];
    [offlinePointLabel setFont:[UIFont systemFontOfSize:18 * self.scale]];
    [eventView addSubview:offlinePointLabel];
    
    if (exchangeEntity.listPicUrl) {
        MDIncrementalImageView *imageView = [[MDIncrementalImageView alloc] initWithFrame:CGRectMake( 25 * self.scale, 45 * self.scale, 77.5f * self.scale, 77.5f * self.scale)];
        [imageView setImageUrl:[NSURL URLWithString:exchangeEntity.listPicUrl]];
        imageView.layer.cornerRadius = imageView.frame.size.width / 9;
        imageView.layer.masksToBounds = YES;
        [imageView setShowLoadingIndicatorWhileLoading:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [eventView addSubview:imageView];
    } else {
        UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake( 25 * self.scale, 45 * self.scale, 77.5f * self.scale, 77.5f * self.scale)];
        [logoImage setImage:[UIImage imageNamed:@"Gift"]];
        [logoImage setContentMode:UIViewContentModeScaleAspectFill];
        [eventView addSubview:logoImage];
    }
    
    UIImageView *needImage = [[UIImageView alloc] initWithFrame:CGRectMake( 97.5 * self.scale, 43 * self.scale, 42.5f * self.scale, 42 * self.scale)];
    [needImage setImage:[UIImage imageNamed:@"Required-big"]];
    [needImage setContentMode:UIViewContentModeScaleAspectFill];
    [eventView addSubview:needImage];
    
    [eventView addTarget:self action:@selector(tappedEventButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return eventView;
}

- (void)tappedEventButton:(UIButton *)button {
    ExchangeEntity *exchangeEntity = (ExchangeEntity *)[_eventListArray objectAtIndex:button.tag];
    [searchView hideKeyboard];
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeView:didTapEventButtonWithExchangeEntity:)]) {
        [_delegate exchangeView:self didTapEventButtonWithExchangeEntity:exchangeEntity];
    }
}

#pragma mark - Search Bar

- (void)addSearchList {
    if (!searchScrollView) {
        
        _searchpage = 0;
        
        searchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight + 60, self.frame.size.width, self.frame.size.height - self.titleHeight - 60)];
        [searchScrollView setBackgroundColor:AbsoluteWhite];
        [searchScrollView setShowsVerticalScrollIndicator:NO];
        [searchScrollView setDelegate:self];
        [self addSubview:searchScrollView];
        
    }
}

- (void)removeSearchList {
    [searchScrollView removeFromSuperview];
    searchScrollView  =  nil;
}

- (void)didSearch {
    _searchpage = 0;
    
    [[searchScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [searchScrollView setContentSize:CGSizeMake(searchScrollView.frame.size.width, searchScrollView.frame.size.height)];
    
    [self addSearchButton];
}

- (void)addSearchButton {
    if (_eventSearchArray.count == 0) return;
    
    if (_searchpage * 10 + 10 < _eventSearchArray.count) {
        for (int i = 0; i < 10; i++) {
            ExchangeEntity *ety = (ExchangeEntity *)[_eventSearchArray objectAtIndex:i + _searchpage * 10];
            [searchScrollView addSubview:[self createListButtonWithFrame:CGRectMake(20 * self.scale, (10 + i * (buttonHeight + 20) + _searchpage * 1200) * self.scale + shifting, self.frame.size.width - 40 * self.scale, buttonHeight * self.scale) andShopEntity:ety andTag:i + _searchpage * 10]];
        }
        
        _searchpage += 1;
        [searchScrollView setContentSize:CGSizeMake(searchScrollView.frame.size.width, _searchpage * 1500)];
    } else if (_searchpage * 10 < _eventSearchArray.count) {
        for (int i = _searchpage * 10; i < _eventSearchArray.count; i++) {
            ExchangeEntity *ety = (ExchangeEntity *)[_eventSearchArray objectAtIndex:i];
            [searchScrollView addSubview:[self createListButtonWithFrame:CGRectMake(20 * self.scale, (10 + i * (buttonHeight + 20) + _searchpage * 1200) * self.scale + shifting, self.frame.size.width - 40 * self.scale, buttonHeight * self.scale) andShopEntity:ety andTag:i]];
        }
        
        _searchpage += 1;
        [searchScrollView setContentSize:CGSizeMake(searchScrollView.frame.size.width, _eventSearchArray.count / 2 * 300 + 380)];
    } else {
        return;
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeView:didStartDragScrollView:)]) {
        [_delegate exchangeView:self didStartDragScrollView:scrollView ];
    }
    
    if ([scrollView isEqual:exScrollView]) {
        if (exScrollView.contentSize.height - exScrollView.contentOffset.y < exScrollView.frame.size.height * 2) {
            [self addListButton];
        }
    } else if ([scrollView isEqual:searchScrollView]){
        if (searchScrollView.contentSize.height - searchScrollView.contentOffset.y < searchScrollView.frame.size.height * 2) {
            [self addSearchButton];
        }
    }
}

#pragma mark - Search Delegate

- (void)searchTextView:(SearchTextView *)searchTextView didChange:(NSString *)searchText
{
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeView:didSearch:)]) {
        [_delegate exchangeView:self didSearch:searchText];
    }
}

- (void)searchTextView:(SearchTextView *)searchTextView didStartTexting:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeView:didStartTexting:)]) {
        [_delegate exchangeView:self didStartTexting:searchText];
    }
}

- (void)searchTextView:(SearchTextView *)searchTextView didEndTexting:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeView:didEndTexting:)]) {
        [_delegate exchangeView:self didEndTexting:searchText];
    }
}

#pragma mark - DDL Delegate

- (void)dropDownListView:(DropDownListView *)dropDownListView didTapOption:(SortType)option {
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeView:didTapDropDownListOption:)]) {
        [_delegate exchangeView:self didTapDropDownListOption:option];
    }
}
/*
- (void)updateExchange:(NSNotification*) notification
{
    [exScrollView removeFromSuperview];
     = [MemberCoreDataHelper getHistoryEntity];
    [self createScoreHistoryWithScoreHistoryArray];
}*/

@end
