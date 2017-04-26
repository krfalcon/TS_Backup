//
//  GameView.m
//  TSOutlets
//
//  Created by ZhuYiqun on 8/21/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import "GameView.h"

@implementation GameView

- (void)initView {
    
    
    gameScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    [gameScrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:gameScrollView];
    
    
    
    UIImageView *gameView = [[UIImageView alloc] initWithFrame:CGRectMake(0 * self.scale, 10 * self.scale, self.frame.size.width, 135 * self.scale)];
    gameView.clipsToBounds = YES;
    [gameView setImage:[UIImage imageNamed:@"GameWheel_index"]];
    [gameScrollView addSubview:gameView];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(- 25 / 2 * self.scale, 135 * self.scale, gameScrollView.frame.size.width - 35 * self.scale, 50 / 2 * self.scale)];
    titleView.layer.cornerRadius = 25.f / 2 * self.scale;
    titleView.backgroundColor = ThemeRed;
    [gameScrollView addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 * self.scale, 135 * self.scale, gameScrollView.frame.size.width - 40 * self.scale, 50 / 2 * self.scale)];
    [titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    [titleLabel setBackgroundColor:AbsoluteClear];
    [titleLabel setText:@"幸运摩天轮"];
    [titleLabel setTextColor:AbsoluteWhite];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [gameScrollView addSubview:titleLabel];
    
    UIButton *wheelButton = [[UIButton alloc] initWithFrame:CGRectMake(0 * self.scale, 10 * self.scale, self.frame.size.width, 250 * self.scale)];
    [wheelButton setTag:0];
    [wheelButton setExclusiveTouch:YES];
    [wheelButton addTarget:self action:@selector(tappedGameButton:) forControlEvents:UIControlEventTouchUpInside];
    [gameScrollView addSubview:wheelButton];
    
}


- (void)tappedGameButton:(UIButton *)button
{
    
    if (button.tag == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(gameViewDidTappedButton:withType:andParameter:)]){
            [_delegate gameViewDidTappedButton:self withType:ViewControllerTypetappedGameButton andParameter:nil];
        }
    }
}


@end
