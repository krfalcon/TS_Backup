//
//  OfflinePointDetailView.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/20.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"
#import "OfflineHistoryEntity.h"

@interface OfflinePointDetailView : TempletView
{
    UIScrollView        *pointScrollView;
}


@property (retain, nonatomic) NSArray*                      offlineHistoryListArray;
@property (strong, nonatomic) OfflineHistoryEntity*         offlineHistoryEntity;

- (void)getInfo:(NSObject *)memberEntity;

@end
