//
//  ShopListView.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/3/18.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "ShopListView.h"
#import "MJRefresh.h"

@implementation ShopListView

#pragma mark - Create View

- (void)initView {
    _page = 0;
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight + 60, self.frame.size.width * 5 / 6, self.frame.size.height - self.titleHeight - 60)];
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height + 2)];
    [mainScrollView setShowsVerticalScrollIndicator:NO];
    [mainScrollView setDelegate:self];
    [mainScrollView setTag:-1];
    [self addSubview:mainScrollView];
    
    [mainScrollView addHeaderWithTarget:self action:@selector(refresh)];
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainScrollView.frame.size.width, 2 * self.scale)];
    [bottomLine setImage:[UIImage imageNamed:@"ShopListLine"]];
    [bottomLine setTag:-1];
    [mainScrollView addSubview:bottomLine];
    
    //side scroll view
    
    sideView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.size.width * 5 / 6, self.titleHeight, self.frame.size.width * 1 / 6, self.frame.size.height - self.titleHeight)];
    [sideView setShowsVerticalScrollIndicator:NO];
    [sideView setDelegate:self];
    [self addSubview:sideView];
    
    DropDownListView *ddlView = [[DropDownListView alloc] initWithFrame:CGRectMake(0, self.titleHeight, 100, 60) andSelections:0 andColor:ThemeBlue];
    [ddlView setDelegate:self];
    [self addSubview:ddlView];
    
    searchView = [[SearchTextView alloc] initWithFrame:CGRectMake(110, self.titleHeight, mainScrollView.frame.size.width - 115, 60) andColor:ThemeBlue_123_204_225];
    [searchView setDelegate:self];
    [self addSubview:searchView];
    
    [self createCategoryList];
}

- (void)refresh {
    if (_delegate && [_delegate respondsToSelector:@selector(shopListViewDidRefresh)]) {
        [_delegate shopListViewDidRefresh];
    }
}

- (void)refreshSelf {
    [mainScrollView headerEndRefreshing];
    
    [self resetListScrollView];
}

- (void)resetListScrollView {
    _page = 0;
    
    for (id d in mainScrollView.subviews) {
        if (![d isMemberOfClass:[MJRefreshHeaderView class]]) [d removeFromSuperview];
    }
    
    //[[mainScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainScrollView.frame.size.width, 2 * self.scale)];
    [bottomLine setImage:[UIImage imageNamed:@"ShopListLine"]];
    [bottomLine setTag:-1];
    [mainScrollView addSubview:bottomLine];
    
    [self addListButton];
}

- (void)addListButton {
    if (_shopListArray.count == 0) return;
    
    if (_page * 10 + 10 < _shopListArray.count) {
        for (int i = 0; i < 10; i++) {
            ShopEntity *ety = (ShopEntity *)[_shopListArray objectAtIndex:i + _page * 10];
            [mainScrollView addSubview:[self createListButtonWithFrame:CGRectMake(0, i * 85 * self.scale + _page * 850 * self.scale, mainScrollView.frame.size.width, 85 * self.scale) andShopEntity:ety andTag:i + _page * 10]];
        }
        
        _page += 1;
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, _page * 850 * self.scale)];
    } else if (_page * 10 < _shopListArray.count) {
        for (int i = _page * 10; i < _shopListArray.count; i++) {
            ShopEntity *ety = (ShopEntity *)[_shopListArray objectAtIndex:i];
            [mainScrollView addSubview:[self createListButtonWithFrame:CGRectMake(0, i * 85 * self.scale, mainScrollView.frame.size.width, 85 * self.scale) andShopEntity:ety andTag:i]];
        }
        
        _page += 1;
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, _shopListArray.count * 85 * self.scale + 120 * self.scale)];
    } else {
        return;
    }
    
    if (mainScrollView.contentSize.height < mainScrollView.frame.size.height) { [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height + 1)]; }
}

