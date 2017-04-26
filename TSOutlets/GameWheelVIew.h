//
//  GameWheelView.h
//  TSOutlets
//
//  Created by ZhuYiqun on 8/24/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempletView.h"
#import "MemberEntity.h"
#import "LKLotteryView.h"
#import "MemberAPITool.h"

@protocol GameWheelViewDelegate;

@interface GameWheelView : TempletView
{
    UIImageView*                            gamewheelView;
    UIImageView*                            scorebackgroundView;
    UIButton*                               startButton;
    UIImageView*                            startButtonImage;
    UIImageView*                            startButtonSelectedImage;
    UIImageView*                            backgroundView;
    UIImageView*                            scoreView;
    
    UILabel*                                scoreLabel;
    UILabel*                                lotteryscoreLabel;
    LKLotteryView*                          lottery;
    MemberAPITool*                          memberAPI;
    NSDictionary*                           gamewheelresDic;
    NSDictionary*                           gamewheelres;
    BOOL                                    checkgamewheelallowed;
    int                                     wheelBonus;
    int                                     gamewheelBonusRaw;
    
}

@property (weak, nonatomic) id<GameWheelViewDelegate>        delegate;
@property (retain, nonatomic) MemberEntity*                  memberEntity;
@property(nonatomic, assign)CGFloat                          p;

- (void)getInfo:(NSObject *)memberEntity;
- (void)GameWheelViewStartDuration:(float)duration endAngle:(float)angle;
- (void)minusScore;

@end

@protocol GameWheelViewDelegate <NSObject>

- (void) GameWheelViewDidTapStartButton;

@optional
- (void) refresh;

@end