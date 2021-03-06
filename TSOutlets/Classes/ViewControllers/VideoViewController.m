//
//  VideoViewController.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/4/9.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "VideoViewController.h"

#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "pinyin.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    if (!videoShopView) {
        videoShopView = [[VideoShopView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:videoShopView];
    }
    [videoShopView setDelegate:self];
    
    //    [ArticleCoreDataHelper getVideoShopList];
    //    [ArticleCoreDataHelper getVideoMallList];
    
    [videoShopView showLoadingView];
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
        originShopVideoArray = [ArticleCoreDataHelper getVideoShopList];
        videoShopView.videoListArray = [originShopVideoArray sortedArrayUsingComparator:^NSComparisonResult(VideoEntity *obj1, VideoEntity *obj2) {
            // 排序
            NSComparisonResult result = [obj2.videoID compare:obj1.videoID];
            return result;
        }];
    }];
    
    [operation setCompletionBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [videoShopView createVideoListWithVideoEntityArray];
            [videoShopView hideLoadingView];
        }];
    }];
    if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
        [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
    }
    
    [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldRecordLog" object:@"Video List"];
    self.currentView = videoShopView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBasicInfo) name:@"updateInfo" object:nil];
}

#pragma mark - Sort Operation

- (void)sortEventShopViewWithSortOption:(SortType)option {
    switch (option) {
        case SortTypeCHNameAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopVideoArray = [originShopVideoArray sortedArrayUsingComparator:^NSComparisonResult(VideoEntity *obj1, VideoEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj1.title characterAtIndex:0])] compare:[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj2.title characterAtIndex:0])]];
                    return result;
                }];
                
                videoShopView.videoListArray = originShopVideoArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [videoShopView createVideoListWithVideoEntityArray];
                });
            });
            break;
        }
        case SortTypeCHNameDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopVideoArray = [originShopVideoArray sortedArrayUsingComparator:^NSComparisonResult(VideoEntity *obj1, VideoEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj2.title characterAtIndex:0])] compare:[NSString stringWithFormat:@"%c",pinyinFirstLetter([obj1.title characterAtIndex:0])]];
                    return result;
                }];
                
                videoShopView.videoListArray = originShopVideoArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [videoShopView createVideoListWithVideoEntityArray];
                });
            });
            break;
        }
        case SortTypeENNameAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopVideoArray = [originShopVideoArray sortedArrayUsingComparator:^NSComparisonResult(VideoEntity *obj1, VideoEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj1.shopEntity.enName compare:obj2.shopEntity.enName];
                    return result;
                }];
                
                videoShopView.videoListArray = originShopVideoArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [videoShopView createVideoListWithVideoEntityArray];
                });
            });
            break;
        }
        case SortTypeENNameDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopVideoArray = [originShopVideoArray sortedArrayUsingComparator:^NSComparisonResult(VideoEntity *obj1, VideoEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj2.shopEntity.enName compare:obj1.shopEntity.enName];
                    return result;
                }];
                
                videoShopView.videoListArray = originShopVideoArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [videoShopView createVideoListWithVideoEntityArray];
                });
            });
            break;
        }
        case SortTypeUploadDateDesc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopVideoArray = [originShopVideoArray sortedArrayUsingComparator:^NSComparisonResult(VideoEntity *obj1, VideoEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj2.time compare:obj1.time];
                    return result;
                }];
                
                videoShopView.videoListArray = originShopVideoArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [videoShopView createVideoListWithVideoEntityArray];
                });
            });
            break;
        }
        case SortTypeUploadDateAsc:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originShopVideoArray = [originShopVideoArray sortedArrayUsingComparator:^NSComparisonResult(VideoEntity *obj1, VideoEntity *obj2) {
                    // 排序
                    NSComparisonResult result = [obj1.time compare:obj2.time];
                    return result;
                }];
                
                videoShopView.videoListArray = originShopVideoArray;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [videoShopView createVideoListWithVideoEntityArray];
                });
            });
            break;
        }
        default:
            break;
    }
}

- (void)addSearchList {
    [videoShopView addSearchList];
}

- (void)removeSearchList {
    if (currentString.length == 0) {
        [videoShopView removeSearchList];
    }
}

