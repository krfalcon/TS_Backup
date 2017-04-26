//
//  OfflinePointView.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/20.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"
#import "MemberEntity.h"

#import "MemberCoreDataHelper.h"

@protocol OfflinePointViewDelegate;

@interface OfflinePointView : TempletView <UIScrollViewDelegate>
{
    UIScrollView*           pointScrollView;
    UIView*                 numberView;
    UILabel*                numberLabel;
    UILabel*                pointLabel;
}

@property (weak, nonatomic) id<OfflinePointViewDelegate>             delegate;
@property (retain, nonatomic) MemberEntity*                         memberEntity;

- (void)getInfo:(NSObject *)memberEntity;

@end

@protocol OfflinePointViewDelegate <NSObject>

- (void)scrollViewDidScroll;
- (void)offlinePointViewDidTapDetailButton;

@end