- (UIView *)createListButtonWithFrame:(CGRect)frame andShopEntity:(ShopEntity *)ety andTag:(NSInteger)tag {
    UIView *listButton = [[UIView alloc] initWithFrame:frame];
    [listButton setTag:tag + 100];
    //[listButton setBackgroundColor:[UIColor yellowColor]];
    
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * 0.15f, frame.size.height)];
    //[collectButton setBackgroundColor:ThemeBlueLight];
    [collectButton setExclusiveTouch:YES];
    [collectButton setTag:tag];
    [collectButton addTarget:self action:@selector(tappedCollectButton:) forControlEvents:UIControlEventTouchUpInside];
    [listButton addSubview:collectButton];
    
    if (ety.hasCollected) {
        UIImageView *collectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShopListView_Collected"]];
        [collectImage setFrame:CGRectMake(0, 0, collectButton.frame.size.width * 0.7f, collectButton.frame.size.width * 0.7f)];
        [collectImage setCenter:collectButton.center];
        [collectButton addSubview:collectImage];
    } else {
        UIImageView *collectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShopListView_UnCollected"]];
        [collectImage setFrame:CGRectMake(0, 0, collectButton.frame.size.width * 0.7f, collectButton.frame.size.width * 0.7f)];
        [collectImage setCenter:collectButton.center];
        [collectButton addSubview:collectImage];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width * 0.15f, 0, frame.size.width * 0.85f, frame.size.height)];
    [button setTag:tag];
    [button addTarget:self action:@selector(tappedShopInfoButton:) forControlEvents:UIControlEventTouchUpInside];
    [listButton addSubview:button];
    //图标
    
    if (ety.logoImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * 0.15f, frame.size.height * 0.1f, frame.size.width * 0.31f, frame.size.width * 0.31f * 220 / 320 )];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:[UIImage imageWithData:ety.logoImage]];
        [listButton addSubview:imageView];
    } else {
        MDIncrementalImageView *imageView = [[MDIncrementalImageView alloc] initWithFrame:CGRectMake(frame.size.width * 0.17f, frame.size.height * 0.1f, frame.size.width * 0.31f, frame.size.width * 0.31f * 220 / 320 )];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setShowLoadingIndicatorWhileLoading:YES];
        [imageView setImageUrl:[NSURL URLWithString:ety.logoUrl]];
        [imageView setDelegate:self];
        //[imageView setTag:(int)avc];
        [listButton addSubview:imageView];
    }
    
    if ([_eventShopID containsObject:ety.shopID]){
        UIImageView *imageView =  [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * 0.4f, frame.size.height * 0.0f, frame.size.width * 0.14f, frame.size.height * 0.4f)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImage:[UIImage imageNamed:@"ShopListView_Event"]];
        [listButton addSubview:imageView];
    }
    
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width * 0.5f, frame.size.height * 0.6, frame.size.width * 0.5f, frame.size.height * 0.2)];
    [categoryView setUserInteractionEnabled:NO];
    [categoryView setClipsToBounds:YES];
    [listButton addSubview:categoryView];
    
    NSArray *categoryArray = [ety.category componentsSeparatedByString:@","];
    for (int i=0; i < categoryArray.count; i++) {
        UIImageView *categoryImage = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.height * 0.2 + 2 * self.scale) * i, 0, frame.size.height * 0.2, frame.size.height * 0.2)];
        [categoryImage setImage:[self getCategoryImageWithCategory:[categoryArray[i] intValue]]];
        [categoryView addSubview:categoryImage];
    }
    
    UILabel *chName = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * 0.5f, frame.size.height * 0.2, frame.size.width * 0.5f, frame.size.height * 0.2)];
    [chName setBackgroundColor:[UIColor clearColor]];
    [chName setText:ety.chName];
    [chName setTextColor:ThemeBlue];
    [chName setFont:[UIFont systemFontOfSize:18.f]];
    [listButton addSubview:chName];
    
    UILabel *enName = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * 0.5f, frame.size.height * 0.4, frame.size.width * 0.5f, frame.size.height * 0.2)];
    [enName setBackgroundColor:[UIColor clearColor]];
    [enName setText:ety.enName];
    [enName setTextColor:ThemeBlue];
    [enName setFont:[UIFont systemFontOfSize:11.f]];
    [listButton addSubview:enName];
    
    NSMutableAttributedString *str;
    if (ety.locationArea.length > 0) {
        str = [[NSMutableAttributedString alloc] initWithString:ety.locationArea];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22.0] range:NSMakeRange(0, 1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(1, str.length - 1)];
    } else {
        str = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    UILabel *locationArea = [[ UILabel alloc] initWithFrame:CGRectMake(frame.size.width * 0.7f, frame.size.height * 0.7, frame.size.width * 0.3f, frame.size.height * 0.25)];
    [locationArea setBackgroundColor:[UIColor clearColor]];
    [locationArea setAttributedText:str];
    [locationArea setTextColor:ThemeBlue];
    //[locationArea setFont:[UIFont systemFontOfSize:20]];
    [listButton addSubview:locationArea];
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 2)];
    [bottomLine setImage:[UIImage imageNamed:@"ShopListLine"]];
    [listButton addSubview:bottomLine];
    
    return listButton;
}

