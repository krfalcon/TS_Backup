//
//  OnlinePointView.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/20.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"
#import "CSColorizedProgressView.h"
#import "MemberEntity.h"

#import "MemberCoreDataHelper.h"

@protocol OnlinePointViewDelegate;

@interface OnlinePointView : TempletView <UIScrollViewDelegate>
{
    UIScrollView*                                                   pointScrollView;
    UIView*                                                         numberView;
    UIView*                                                         signinScoreView;
    UILabel*                                                        pointLabel;
    UILabel*                                                        currentPoint;
    UILabel*                                                        numberLabel;
    CSColorizedProgressView*                                        colorizedProgressView;
}

@property (weak, nonatomic) id<OnlinePointViewDelegate>             delegate;
@property (retain, nonatomic) MemberEntity*                         memberEntity;
@property (nonatomic, assign) float                                 p;
@property (nonatomic, assign) BOOL                                  ifBinded;

- (void)getInfo:(NSObject *)memberEntity;
- (void)reloadProgressViewandProgress:(int)progress;

@end

@protocol OnlinePointViewDelegate <NSObject>

- (void)scrollViewDidScroll;
- (void)onlinePointViewDidTapDetailButton;
- (void)onlinPointViewDidTapSigninRulerButton;
@optional
- (void)onlinePointViewDidTapSigninButton;
@end
