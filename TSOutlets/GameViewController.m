//
//  GameViewController.m
//  TSOutlets
//
//  Created by ZhuYiqun on 8/21/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    if (!gameView) {
        memberAPI = [[MemberAPITool alloc] init];
        _memberEntity = [memberAPI getMemberEntity];
        [memberAPI getOnlinePoints];
        [memberAPI getOnlinePointsHistory];
        _memberEntity = [memberAPI getMemberEntity];
        gameView = [[GameView alloc] initWithFrame:self.view.bounds];
        [gameView setDelegate:self];
        [self.view addSubview:gameView];
    }
    
}

- (void)gameViewDidTappedButton:(GameView *)gameView withType:(ViewControllerType) type andParameter:(NSDictionary *)parameter
{
    [self pushViewControllerWithViewControllerType:type andParameter:parameter];
}

@end
