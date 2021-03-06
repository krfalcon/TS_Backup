//
//  EventViewController.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/2.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "EventViewController.h"

#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "pinyin.h"

@interface EventViewController ()

@end

@implementation EventViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    switch (_currentPage) {
        case 1:
        {
            if (!eventMallView) {
                eventMallView = [[EventMallView alloc] initWithFrame:self.view.bounds];
            }
            [eventMallView setDelegate:self];
            [self.view addSubview:eventMallView];
            
            self.currentView = eventMallView;
            [eventMallView showLoadingView];
            
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
                eventMallView.eventListArray = [[ArticleCoreDataHelper getEventMallList] sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj2.endTime compare:obj1.endTime];
                    return result;
                }];
            }];
            
            [operation setCompletionBlock:^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [eventMallView createEventListWithEventEntityArray];
                    [eventMallView hideLoadingView];
                }];
            }];
            if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
                [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
            }
            
            [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldRecordLog" object:@"Event Mall List"];
            
            break;
        }
        case 2:
        {
            if (!eventShopView) {
                eventShopView = [[EventShopView alloc] initWithFrame:self.view.bounds];
            }
            [eventShopView setDelegate:self];
            [self.view addSubview:eventShopView];
            
            self.currentView = eventShopView;
            [eventShopView showLoadingView];
            
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
                rawShopEventArray = [ArticleCoreDataHelper getEventShopList];
                NSDate *date = [NSDate date];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSUInteger interval = [zone secondsFromGMTForDate:date];
                NSDate *now = [date dateByAddingTimeInterval:interval];
                
                NSString *nowStr = [NSString stringWithFormat:@"%@", now];
                
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"endTime >= %@", nowStr];
                originShopEventArray = [rawShopEventArray filteredArrayUsingPredicate:pre];
                originShopEventArray = [originShopEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj2.eventID compare:obj1.eventID];
                    return result;
                }];
                
                eventShopView.eventListArray = originShopEventArray;
            }];
            [operation setCompletionBlock:^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [eventShopView createEventListWithEventEntityArray];
                    [eventShopView hideLoadingView];
                }];
            }];
            if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
                [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
            }
            
            [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldRecordLog" object:@"Event Brand List"];
            
            break;
        }
        case 3:
        {
            if (!saleView) {
                saleView = [[SaleView alloc] initWithFrame:self.view.bounds];
            }
            [saleView setDelegate:self];
            [self.view addSubview:saleView];
            
            self.currentView = saleView;
            [saleView showLoadingView];
            
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
                rawSaleEventArray = [ArticleCoreDataHelper getSaleList];
                NSDate *date = [NSDate date];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSUInteger interval = [zone secondsFromGMTForDate:date];
                NSDate *now = [date dateByAddingTimeInterval:interval];
                
                NSString *nowStr = [NSString stringWithFormat:@"%@", now];
                
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"endTime >= %@", nowStr];
                originSaleEventArray = [rawSaleEventArray filteredArrayUsingPredicate:pre];
                originSaleEventArray = [originSaleEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj2.eventID compare:obj1.eventID];
                    return result;
                }];
                
                saleView.eventListArray = originSaleEventArray;
            }];
            [operation setCompletionBlock:^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [saleView createEventListWithEventEntityArray];
                    [saleView hideLoadingView];
                }];
            }];
            if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
                [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
            }
            
            [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
            
            break;
        }
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBasicInfo) name:@"updateInfo" object:nil];
}

#pragma mark - Sort Operation 

- (void)sortEventShopViewWithSortOption:(SortType)option {
    switch (option) {
        case SortTypeCHNameAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopEventArray = [originShopEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj1.shopEntity.chName characterAtIndex:0])] compare:[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj2.shopEntity.chName characterAtIndex:0])]];
                    return result;
                }];
                
                eventShopView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [eventShopView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        case SortTypeCHNameDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopEventArray = [originShopEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj2.shopEntity.chName characterAtIndex:0])] compare:[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj1.shopEntity.chName characterAtIndex:0])]];
                    return result;
                }];
                
                eventShopView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [eventShopView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        case SortTypeENNameAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopEventArray = [originShopEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj1.shopEntity.enName compare:obj2.shopEntity.enName];
                    return result;
                }];
                
                eventShopView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [eventShopView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        case SortTypeENNameDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopEventArray = [originShopEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj2.shopEntity.enName compare:obj1.shopEntity.enName];
                    return result;
                }];
                
                eventShopView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [eventShopView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        case SortTypeEndDateAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopEventArray = [originShopEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj1.endTime compare:obj2.endTime];
                    return result;
                }];
                
                eventShopView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [eventShopView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        case SortTypeEndDateDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopEventArray = [originShopEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj2.endTime compare:obj1.endTime];
                    return result;
                }];
                
                eventShopView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [eventShopView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        default:
            break;
    }
}

