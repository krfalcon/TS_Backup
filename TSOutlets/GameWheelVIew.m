//
//  GameWheelView.m
//  TSOutlets
//
//  Created by ZhuYiqun on 8/24/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import "GameWheelView.h"

@implementation GameWheelView

- (void)getInfo:(MemberEntity *)memberEntity {
    _memberEntity = memberEntity;
    
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    [backgroundView setImage:[UIImage imageNamed:@"GameWheel_background"]];
    [backgroundView setUserInteractionEnabled:YES];
    [self addSubview:backgroundView];
    
    scoreView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * self.scale, 10 * self.scale, 90 * self.scale, 30 * self.scale )];
    [scoreView setImage:[UIImage imageNamed:@"GameWheel_score"]];
    [backgroundView addSubview:scoreView];
    
    scoreLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0 * self.scale, 0 * self.scale, scoreView.frame.size.width, scoreView.frame.size.height )];
    [scoreLabel setText:[NSString stringWithFormat:@"积分：%@",_memberEntity.onlinePoint]];
    [scoreLabel setTextColor:AbsoluteWhite];
    [scoreLabel setFont:[UIFont boldSystemFontOfSize:13 * self.scale]];
    [scoreLabel setTextAlignment:NSTextAlignmentCenter];
    [scoreView addSubview: scoreLabel];
    
    UIImageView *basementView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 50 * self.scale, 280 * self.scale, 100 * self.scale, 150 * self.scale)];
    [basementView setImage:[UIImage imageNamed:@"GameWheel_basement"]];
    [backgroundView addSubview:basementView];
    
    startButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 75 * self.scale, 390 * self.scale, 150* self.scale, 50 * self.scale)];
    [startButton addTarget:self action:@selector(tappedStartButton) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:startButton];
    
    startButtonImage = [[UIImageView alloc] initWithFrame:startButton.bounds];
    [startButtonImage setImage:[UIImage imageNamed:@"GameWheel_Buttonstart"]];
    [startButton addSubview:startButtonImage];
    
    startButtonSelectedImage = [[UIImageView alloc] initWithFrame:startButton.bounds];
    [startButtonSelectedImage setImage:[UIImage imageNamed:@"GameWheel_ButtonSelected"]];
    [startButtonSelectedImage setAlpha:0];
    [startButton addSubview:startButtonSelectedImage];
    
    
    UIImage *panelImage = [UIImage imageNamed:@"GameWheel_panel"];
    UIImage *pointerImage = [UIImage imageNamed:@"GameWheel_pointer"];
    
    lottery = [[LKLotteryView alloc] initWithDialPanel:panelImage pointer:pointerImage portion:self.scale];
    //[lottery setFrame:CGRectMake(0 , 0, 375 * self.scale, 375 * self.scale)];
    //[lottery startDuration:1.0f endAngle:75.0f];
    [backgroundView addSubview:lottery];
    
    scorebackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 35 * self.scale, 305 * self.scale, 70 * self.scale, 70 * self.scale)];
    [scorebackgroundView setAlpha:0];
    [scorebackgroundView setImage:[UIImage imageNamed:@"scorebackground"]];
    [backgroundView addSubview:scorebackgroundView];
    
    lotteryscoreLabel = [[UILabel alloc] initWithFrame:scorebackgroundView.bounds];
    [lotteryscoreLabel setTextColor:AbsoluteWhite];
    [lotteryscoreLabel setFont:[UIFont boldSystemFontOfSize:28 * self.scale]];
    [lotteryscoreLabel setTextAlignment:NSTextAlignmentCenter];
    [scorebackgroundView addSubview:lotteryscoreLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkgamewheelallowed:) name:@"checkgamewheelallowed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wheelgamefinished) name:@"wheelgamefinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getgamewheelBonus:) name:@"getgamewheelBonus" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOnlinePoint) name:@"updateonlinePoint" object:nil];
    
}