- (void)rebuildSearchList {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (currentString && currentString.length > 0) {
            if (![ChineseInclude isIncludeChineseInString:currentString]) {
                for (VideoEntity *ety in originShopVideoArray) {
                    if ([ChineseInclude isIncludeChineseInString:ety.shopEntity.chName]) {
                        NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.title];
                        NSRange titleResult=[tempPinYinStr rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        NSString *chPinYinStr = [PinYinForObjc chineseConvertToPinYin:ety.shopEntity.chName];
                        NSRange chResult = [chPinYinStr rangeOfString:currentString options:NSCaseInsensitiveSearch];
                        if (titleResult.length || chResult.length >0) {
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

                        if (titleResult.length || chResult.length >0) {
                            [tempArray addObject:ety];
                        }
                    }
                }
            } else if ([ChineseInclude isIncludeChineseInString:currentString]) {
                for (VideoEntity *ety in originShopVideoArray) {
                    NSRange titleResult=[ety.title rangeOfString:currentString options:NSCaseInsensitiveSearch];
                    NSRange chResult = [ety.shopEntity.chName rangeOfString:currentString options:NSCaseInsensitiveSearch];
                    
                    if (titleResult.length || chResult.length >0) {
                        [tempArray addObject:ety];
                    }
                }
            }
        } else {
            //[tempArray addObjectsFromArray:originArray];
        }
        
        videoShopView.videoSearchArray = tempArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [videoShopView didSearch];
        });
    });
}

#pragma mark - Notification

- (void)updateBasicInfo {
    if ([self.currentView isEqual:videoShopView]) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            originShopVideoArray = [ArticleCoreDataHelper getVideoShopList];
            
            videoShopView.videoListArray = [originShopVideoArray sortedArrayUsingComparator:^NSComparisonResult(VideoEntity *obj1, VideoEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.videoID compare:obj1.videoID];
                return result;
                }];
        }];
        
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [videoShopView refreshSelf];
            }];
        }];
        if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
            [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
        }
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    } else {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            videoMallView.videoListArray = [[ArticleCoreDataHelper getVideoMallList] sortedArrayUsingComparator:^NSComparisonResult(VideoEntity *obj1, VideoEntity *obj2) {
                // 排序
                NSComparisonResult result = [obj2.videoID compare:obj1.videoID];
                return result;
            }];
        }];
        
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [videoMallView refreshSelf];
            }];
        }];
        
        if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
            [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
        }
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    }
}

#pragma mark - Event Views Delegate

- (void)videoShopView:(VideoShopView *)videoShopView didStartDragScrollView:(UIScrollView *)scrollView {
    [self wheelViewShouldHide];
}

- (void)videoShopView:(VideoShopView *)videoShopView didTapDropDownListOption:(SortType)option {
    [self sortEventShopViewWithSortOption:option];
}

- (void)videoShopView:(VideoShopView *)videoShopView didSearch:(NSString *)string {
    currentString = string;
    [self rebuildSearchList];
}

- (void)videoShopView:(VideoShopView *)videoShopView didStartTexting:(NSString *)string {
    [self addSearchList];
}

- (void)videoShopView:(VideoShopView *)videoShopView didEndTexting:(NSString *)string {
    [self removeSearchList];
}

- (void)videoShopView:(VideoShopView *)videoShopView didPlayerVideo:(NSString *)url {
    [self didTappedVideoWithVideoUrl:url];
}

- (void)videoMallView:(VideoMallView *)videoMallView didStartDragScrollView:(UIScrollView *)scrollView {
    [self wheelViewShouldHide];
}

- (void)videoMallView:(VideoMallView *)videoMallView didPlayerVideo:(NSString *)url {
    [self didTappedVideoWithVideoUrl:url];
}

- (void)videoShopViewDidRefresh {
    MemberAPITool *mat = [[MemberAPITool alloc] init];
    NSString *dateTime = [mat getLastUpdateDate];
    BasicInfoAPITool *bat = [[BasicInfoAPITool alloc] init];
    [bat updateBasicInfoByDate:dateTime];
}

- (void)videoMallViewDidRefresh {
    MemberAPITool *mat = [[MemberAPITool alloc] init];
    NSString *dateTime = [mat getLastUpdateDate];
    BasicInfoAPITool *bat = [[BasicInfoAPITool alloc] init];
    [bat updateBasicInfoByDate:dateTime];
}

#pragma mark - Wheel View

- (void)wheelViewTappedButton2 {
    [self popToIndexViewController];
}
- (void)wheelViewTappedButton3 {
    self.nextView = videoMallView;
    [self showNextView];
}

- (void)wheelViewTappedButton4 {
    if (!videoShopView) {
        videoShopView = [[VideoShopView alloc] initWithFrame:self.view.bounds];
        [videoShopView setAlpha:0];
        [videoShopView setDelegate:self];
        [self.view addSubview:videoShopView];
        
        [videoShopView showLoadingView];
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^(){
            originShopVideoArray = [ArticleCoreDataHelper getVideoShopList];
            
            videoShopView.videoListArray = originShopVideoArray;
        }];
        
        [operation setCompletionBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [videoShopView createVideoListWithVideoEntityArray];
                [videoShopView hideLoadingView];
            }];
        }];
        if ([SingleCase singleCase].coredataOperationQueue.operations.count > 0) {
            [operation addDependency:[[SingleCase singleCase].coredataOperationQueue.operations lastObject]];
        }
        
        [[SingleCase singleCase].coredataOperationQueue addOperation:operation];
    }
    
    self.nextView = videoShopView;
    [self showNextView];
}

@end