- (void)addSearchList {
    [eventShopView addSearchList];
}

- (void)addSaleViewSearchList {
    [saleView addSearchList];
}

- (void)removeSearchList {
    if (currentString.length == 0) {
        [eventShopView removeSearchList];
    }
}

- (void)removeSaleSearchList {
    if (currentString.length == 0) {
        [saleView removeSearchList];
    }
}

- (void)rebuildSearchList {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (currentString && currentString.length > 0) {
            if (![ChineseInclude isIncludeChineseInString:currentString]) {
                for (ItemEntity *ety in originShopEventArray) {
                    if ([ChineseInclude isIncludeChineseInString:ety.title]) {
                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.title];
                        NSString *chPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.shopEntity.chName];
                        NSString *contentPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.content];
                        NSRange chResult = [chPinYinStr rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        NSRange eResult = [ety.shopEntity.enName rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        NSRange titleResult=[tempPinYinStr rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        NSRange contentResult=[contentPinYinStr rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        
                        if (titleResult.length || chResult.length || eResult.length || contentResult.length > 0) {
                            [tempArray addObject:ety];
                        } else {
                            NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:ety.title];
                            NSString *chPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.shopEntity.chName];
                            NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:currentString options:NSCaseInsensitiveSearch];
                            NSRange chHeadResult=[chPinYinStr rangeOfString:currentString options:NSCaseInsensitiveSearch];
                            if (titleHeadResult.length || chHeadResult.length >0) {
                                [tempArray addObject:ety];
                            }
                        }
                    }
                    else {
                        NSRange titleResult=[ety.title rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        NSRange chResult = [ety.shopEntity.chName rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        NSRange eResult = [ety.shopEntity.enName rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        NSRange contentResult=[ety.content rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        
                        if (titleResult.length || chResult.length || eResult.length || contentResult.length > 0 ) {
                            [tempArray addObject:ety];
                        }
                    }
                }
            } else if ([ChineseInclude isIncludeChineseInString:currentString]) {
                for (ItemEntity *ety in originShopEventArray) {
                    NSRange titleResult=[ety.title rangeOfString:currentString options:NSCaseInsensitiveSearch];
                    NSRange chResult = [ety.shopEntity.chName rangeOfString:currentString options:NSCaseInsensitiveSearch];
                    NSRange eResult = [ety.shopEntity.enName rangeOfString:currentString options:NSCaseInsensitiveSearch];
                    NSRange contentResult=[ety.content rangeOfString:currentString options:NSCaseInsensitiveSearch];
                    
                    if (titleResult.length || chResult.length || eResult.length || contentResult.length > 0) {
                        [tempArray addObject:ety];
                    }
                }
            }
        } else {
            //[tempArray addObjectsFromArray:originArray];
        }
        eventShopView.eventSearchArray = tempArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [eventShopView didSearch];
        });
    });
}

#pragma mark - Event Views Delegate

- (void)eventShopView:(EventShopView *)eventShopView didStartDragScrollView:(UIScrollView *)scrollView {
    [self wheelViewShouldHide];
}

- (void)eventShopView:(EventShopView *)eventShopView didTapEventButtonWithEventEntity:(EventEntity *)eventEntity {
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:eventEntity, @"entity", nil];
    [self pushViewControllerWithViewControllerType:ViewControllerTypeEventInfo andParameter:parameter];
}

- (void)eventShopView:(EventShopView *)eventShopView didTapDropDownListOption:(SortType)option {
    [self sortEventShopViewWithSortOption:option];
}

