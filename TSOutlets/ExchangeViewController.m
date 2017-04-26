//
//  SaleViewController.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/19/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "ExchangeViewController.h"

#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "pinyin.h"

@interface ExchangeViewController ()

@end

@implementation ExchangeViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    memberAPI = [[MemberAPITool alloc] init];
    [memberAPI getExchangeList];
    [memberAPI getExchangeHistory];
    [memberAPI getExchangePlaceAndTelephone];
    
    switch (_currentPage) {
        case 1:
        {
            if (!exchangeView) {
                exchangeView = [[ExchangeView alloc] initWithFrame:self.view.bounds];
            }
            [exchangeView setDelegate:self];
            [self.view addSubview:exchangeView];
    
            self.currentView = exchangeView;
            [exchangeView showLoadingView];
    
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
                //rawExchangeArray = [ArticleCoreDataHelper getEventMallList];
                rawExchangeArray = [MemberCoreDataHelper getExchangeListArray];
                NSDate *date = [NSDate date];
                NSTimeZone *zone = [NSTimeZone systemTimeZone];
                NSUInteger interval = [zone secondsFromGMTForDate:date];
                NSDate *now = [date dateByAddingTimeInterval:interval];
                
                NSString *nowStr = [NSString stringWithFormat:@"%@", now];
        
                NSPredicate *pre = [NSPredicate predicateWithFormat:@"endTime >= %@ and display != %@", nowStr ,[NSString stringWithFormat:@"0"]];
                originExchangeArray = [rawExchangeArray filteredArrayUsingPredicate:pre];
                originExchangeArray = [originExchangeArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeEntity *obj1, ExchangeEntity *obj2) {
            // 排序
                    NSComparisonResult result = [obj2.exchangeId compare:obj1.exchangeId];
                    return result;
                }];
        
                exchangeView.eventListArray = originExchangeArray;
            }];
            [operation setCompletionBlock:^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [exchangeView createEventListWithExchangeEntityArray];
                    [exchangeView hideLoadingView];
                }];
            }];
            if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
                [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
            }
    
            [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBasicInfo) name:@"updateInfo" object:nil];
            
            break;
        }
        case 2:
        {
            exchangeHistoryView = [[ExchangeHistoryView alloc] initWithFrame:self.view.bounds];
            [exchangeHistoryView setDelegate:self];
            [self.view addSubview:exchangeHistoryView];
            
            self.currentView = exchangeHistoryView;
            
            originExchangeHistoryArray = [MemberCoreDataHelper getExchangeHistory];
            if (originExchangeHistoryArray.count == 0) {
                [exchangeHistoryView createNoExchange];
            } else {
                NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
                    originExchangeHistoryArray = [originExchangeHistoryArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeHistoryEntity *obj1, ExchangeHistoryEntity *obj2) {
                        // 排序
                        NSComparisonResult result = [obj2.exchangeTime compare:obj1.exchangeTime];
                        return result;
                    }];
                    
                    exchangeHistoryView.exchangeHistoryListArray = originExchangeHistoryArray;
                }];
                
                [operation setCompletionBlock:^{
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [exchangeHistoryView refreshSelf];
                        //[exchangeHistoryView hideLoadingView];
                    }];
                }];
                if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
                    [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
                }
                
                [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
            break;
            }
        }
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBasicInfo) name:@"updateInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberLogin) name:@"memberLogin" object:nil];
}

#pragma mark - Sort Operation

