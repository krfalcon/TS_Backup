//
//  GameWheelViewController.m
//  TSOutlets
//
//  Created by ZhuYiqun on 8/24/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import "GameWheelViewController.h"

@interface GameWheelViewController ()

@end

@implementation GameWheelViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    memberAPI       = [[MemberAPITool alloc] init];
    [memberAPI getOnlinePoints];
    _memberEntity   = [memberAPI getMemberEntity];
    
    if (!gamewheelView) {
        gamewheelView = [[GameWheelView alloc] initWithFrame:self.view.bounds];
        [gamewheelView setDelegate:self];
        [self.view addSubview: gamewheelView];
        [gamewheelView getInfo:_memberEntity];
    }
    
    [gamewheelView getInfo:_memberEntity];
    
    wheellotteryRescode = 50;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getwheellotteryRescode:) name:@"checkgamewheelallowed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getgamewheelBonus:) name:@"getgamewheelBonus" object:nil];
}

-(void)getwheellotteryRescode:(NSNotification *) notification {
    wheellotteryRescodeDic = [notification userInfo];
    wheellotteryRescode    = [wheellotteryRescodeDic[@"status"][@"resCode"] intValue];
    //NSLog(@"我能不能抽奖:%i", wheellotteryRescode);
    
}

- (void)getgamewheelBonus:(NSNotification *) notification {
    gamewheelcontrollerresDic = [notification userInfo];
    gamewheelcontrollerBonus = [gamewheelcontrollerresDic[@"bonus"][@"Code"] intValue];
    //NSLog(@"我到底应该转几度 %i", gamewheelcontrollerBonus);
    
    if (wheellotteryRescode == 0 ) {
        switch (gamewheelcontrollerBonus) {
            case 0:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:180.0f];
                break;
            case 1:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:210.0f];
                break;
            case 2:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:90.0f];
                break;
            case 3:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:270.0f];
                break;
            case 4:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:150.0f];
                break;
            case 5:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:330.0f];
                break;
            case 6:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:30.0f];
                break;
            case 7:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:240.0f];
                break;
            case 8:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:120.0f];
                break;
            case 9:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:300.0f];
                break;
            case 10:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:360.0f];
                break;
            case 11:
                [gamewheelView GameWheelViewStartDuration:1.0f endAngle:60.0f];
                break;
                
            default:
                break;
        }
        if (![gamewheelcontrollerresDic[@"IsFirst"] boolValue] )
        {
            [gamewheelView minusScore];
        }
        
    }
    //NSLog(@"我是controller code:%i", gamewheelcontrollerBonus);
}

-(void)GameWheelViewDidTapStartButton{
    [memberAPI setWheelLottery];
}

@end
