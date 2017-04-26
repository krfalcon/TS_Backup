//
//  OnlinePointDetailView.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/20.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"
#import "MemberEntity.h"
#import "HistoryEntity.h"
#import "MemberCoreDataHelper.h"

@interface OnlinePointDetailView : TempletView
{
    UIScrollView*                               pointScrollView;
    NSDictionary*                               scorehistoryDic;
    
}


@property (weak, nonatomic)MemberEntity*        memberEntity;
@property (strong, nonatomic)HistoryEntity*     historyEntity;
@property (retain, nonatomic) NSArray*          scorehistoryArray;


- (void)getInfo:(NSObject *)memberEntity;
- (void)createScoreHistoryWithScoreHistoryArray;

@end