- (void)refreshOnlinePoint{
    _memberEntity = [MemberCoreDataHelper getMemberEntity];
    
    if (_memberEntity.onlinePoint) {
        [scoreLabel removeFromSuperview];
        scoreLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0 * self.scale, 0 * self.scale, scoreView.frame.size.width, scoreView.frame.size.height )];
        [scoreLabel setText:[NSString stringWithFormat:@"积分：%@",_memberEntity.onlinePoint]];
        [scoreLabel setTextColor:AbsoluteWhite];
        [scoreLabel setFont:[UIFont boldSystemFontOfSize:13 * self.scale]];
        [scoreLabel setTextAlignment:NSTextAlignmentCenter];
        [scoreView addSubview: scoreLabel];
    }
    
    
} 

- (void)wheelgamefinished{
    //    [scorebackgroundView setAlpha:1];
    memberAPI = [[MemberAPITool alloc] init];
    _memberEntity   = [memberAPI getMemberEntity];
    
    [self showscore:scorebackgroundView];
    [startButton setUserInteractionEnabled:YES];
    [startButtonImage setAlpha:1];
    [startButtonSelectedImage setAlpha:0];
    [scoreLabel setText:[NSString stringWithFormat:@"积分：%@",_memberEntity.onlinePoint]];
    
}

- (void)getgamewheelBonus:(NSNotification *) notification {
    gamewheelresDic = [notification userInfo];
    NSLog(@"我收到gamewheelresDic:%@", gamewheelresDic);
    
    NSLog(@"我是bonus code: %@",gamewheelresDic[@"bonus"][@"Code"]);
    gamewheelBonusRaw = [gamewheelresDic[@"bonus"][@"Code"] intValue];
    
    //NSLog(@"我收到gamewheel code:%i", gamewheelBonusRaw);
    switch (gamewheelBonusRaw) {
        case 0:
            wheelBonus = 5;
            break;
        case 1:
            wheelBonus = 8;
            break;
        case 2:
            wheelBonus = 10;
            break;
        case 3:
            wheelBonus = 20;
            break;
        case 4:
            wheelBonus = 30;
            break;
        case 5:
            wheelBonus = 50;
            break;
        case 6:
            wheelBonus = 80;
            break;
        case 7:
            wheelBonus = 100;
            break;
        case 8:
            wheelBonus = 200;
            break;
        case 9:
            wheelBonus = 300;
            break;
        case 10:
            wheelBonus = 500;
            break;
        case 11:
            wheelBonus = 800;
            break;
            
        default:
            break;
    }
    [lotteryscoreLabel setText:[NSString stringWithFormat:@"%i",wheelBonus]];
    
}

- (void)checkgamewheelallowed:(NSNotification *) notification {
    gamewheelres = [notification userInfo];
    int p = [[NSString stringWithFormat:@"%@",gamewheelres[@"status"][@"resCode"]] intValue];
    if ( p == 0)
    {
        [startButtonImage setAlpha:0];
        [startButtonSelectedImage setAlpha:1];
        [startButton setUserInteractionEnabled:NO];
    }
    
}

- (void)tappedStartButton{
    [scorebackgroundView setAlpha:0];
    
    if (_delegate && [_delegate respondsToSelector:@selector(GameWheelViewDidTapStartButton)]) {
        [_delegate GameWheelViewDidTapStartButton];
    }
    
}

- (void)GameWheelViewStartDuration:(float)duration endAngle:(float)angle{
    [lottery startDuration:duration endAngle:angle];
}

- (void)showscore:(UIView *) view{
    CGAffineTransform transform = view.transform;
    view.transform = CGAffineTransformScale(transform, 0.7, 0.7);
    view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformScale(transform, 1.2, 1.2);
        view.alpha = 1;}
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3 animations:^{
                             view.transform = CGAffineTransformIdentity;
                         }];
                     }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:[NSString stringWithFormat:@"恭喜获得%i积分！", wheelBonus]];
}

- (void)minusScore{
    int p = [_memberEntity.onlinePoint intValue] - 10 ;
    [scoreLabel setText:[NSString stringWithFormat:@"积分：%i", p]];
    
    UILabel * minusLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 * self.scale, 20 * self.scale, 60 * self.scale, 40 * self.scale)];
    minusLabel.text = @"-10";
    minusLabel.textColor = ThemeBlue;
    minusLabel.font = [UIFont systemFontOfSize:25 * self.scale];
    [backgroundView addSubview:minusLabel];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationDelegate:self];
    minusLabel.alpha =0.0;
    [UIView commitAnimations];
}

@end