#pragma mark - Search Bar

- (void)addSearchList {
    if (!searchScrollView) {
        
        _searchpage = 0;
        
        searchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight + 60, self.frame.size.width, self.frame.size.height - self.titleHeight - 60)];
        [searchScrollView setBackgroundColor:AbsoluteWhite];
        [searchScrollView setShowsVerticalScrollIndicator:NO];
        [searchScrollView setDelegate:self];
        [searchScrollView setTag:-1];
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
    
    if (_shopSearchArray.count != 0) {
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, searchScrollView.frame.size.width, 2)];
        [bottomLine setImage:[UIImage imageNamed:@"ShopListLine"]];
        [bottomLine setTag:-1];
        [searchScrollView addSubview:bottomLine];
    }
    
    [self addSearchButton];
}

- (void)addSearchButton {
    if (_shopSearchArray.count == 0) return;
    
    if (_searchpage * 10 + 10 < _shopSearchArray.count) {
        for (int i = 0; i < 10; i++) {
            ShopEntity *ety = (ShopEntity *)[_shopSearchArray objectAtIndex:i + _searchpage * 10];
            [searchScrollView addSubview:[self createListButtonWithFrame:CGRectMake(0, i * 100 + _searchpage * 1000, searchScrollView.frame.size.width, 100) andShopEntity:ety andTag:i + _searchpage * 10]];
        }
        
        _searchpage += 1;
        [searchScrollView setContentSize:CGSizeMake(searchScrollView.frame.size.width, _searchpage * 1000)];
    } else if (_searchpage * 10 < _shopSearchArray.count) {
        for (int i = _searchpage * 10; i < _shopSearchArray.count; i++) {
            ShopEntity *ety = (ShopEntity *)[_shopSearchArray objectAtIndex:i];
            [searchScrollView addSubview:[self createListButtonWithFrame:CGRectMake(0, i * 100, searchScrollView.frame.size.width, 100) andShopEntity:ety andTag:i]];
        }
        
        _searchpage += 1;
        [searchScrollView setContentSize:CGSizeMake(searchScrollView.frame.size.width, _shopSearchArray.count * 100 + 280)];
    } else {
        return;
    }
}

#pragma mark - Category

