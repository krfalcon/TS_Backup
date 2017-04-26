//
//  SaleViewController.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/16/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "SaleViewController.h"

#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "pinyin.h"

@interface SaleViewController ()

@end

@implementation SaleViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    if (!saleView) {
                saleView = [[SaleView alloc] initWithFrame:self.view.bounds];
            }
            [saleView setDelegate:self];
            [self.view addSubview:saleView];
            
            self.currentView = saleView;
            [saleView showLoadingView];
            
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
                    [saleView createEventListWithEventEntityArray];
                    [saleView hideLoadingView];
                }];
            }];
            if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
                [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
            }
            
            [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldRecordLog" object:@"Event Brand List"];
    
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
                
                saleView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
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
                
                saleView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
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
                
                saleView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
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
                
                saleView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
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
                
                saleView.eventListArray = originShopEventArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saleView createEventListWithEventEntityArray];
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
                
                saleView.eventListArray = originShopEventArray;
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

- (void)addSearchList {
    [saleView addSearchList];
}

- (void)removeSearchList {
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
        saleView.eventSearchArray = tempArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [saleView didSearch];
        });
    });
}

#pragma mark - Event Views Delegate

- (void)saleView:(SaleView *)saleView didStartDragScrollView:(UIScrollView *)scrollView {
    [self wheelViewShouldHide];
}

- (void)saleView:(SaleView *)saleView didTapEventButtonWithEventEntity:(EventEntity *)eventEntity {
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:eventEntity, @"entity", nil];
    [self pushViewControllerWithViewControllerType:ViewControllerTypeEventInfo andParameter:parameter];
}

- (void)saleView:(SaleView *)saleView didTapDropDownListOption:(SortType)option {
    [self sortEventShopViewWithSortOption:option];
}

- (void)saleView:(SaleView *)saleView didSearch:(NSString *)string {
    currentString = string;
    [self rebuildSearchList];
}

- (void)saleView:(SaleView *)saleView didStartTexting:(NSString *)string {
    [self addSearchList];
}

- (void)saleView:(SaleView *)saleView didEndTexting:(NSString *)string {
    [self removeSearchList];
}

- (void)saleViewDidRefresh {
    MemberAPITool *mat = [[MemberAPITool alloc] init];
    NSString *dateTime = [mat getLastUpdateDate];
    BasicInfoAPITool *bat = [[BasicInfoAPITool alloc] init];
    [bat updateBasicInfoByDate:dateTime];
}

#pragma mark - Notification

- (void)updateBasicInfo {
    if ([self.currentView isEqual:saleView]) {
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
    }
}

#pragma mark - Wheel View

- (void)wheelViewTappedButton2 {
    [self popToIndexViewController];
}
/*
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
*/
- (void)wheelViewTappedButton4 {
    if (!saleView) {
        saleView = [[SaleView alloc] initWithFrame:self.view.bounds];
        [saleView setAlpha:0];
        [saleView setDelegate:self];
        [self.view addSubview:saleView];
        
        [saleView showLoadingView];
        
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
                [saleView createEventListWithEventEntityArray];
                [saleView hideLoadingView];
            }];
        }];
        if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
            [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
        }
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldRecordLog" object:@"Event Brand List"];
    }
    
    self.nextView = saleView;
    [self showNextView];
}

@end