- (void)eventMallView:(EventMallView *)eventMallView didStartDragScrollView:(UIScrollView *)scrollView {
    [self wheelViewShouldHide];
}

- (void)eventShopView:(EventShopView *)eventShopView didSearch:(NSString *)string {
    currentString = string;
    [self rebuildSearchList];
}

- (void)eventShopView:(EventShopView *)eventShopView didStartTexting:(NSString *)string {
    [self addSearchList];
}

- (void)eventShopView:(EventShopView *)eventShopView didEndTexting:(NSString *)string {
    [self removeSearchList];
}

- (void)eventMallView:(EventMallView *)eventMallView didTapEventButtonWithEventEntity:(EventEntity *)eventEntity {
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:eventEntity, @"entity", nil];
    [self pushViewControllerWithViewControllerType:ViewControllerTypeEventTheme andParameter:parameter];
}

- (void)eventShopViewDidRefresh {
    MemberAPITool *mat = [[MemberAPITool alloc] init];
    NSString *dateTime = [mat getLastUpdateDate];
    BasicInfoAPITool *bat = [[BasicInfoAPITool alloc] init];
    [bat updateBasicInfoByDate:dateTime];
}

- (void)eventMallViewDidRefresh {
    MemberAPITool *mat = [[MemberAPITool alloc] init];
    NSString *dateTime = [mat getLastUpdateDate];
    BasicInfoAPITool *bat = [[BasicInfoAPITool alloc] init];
    [bat updateBasicInfoByDate:dateTime];
}

- (void)saleView:(SaleView *)saleView didStartDragScrollView:(UIScrollView *)scrollView {
    [self wheelViewShouldHide];
}

- (void)saleView:(SaleView *)saleView didTapEventButtonWithEventEntity:(EventEntity *)eventEntity {
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:eventEntity, @"entity", nil];
    [self pushViewControllerWithViewControllerType:ViewControllerTypeEventInfo andParameter:parameter];
}

- (void)saleView:(SaleView *)saleView didTapDropDownListOption:(SortType)option {
    [self sortEventSaleViewWithSortOption:option];
}

- (void)saleView:(SaleView *)saleView didSearch:(NSString *)string {
    saleString = string;
    [self rebuildSaleViewSearchList];
}

- (void)saleView:(SaleView *)saleView didStartTexting:(NSString *)string {
    [self addSaleViewSearchList];
}

- (void)saleView:(SaleView *)saleView didEndTexting:(NSString *)string {
    [self removeSaleSearchList];
}

- (void)saleViewDidRefresh {
    MemberAPITool *mat = [[MemberAPITool alloc] init];
    NSString *dateTime = [mat getLastUpdateDate];
    BasicInfoAPITool *bat = [[BasicInfoAPITool alloc] init];
    [bat updateBasicInfoByDate:dateTime];
}

#pragma mark - Notification

- (void)updateBasicInfo {
    if ([self.currentView isEqual:eventShopView]) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            
            rawShopEventArray = [ArticleCoreDataHelper getEventShopList];
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSUInteger interval = [zone secondsFromGMTForDate:date];
            NSDate *now = [date dateByAddingTimeInterval:interval];
            
            NSString *nowStr = [NSString stringWithFormat:@"%@", now];
            
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"endTime >= %@", nowStr];
            originShopEventArray = [rawShopEventArray filteredArrayUsingPredicate:pre];
            originShopEventArray = [originShopEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.eventID compare:obj1.eventID];
                return result;
            }];
            
            eventShopView.eventListArray = originShopEventArray;
        }];
        
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [eventShopView refreshSelf];
            }];
        }];
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    } else if ([self.currentView isEqual:saleView]) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            
            rawShopEventArray = [ArticleCoreDataHelper getSaleList];
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSUInteger interval = [zone secondsFromGMTForDate:date];
            NSDate *now = [date dateByAddingTimeInterval:interval];
            
            NSString *nowStr = [NSString stringWithFormat:@"%@", now];
            
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"endTime >= %@", nowStr];
            originShopEventArray = [rawShopEventArray filteredArrayUsingPredicate:pre];
            originShopEventArray = [originShopEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.eventID compare:obj1.eventID];
                return result;
            }];
            
            saleView.eventListArray = originShopEventArray;
        }];
        
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [saleView refreshSelf];
            }];
        }];
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    } else {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            eventMallView.eventListArray = [[ArticleCoreDataHelper getEventMallList] sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.endTime compare:obj1.endTime];
                return result;
            }];
        }];
        
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [eventMallView refreshSelf];
            }];
        }];
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    }
}