- (void)createCategoryList {
    [[sideView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *sideArray = @[@"All",@"Clothes",@"Casual",@"Sport",@"Outdoors",@"Kid",@"Sweater",@"Underwear",@"Shoes",@"Bags",@"Bedding",@"Ornament",@"Makeup",@"Cooking",@"Food"];
    
    NSArray *catagoryArray = @[@"7",@"9",@"10",@"39",@"8",@"11",@"14",@"12",@"13",@"15",@"40",@"16",@"42",@"41",@"17"];
    float h = 10;
    
    //NSLog(@"%f", sideView.frame.size.height);
    
    for (int i=0;i<catagoryArray.count;i++){
        [sideView addSubview:[self createCategoryButtonWithFrame:CGRectMake(0, h, sideView.frame.size.width, 50 * self.scale) andCategoryType:sideArray[i] andTag:[catagoryArray[i] intValue]]];
        h += 55 * self.scale;
    }
    
    
    /*for (NSString *str in sideArray) {
     
     [sideView addSubview:[self createCategoryButtonWithFrame:CGRectMake(0, h, sideView.frame.size.width, 50 * self.scale) andCategoryType:str andTag:i]];
     
     i++;
     h += 55 * self.scale;
     }*/
    
    [sideView setContentSize:CGSizeMake(sideView.frame.size.width, h)];
}

- (void)showCategoryList:(BOOL)show {
    [sideView setAlpha:show ? 1 : 0];
}

- (UIView *)createCategoryButtonWithFrame:(CGRect)frame andCategoryType:(NSString *)type andTag:(int)tag{
    UIView *categoryView = [[UIView alloc] initWithFrame:frame];
    
    UIButton *categoryButton = [[UIButton alloc] initWithFrame:categoryView.bounds];
    [categoryButton setExclusiveTouch:YES];
    [categoryButton setTag:tag];
    [categoryButton addTarget:self action:@selector(tappedCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
    [categoryView addSubview:categoryButton];
    
    UIImageView *categoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_NotSelected", type]]];
    [categoryImage setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height *0.65)];
    [categoryImage setContentMode:UIViewContentModeScaleAspectFit];
    [categoryImage setCenter:CGPointMake(categoryView.frame.size.width / 2 + 2 * self.scale, 25 * self.scale)];
    [categoryButton addSubview:categoryImage];
    
    UIView *categoryCover = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width + frame.size.height, frame.size.height)];
    categoryCover.layer.cornerRadius = frame.size.height / 2;
    [categoryCover setClipsToBounds:YES];
    [categoryCover setBackgroundColor:ThemeBlue];
    [categoryCover setTag:-999];
    [categoryView addSubview:categoryCover];
    
    UIImageView *categoryCoverImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_Selected", type]]];
    [categoryCoverImage setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 0.65)];
    [categoryCoverImage setContentMode:UIViewContentModeScaleAspectFit];
    [categoryCoverImage setTag:-998];
    [categoryCoverImage setCenter:CGPointMake(- frame.size.width / 2 + 2 * self.scale, 25 * self.scale)];
    [categoryCover addSubview:categoryCoverImage];
    
    if ([type isEqualToString:@"All"] && _category == nil) {
        [categoryCover setTag:-997];
        [categoryCover setFrame:CGRectMake(0, 0, frame.size.width + frame.size.height, frame.size.height)];
        
        [categoryCoverImage setCenter:CGPointMake(frame.size.width / 2 + 2 * self.scale, 25 * self.scale)];
    } else if (tag == [_category integerValue]) {
        [categoryCover setTag:-997];
        [categoryCover setFrame:CGRectMake(0, 0, frame.size.width + frame.size.height, frame.size.height)];
        
        [categoryCoverImage setCenter:CGPointMake(frame.size.width / 2 + 2 * self.scale, 25 * self.scale)];
    }
    
    return categoryView;
}

- (UIImage *)getCategoryImageWithCategory:(int)category {
    switch (category) {
            /*case 8:
             return [UIImage imageNamed:@"Famous_Icon"];
             break;
             */
        case 9:
            return [UIImage imageNamed:@"Clothes_Icon"];
            break;
        case 10:
            return [UIImage imageNamed:@"Casual_Icon"];
            break;
        case 39:
            return [UIImage imageNamed:@"Sport_Icon"];//sport
            break;
        case 8:
            return [UIImage imageNamed:@"Outdoors_Icon"];//outdoors
            break;
        case 11:
            return [UIImage imageNamed:@"Kid_Icon"];
            break;
        case 14:
            return [UIImage imageNamed:@"Sweater_Icon"];
            break;
        case 12:
            return [UIImage imageNamed:@"Underwear_Icon"];
            break;
        case 13:
            return [UIImage imageNamed:@"Shoes_Icon"];
            break;
        case 15:
            return [UIImage imageNamed:@"Bags_Icon"];
            break;
        case 40:
            return [UIImage imageNamed:@"Bedding_Icon"];//bedding
            break;
        case 16:
            return [UIImage imageNamed:@"Ornament_Icon"];
            break;
        case 42:
            return [UIImage imageNamed:@"Makeup_Icon"];//makeup
            break;
        case 41:
            return [UIImage imageNamed:@"Cooking_Icon"];//cooking
            break;
        case 17:
            return [UIImage imageNamed:@"Food_Icon"];
            break;
        default:
            return [UIImage imageNamed:@"Ornament_Icon"];
            break;
    }
}

#pragma mark - Button Events

- (void)tappedShopInfoButton:(UIButton *)sender {
    ShopEntity *ety;
    if ([[[sender superview] superview] isEqual:mainScrollView]) {
        ety = [_shopListArray objectAtIndex:sender.tag];
    } else {
        ety = [_shopSearchArray objectAtIndex:sender.tag];
    }
    [searchView hideKeyboard];
    if (_delegate && [_delegate respondsToSelector:@selector(shopListView:didTapShopButtonWithShopEntity:)]) {
        [_delegate shopListView:self didTapShopButtonWithShopEntity:ety];
    }
}