- (void)sortEventShopViewWithSortOption:(SortType)option {
    switch (option) {
        case SortTypeCHNameAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originExchangeArray = [originExchangeArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeEntity *obj1, ExchangeEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj1.title characterAtIndex:0])] compare:[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj2.title characterAtIndex:0])]];
                    return result;
                }];
                
                exchangeView.eventListArray = originExchangeArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [exchangeView createEventListWithExchangeEntityArray];
                });
            });
            break;
        }
        case SortTypeCHNameDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originExchangeArray = [originExchangeArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeEntity *obj1, ExchangeEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj2.title characterAtIndex:0])] compare:[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj1.title characterAtIndex:0])]];
                    return result;
                }];
                
                exchangeView.eventListArray = originExchangeArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [exchangeView createEventListWithExchangeEntityArray];
                });
            });
            break;
        }
        
        case SortTypeOnlinePointAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originExchangeArray = [originExchangeArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeEntity *obj1, ExchangeEntity *obj2) {
                    if ([obj1.needOnlinePoint floatValue] > [obj2.needOnlinePoint floatValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                    if ([obj1.needOnlinePoint floatValue] < [obj2.needOnlinePoint floatValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    
                    return (NSComparisonResult)NSOrderedSame;
                }];
                
                exchangeView.eventListArray = originExchangeArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [exchangeView createEventListWithExchangeEntityArray];
                });
            });
            break;
        }
            
        case SortTypeOnlinePointDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originExchangeArray = [originExchangeArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeEntity *obj1, ExchangeEntity *obj2) {
                    if ([obj1.needOnlinePoint floatValue] > [obj2.needOnlinePoint floatValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    
                    if ([obj1.needOnlinePoint floatValue] < [obj2.needOnlinePoint floatValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                    return (NSComparisonResult)NSOrderedSame;
                }];
                
                exchangeView.eventListArray = originExchangeArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [exchangeView createEventListWithExchangeEntityArray];
                });
            });
            break;
        }
        case SortTypeOfflinePointAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originExchangeArray = [originExchangeArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeEntity *obj1, ExchangeEntity *obj2) {
                    if ([obj1.needOfflinePoint floatValue] > [obj2.needOfflinePoint floatValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                    if ([obj1.needOfflinePoint floatValue] < [obj2.needOfflinePoint floatValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    
                    return (NSComparisonResult)NSOrderedSame;
                }];
                
                exchangeView.eventListArray = originExchangeArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [exchangeView createEventListWithExchangeEntityArray];
                });
            });
            break;
        }
        case SortTypeOfflinePointDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originExchangeArray = [originExchangeArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeEntity *obj1, ExchangeEntity *obj2) {
                    if ([obj1.needOfflinePoint floatValue] > [obj2.needOfflinePoint floatValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    
                    if ([obj1.needOfflinePoint floatValue] < [obj2.needOfflinePoint floatValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                    return (NSComparisonResult)NSOrderedSame;
                }];
                
                exchangeView.eventListArray = originExchangeArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [exchangeView createEventListWithExchangeEntityArray];
                });
            });
            break;
        }
        default:
            break;
    }
}

- (void)addSearchList {
    [exchangeView addSearchList];
}

- (void)removeSearchList {
    if (currentString.length == 0) {
        [exchangeView removeSearchList];
    }
}

- (void)rebuildSearchList {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (currentString && currentString.length > 0) {
            if (![ChineseInclude isIncludeChineseInString:currentString]) {
                for (ExchangeEntity *ety in originExchangeArray) {
                    if ([ChineseInclude isIncludeChineseInString:ety.title]) {
                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.title];
                        //NSString *contentPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.content];
                        NSRange titleResult=[tempPinYinStr rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        
                        if (titleResult.length  > 0) {
                            [tempArray addObject:ety];
                        } else {
                            NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:ety.title];
                            NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:currentString options:NSCaseInsensitiveSearch];
                            if (titleHeadResult.length  >0) {
                                [tempArray addObject:ety];
                            }
                        }
                    }
                    else {
                        NSRange titleResult=[ety.title rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        if (titleResult.length > 0 ) {
                            [tempArray addObject:ety];
                        }
                    }
                }
            } else if ([ChineseInclude isIncludeChineseInString:currentString]) {
                for (ItemEntity *ety in originExchangeArray) {
                    NSRange titleResult=[ety.title rangeOfString:currentString options:NSCaseInsensitiveSearch];
                    
                    if (titleResult.length > 0) {
                        [tempArray addObject:ety];
                    }
                }
            }
        } else {
            //[tempArray addObjectsFromArray:originArray];
        }
        exchangeView.eventSearchArray = tempArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [exchangeView didSearch];
        });
    });
}

