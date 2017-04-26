//
//  GameViewController.h
//  TSOutlets
//
//  Created by ZhuYiqun on 8/21/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MotherViewController.h"
#import "GameView.h"

@interface GameViewController : MotherViewController<GameViewDelegate>
{
    GameView*                           gameView;
    MemberAPITool*                      memberAPI;
}

@property (strong, nonatomic) MemberEntity*         memberEntity;

@end