- (void)tappedCollectButton:(UIButton *)sender {
    ShopEntity *ety;
    if ([[[sender superview] superview] isEqual:mainScrollView]) {
        ety = [_shopListArray objectAtIndex:sender.tag];
    } else {
        ety = [_shopSearchArray objectAtIndex:sender.tag];
    }
    [searchView hideKeyboard];
    if (_delegate && [_delegate respondsToSelector:@selector(shopListViewDidTapCollectButtonWithShopEntity:andTag:)]) {
        [_delegate shopListViewDidTapCollectButtonWithShopEntity:ety andTag:sender.tag + 100];
    }
}

- (void)tappedCategoryButton:(UIButton *)sender {
    UIView *hideOuter = [sender.superview.superview viewWithTag:-997];
    [hideOuter setTag:-999];
    UIView *hideInner = [hideOuter viewWithTag:-998];
    
    UIView *showOuter = [sender.superview viewWithTag:-999];
    [showOuter setTag:-997];
    UIView *showInner = [showOuter viewWithTag:-998];
    
    float distance = showInner.frame.size.width;
    
    [UIView animateWithDuration:0.4f animations:^{
        [hideOuter setCenter:CGPointMake(hideOuter.center.x + distance, hideOuter.center.y)];
        [hideInner setCenter:CGPointMake(- distance / 2 + 2 * self.scale, 25 * self.scale)];
        [showOuter setFrame:CGRectMake(0, 0, showOuter.frame.size.width, showOuter.frame.size.height)];
        [showInner setCenter:CGPointMake(distance / 2 + 2 * self.scale, 25 * self.scale)];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(shopListView:didTapCategoryButtonWithCategory:)]) {
        if (sender.tag != 7) {
            [_delegate shopListView:self didTapCategoryButtonWithCategory:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
        } else {
            [_delegate shopListView:self didTapCategoryButtonWithCategory:@""];
        }
    }
}

#pragma mark - Favorite Operation

- (void)setFavoriteSucceedWithShopEntity:(ShopEntity *)shopEntity andTag:(NSInteger)tag {
    CGRect rect = [mainScrollView viewWithTag:tag].frame;
    [[mainScrollView viewWithTag:tag] removeFromSuperview];
    
    [mainScrollView addSubview:[self createListButtonWithFrame:rect andShopEntity:shopEntity andTag:tag - 100]];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //[searchView hideKeyboard];
    if (_delegate && [_delegate respondsToSelector:@selector(shopListView:didStartDragScrollView:)]) {
        [_delegate shopListView:self didStartDragScrollView:scrollView ];
    }
    
    //瀑布流显示
    if ([scrollView isEqual:mainScrollView]) {
        if (mainScrollView.contentSize.height - mainScrollView.contentOffset.y < mainScrollView.frame.size.height * 2) {
            [self addListButton];
        }
    } else if ([scrollView isEqual:searchScrollView]) {
        if (searchScrollView.contentSize.height - searchScrollView.contentOffset.y < searchScrollView.frame.size.height ) {
            [self addSearchButton];
        }
    }
}

#pragma mark - Search Delegate

- (void)searchTextView:(SearchTextView *)searchTextView didChange:(NSString *)searchText
{
    if (_delegate && [_delegate respondsToSelector:@selector(shopListView:didSearch:)]) {
        [_delegate shopListView:self didSearch:searchText];
    }
}

- (void)searchTextView:(SearchTextView *)searchTextView didStartTexting:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(shopListView:didStartTexting:)]) {
        [_delegate shopListView:self didStartTexting:searchText];
    }
}

- (void)searchTextView:(SearchTextView *)searchTextView didEndTexting:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(shopListView:didEndTexting:)]) {
        [_delegate shopListView:self didEndTexting:searchText];
    }
}

#pragma mark - DDL Delegate

- (void)dropDownListView:(DropDownListView *)dropDownListView didTapOption:(SortType)option {
    [searchView hideKeyboard];
    if (_delegate && [_delegate respondsToSelector:@selector(shopListView:didTapDropDownListOption:)]) {
        [_delegate shopListView:self didTapDropDownListOption:option];
    }
}

@end