#pragma mark - Event Views Delegate

- (void)exchangeView:(ExchangeView *)exchangeView didStartDragScrollView:(UIScrollView *)scrollView {
    [self wheelViewShouldHide];
}

- (void)exchangeHistoryView:(ExchangeHistoryView *)exchangeHistoryView didStartDragScrollView:(UIScrollView *)scrollView {
    [self wheelViewShouldHide];
}

- (void)exchangeView:(ExchangeView *)exchangeView didTapEventButtonWithExchangeEntity:(ExchangeEntity *)ExchangeEntity {
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:ExchangeEntity, @"entity", nil];
    [self pushViewControllerWithViewControllerType:ViewControllerTypeExchangeInfo andParameter:parameter];
}

- (void)exchangeHistoryView:(ExchangeHistoryView *)exchangeHistoryView didTapEventButtonWithExchangeEntity:(ExchangeEntity *)ExchangeEntity {
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:ExchangeEntity, @"entity", nil];
    [self pushViewControllerWithViewControllerType:ViewControllerTypeExchangeInfo andParameter:parameter];
}

- (void)exchangeHistoryView:(ExchangeHistoryView *)exchangeHistoryView didTapisDealButtonWithExchangeHistoryEntity:(ExchangeHistoryEntity *)ety {
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:ety, @"entity", nil];
    [self pushViewControllerWithViewControllerType:ViewControllerTypeExchangeUrl andParameter:parameter];
}

- (void)exchangeHistoryView:(ExchangeHistoryView *)exchangeHistoryView didTapHistoryButtonWithExchangeEntity:(ExchangeEntity *)ExchangeEntity {
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:ExchangeEntity, @"entity", nil];
    [self pushViewControllerWithViewControllerType:ViewControllerTypeExchangeInfo andParameter:parameter];
}

- (void)exchangeView:(ExchangeView *)exchangeView didTapDropDownListOption:(SortType)option {
    [self sortEventShopViewWithSortOption:option];
}

- (void)exchangeView:(ExchangeView *)exchangeView didSearch:(NSString *)string {
    currentString = string;
    [self rebuildSearchList];
}

- (void)exchangeView:(ExchangeView *)exchangeView didStartTexting:(NSString *)string {
    [self addSearchList];
}

- (void)exchangeView:(ExchangeView *)exchangeView didEndTexting:(NSString *)string {
    [self removeSearchList];
}

- (void)exchangeViewDidRefresh {
    MemberAPITool *mat = [[MemberAPITool alloc] init];
    NSString *dateTime = [mat getLastUpdateDate];
    BasicInfoAPITool *bat = [[BasicInfoAPITool alloc] init];
    [bat updateBasicInfoByDate:dateTime];
}

- (void)exchangeHistoryViewDidTappedButton:(ExchangeHistoryView *)exchangeHistoryView withType:(ViewControllerType)type andParameter:(NSDictionary *)parameter {
    [self wheelViewTappedButton3];
    
}

#pragma mark - Notification

- (void)updateBasicInfo {
    if ([self.currentView isEqual:exchangeView]) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            
            rawExchangeArray = [MemberCoreDataHelper getExchangeListArray];
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSUInteger interval = [zone secondsFromGMTForDate:date];
            NSDate *now = [date dateByAddingTimeInterval:interval];
            
            NSString *nowStr = [NSString stringWithFormat:@"%@", now];
            
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"endTime >= %@ and display != %@", nowStr ,[NSString stringWithFormat:@"0"]];
            originExchangeArray = [rawExchangeArray filteredArrayUsingPredicate:pre];
            originExchangeArray = [originExchangeArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeEntity *obj1, ExchangeEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.exchangeId compare:obj1.exchangeId];
                return result;
            }];
            
            exchangeView.eventListArray = originExchangeArray;
        }];
        
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [exchangeView refreshSelf];
            }];
        }];
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    } else if ([self.currentView isEqual:exchangeHistoryView]) {
        
        originExchangeHistoryArray = [MemberCoreDataHelper getExchangeHistory];
        if (originExchangeHistoryArray.count == 0) {
            [exchangeHistoryView createNoExchange];
        } else {
            //[exchangeHistoryView showLoadingView];
            
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
                originExchangeHistoryArray = [originExchangeHistoryArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeHistoryEntity *obj1, ExchangeHistoryEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj2.exchangeTime compare:obj1.exchangeTime];
                    return result;
                }];
                
                exchangeHistoryView.exchangeHistoryListArray = originExchangeHistoryArray;
            }];
            
            [operation setCompletionBlock:^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [exchangeHistoryView refreshSelf];
                    //[exchangeHistoryView hideLoadingView];
                }];
            }];
            if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
                [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
            }
            
            [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
        }
    }

}