#pragma mark - Wheel View

- (void)wheelViewTappedButton2 {
    [self popToIndexViewController];
}

- (void)wheelViewTappedButton3 {
    if (!eventMallView) {
        eventMallView = [[EventMallView alloc] initWithFrame:self.view.bounds];
        eventMallView.eventListArray = [ArticleCoreDataHelper getEventMallList];
        [eventMallView setAlpha:0];
        [eventMallView setDelegate:self];
        [self.view addSubview:eventMallView];
        
        [eventMallView showLoadingView];
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            eventMallView.eventListArray = [[ArticleCoreDataHelper getEventMallList] sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.endTime compare:obj1.endTime];
                return result;
            }];
        }];
        
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [eventMallView createEventListWithEventEntityArray];
                [eventMallView hideLoadingView];
            }];
        }];
        if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
            [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
        }
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldRecordLog" object:@"Event Mall List"];
    }
    
    self.nextView = eventMallView;
    [self showNextView];
}

- (void)wheelViewTappedButton4 {
    if (!eventShopView) {
        eventShopView = [[EventShopView alloc] initWithFrame:self.view.bounds];
        [eventShopView setAlpha:0];
        [eventShopView setDelegate:self];
        [self.view addSubview:eventShopView];
        
        [eventShopView showLoadingView];
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            rawShopEventArray = [ArticleCoreDataHelper getEventShopList];
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSUInteger interval = [zone secondsFromGMTForDate:date];
            NSDate *now = [date dateByAddingTimeInterval:interval];
            
            NSString *nowStr = [NSString stringWithFormat:@"%@", now];
            
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"endTime >= %@", nowStr];
            originShopEventArray = [rawShopEventArray filteredArrayUsingPredicate:pre];
            originShopEventArray = [originShopEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.eventID compare:obj1.eventID];
                return result;
            }];
            
            eventShopView.eventListArray = originShopEventArray;
        }];
        
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [eventShopView createEventListWithEventEntityArray];
                [eventShopView hideLoadingView];
            }];
        }];
        if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
            [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
        }
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldRecordLog" object:@"Event Brand List"];
    }
    
    self.nextView = eventShopView;
    [self showNextView];
}

- (void)wheelViewTappedButton5 {
    if (!saleView) {
        saleView = [[SaleView alloc] initWithFrame:self.view.bounds];
        [saleView setAlpha:0];
        [saleView setDelegate:self];
        [self.view addSubview:saleView];
        
        [saleView showLoadingView];
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            rawSaleEventArray = [ArticleCoreDataHelper getSaleList];
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSUInteger interval = [zone secondsFromGMTForDate:date];
            NSDate *now = [date dateByAddingTimeInterval:interval];
            
            NSString *nowStr = [NSString stringWithFormat:@"%@", now];
            
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"endTime >= %@", nowStr];
            originSaleEventArray = [rawSaleEventArray filteredArrayUsingPredicate:pre];
            originSaleEventArray = [originSaleEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.eventID compare:obj1.eventID];
                return result;
            }];
            
            saleView.eventListArray = originSaleEventArray;
        }];
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [saleView createEventListWithEventEntityArray];
                [saleView hideLoadingView];
            }];
        }];
        if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
            [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
        }
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    }
    
    self.nextView = saleView;
    [self showNextView];
}

