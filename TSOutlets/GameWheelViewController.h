//
//  GameWheelViewController.h
//  TSOutlets
//
//  Created by ZhuYiqun on 8/24/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotherViewController.h"
#import "GameWheelView.h"
#import "MemberAPITool.h"
#import "MemberCoreDataHelper.h"
#import "LKLotteryView.h"

@interface GameWheelViewController : MotherViewController<GameWheelViewDelegate>
{
    GameWheelView*                                      gamewheelView;
    MemberAPITool*                                      memberAPI;
    
    NSDictionary*                                       wheellotteryRescodeDic;
    int                                                 wheellotteryRescode;
    
    NSDictionary*                                       gamewheelcontrollerresDic;
    int                                                 gamewheelcontrollerBonusRaw;
    int                                                 gamewheelcontrollerBonus;
}

@property (weak, nonatomic) MemberEntity*                 memberEntity;

@end