- (void)memberLogin {
    loginStatus = YES;
}


#pragma mark - Wheel View

- (void)wheelViewTappedButton2 {
    [self popToIndexViewController];
}

- (void)wheelViewTappedButton3 {
    if (!exchangeView) {
        exchangeView = [[ExchangeView alloc] initWithFrame:self.view.bounds];
        [exchangeView setAlpha:0];
        [exchangeView setDelegate:self];
        [self.view addSubview:exchangeView];
        
        [exchangeView showLoadingView];
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            rawExchangeArray = [MemberCoreDataHelper getExchangeListArray];
            NSDate *date = [NSDate date];
            NSTimeZone *zone = [NSTimeZone systemTimeZone];
            NSUInteger interval = [zone secondsFromGMTForDate:date];
            NSDate *now = [date dateByAddingTimeInterval:interval];
            
            NSString *nowStr = [NSString stringWithFormat:@"%@", now];
            
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"endTime >= %@ and display != %@", nowStr ,[NSString stringWithFormat:@"0"]];
            originExchangeArray = [rawExchangeArray filteredArrayUsingPredicate:pre];
            originExchangeArray = [originExchangeArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeEntity *obj1, ExchangeEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.exchangeId compare:obj1.exchangeId];
                return result;
            }];
            
            exchangeView.eventListArray = originExchangeArray;
        }];
        
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [exchangeView createEventListWithExchangeEntityArray];
                [exchangeView hideLoadingView];
            }];
        }];
        if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
            [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
        }
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    
    }
    
    self.nextView = exchangeView;
    [self showNextView];
}

- (void)wheelViewTappedButton4 {
    
     //检测登陆状态
     loginStatus = [MemberCoreDataHelper checkLoginStatus];
    
     if (!loginStatus) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"请先登录！"];
         [self navigationViewDidTapMemberButton];
     } else {
         memberAPI = [[MemberAPITool alloc] init];
         [memberAPI getExchangeHistory];
         
         exchangeHistoryView = [[ExchangeHistoryView alloc] initWithFrame:self.view.bounds];
         [exchangeHistoryView setDelegate:self];
         [self.view addSubview:exchangeHistoryView];
        
         //self.currentView = exchangeHistoryView;
         
         originExchangeHistoryArray = [MemberCoreDataHelper getExchangeHistory];
         
         NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
             originExchangeHistoryArray = [originExchangeHistoryArray sortedArrayUsingComparator:^NSComparisonResult(ExchangeHistoryEntity *obj1, ExchangeHistoryEntity *obj2) {
                 // 排序
                 NSComparisonResult result = [obj2.exchangeTime compare:obj1.exchangeTime];
                 return result;
             }];
             
             exchangeHistoryView.exchangeHistoryListArray = originExchangeHistoryArray;
         }];
         
         [operation setCompletionBlock:^{
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 if (exchangeHistoryView.exchangeHistoryListArray.count == 0) {
                     [exchangeHistoryView createNoExchange];
                 } else {
                 [exchangeHistoryView createExchangeHistoryWithExchangeHistoryArray];
                 }
                 //[exchangeHistoryView hideLoadingView];
             }];
         }];
         if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
             [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
         }
         
         [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
        
     }
     
     self.nextView = exchangeHistoryView;
     [self showNextView];
 }

@end