- (void)sortEventSaleViewWithSortOption:(SortType)option {
    switch (option) {
        case SortTypeCHNameAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originSaleEventArray = [originSaleEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj1.shopEntity.chName characterAtIndex:0])] compare:[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj2.shopEntity.chName characterAtIndex:0])]];
                    return result;
                }];
                
                saleView.eventListArray = originSaleEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        case SortTypeCHNameDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originSaleEventArray = [originSaleEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj2.shopEntity.chName characterAtIndex:0])] compare:[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj1.shopEntity.chName characterAtIndex:0])]];
                    return result;
                }];
                
                saleView.eventListArray = originSaleEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        case SortTypeENNameAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originSaleEventArray = [originSaleEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj1.shopEntity.enName compare:obj2.shopEntity.enName];
                    return result;
                }];
                
                saleView.eventListArray = originSaleEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        case SortTypeENNameDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originSaleEventArray = [originSaleEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj2.shopEntity.enName compare:obj1.shopEntity.enName];
                    return result;
                }];
                
                saleView.eventListArray = originSaleEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        case SortTypeEndDateAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originSaleEventArray = [originSaleEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj1.endTime compare:obj2.endTime];
                    return result;
                }];
                
                saleView.eventListArray = originSaleEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        case SortTypeEndDateDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originSaleEventArray = [originSaleEventArray sortedArrayUsingComparator:^NSComparisonResult(EventEntity *obj1, EventEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj2.endTime compare:obj1.endTime];
                    return result;
                }];
                
                saleView.eventListArray = originSaleEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
                });
            });
            break;
        }
        default:
            break;
    }
}

- (void)rebuildSaleViewSearchList {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (saleString && saleString.length > 0) {
            if (![ChineseInclude isIncludeChineseInString:saleString]) {
                for (ItemEntity *ety in originSaleEventArray) {
                    if ([ChineseInclude isIncludeChineseInString:ety.title]) {
                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.title];
                        NSString *chPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.shopEntity.chName];
                        NSString *contentPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.content];
                        NSRange chResult = [chPinYinStr rangeOfString:saleString options:NSCaseInsensitiveSearch];
                        NSRange eResult = [ety.shopEntity.enName rangeOfString:saleString options:NSCaseInsensitiveSearch];
                        NSRange titleResult=[tempPinYinStr rangeOfString:saleString options:NSCaseInsensitiveSearch];
                        NSRange contentResult=[contentPinYinStr rangeOfString:saleString options:NSCaseInsensitiveSearch];
                        
                        if (titleResult.length || chResult.length || eResult.length || contentResult.length > 0) {
                            [tempArray addObject:ety];
                        } else {
                            NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:ety.title];
                            NSString *chPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.shopEntity.chName];
                            NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:saleString options:NSCaseInsensitiveSearch];
                            NSRange chHeadResult=[chPinYinStr rangeOfString:saleString options:NSCaseInsensitiveSearch];
                            if (titleHeadResult.length || chHeadResult.length >0) {
                                [tempArray addObject:ety];
                            }
                        }
                    }
                    else {
                        NSRange titleResult=[ety.title rangeOfString:saleString options:NSCaseInsensitiveSearch];
                        NSRange chResult = [ety.shopEntity.chName rangeOfString:saleString options:NSCaseInsensitiveSearch];
                        NSRange eResult = [ety.shopEntity.enName rangeOfString:saleString options:NSCaseInsensitiveSearch];
                        NSRange contentResult=[ety.content rangeOfString:saleString options:NSCaseInsensitiveSearch];
                        
                        if (titleResult.length || chResult.length || eResult.length || contentResult.length > 0 ) {
                            [tempArray addObject:ety];
                        }
                    }
                }
            } else if ([ChineseInclude isIncludeChineseInString:saleString]) {
                for (ItemEntity *ety in originSaleEventArray) {
                    NSRange titleResult=[ety.title rangeOfString:saleString options:NSCaseInsensitiveSearch];
                    NSRange chResult = [ety.shopEntity.chName rangeOfString:saleString options:NSCaseInsensitiveSearch];
                    NSRange eResult = [ety.shopEntity.enName rangeOfString:saleString options:NSCaseInsensitiveSearch];
                    NSRange contentResult=[ety.content rangeOfString:saleString options:NSCaseInsensitiveSearch];
                    
                    if (titleResult.length || chResult.length || eResult.length || contentResult.length > 0) {
                        [tempArray addObject:ety];
                    }
                }
            }
        } else {
            //[tempArray addObjectsFromArray:originArray];
        }
        saleView.eventSearchArray = tempArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [saleView didSearch];
        });
    });
}








@end
