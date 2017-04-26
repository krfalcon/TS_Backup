//
//  OnlinePointView.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/20.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "OnlinePointView.h"
#import <QuartzCore/QuartzCore.h>

@implementation OnlinePointView

- (void)getInfo:(MemberEntity *)memberEntity {
    _memberEntity = memberEntity;
    
    pointScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    pointScrollView.contentSize = CGSizeMake(pointScrollView.contentSize.width, 1000 * self.scale - self.titleHeight);
    pointScrollView.showsVerticalScrollIndicator = NO;
    pointScrollView.delegate = self;
    [self addSubview:pointScrollView];
    
    //详细按钮
    
    UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 150 * self.scale, 15 * self.scale, 175 * self.scale, 40 * self.scale)];
    detailButton.exclusiveTouch = YES;
    [detailButton addTarget:self action:@selector(tappedDetailButton) forControlEvents:UIControlEventTouchUpInside];
    [pointScrollView addSubview:detailButton];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:detailButton.bounds];
    detailLabel.layer.cornerRadius = detailLabel.frame.size.height / 2;
    detailLabel.layer.backgroundColor = ThemeRed.CGColor;
    detailLabel.text = @"   查看积分明细";
    detailLabel.textColor = AbsoluteWhite;
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.font = [UIFont boldSystemFontOfSize:21 * self.scale];
    [detailButton addSubview:detailLabel];
    
    
    UIView *levelView = [[UIView alloc] initWithFrame:CGRectMake(0, 75 * self.scale, 250 * self.scale, 20 * self.scale)];
    levelView.layer.cornerRadius = levelView.frame.size.height / 2;
    levelView.backgroundColor = Color(255, 209, 216, 1);
    [pointScrollView addSubview:levelView];
    
    NSMutableAttributedString *levelString = [[NSMutableAttributedString alloc] initWithString:@"Lv白金会员"];
    [levelString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0 * self.scale] range:NSMakeRange(0, 2)];
    [levelString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0 * self.scale] range:NSMakeRange(2, levelString.length - 2)];
    
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(175 * self.scale, 0, 75 * self.scale, 20 * self.scale)];
    levelLabel.attributedText = levelString;
    levelLabel.textColor = ThemeRed;
    [levelView addSubview:levelLabel];
    
    numberView = [[UIView alloc] initWithFrame:CGRectMake(-22.5 * self.scale, 50 * self.scale, 195 * self.scale, 45 * self.scale)];
    numberView.layer.cornerRadius = numberView.frame.size.height / 2;
    numberView.backgroundColor = ThemeRed;
    [pointScrollView addSubview:numberView];
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * self.scale, 0, 165 * self.scale, 25 * self.scale)];
    if (_memberEntity.Bind) {
        numberLabel.text = [NSString stringWithFormat:@"NO.%@", _memberEntity.offlineNumber];
    } else {
        numberLabel.text = @"尚未绑定实体卡";
        }
    numberLabel.textColor = AbsoluteWhite;
    numberLabel.font = [UIFont systemFontOfSize:18.f * self.scale];
    [numberView addSubview:numberLabel];
    
    pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * self.scale, 25 * self.scale, 145 * self.scale, 20 * self.scale)];
    pointLabel.text = [NSString stringWithFormat:@"剩余积分：%@",_memberEntity.onlinePoint];
    pointLabel.textColor = AbsoluteWhite;
    pointLabel.textAlignment = NSTextAlignmentRight;
    pointLabel.font = [UIFont systemFontOfSize:14.f * self.scale];
    [numberView addSubview:pointLabel];
    
    //进度条
    
    NSMutableAttributedString *currentLevelString = [[NSMutableAttributedString alloc] initWithString:@"当前等级\n钻石"];
    [currentLevelString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0 * self.scale] range:NSMakeRange(0, 4)];
    [currentLevelString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0 * self.scale] range:NSMakeRange(4, currentLevelString.length - 4)];
    
    UILabel *currentLevel = [[UILabel alloc] initWithFrame:CGRectMake(5 * self.scale, 125 * self.scale, 60 * self.scale, 40 * self.scale)];
    currentLevel.attributedText = currentLevelString;
    currentLevel.textColor = ThemeRed;
    currentLevel.textAlignment = NSTextAlignmentCenter;
    currentLevel.numberOfLines = 0;
    [pointScrollView addSubview:currentLevel];
    
    NSMutableAttributedString *nextLevelString = [[NSMutableAttributedString alloc] initWithString:@"下一等级\n黑金"];
    [nextLevelString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0 * self.scale] range:NSMakeRange(0, 4)];
    [nextLevelString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20.0 * self.scale] range:NSMakeRange(4, nextLevelString.length - 4)];
    
    UILabel *nextLevel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 65 * self.scale, 125 * self.scale, 60 * self.scale, 40 * self.scale)];
    nextLevel.attributedText = nextLevelString;
    nextLevel.textColor = Color(165, 165, 155, 1);
    nextLevel.textAlignment = NSTextAlignmentCenter;
    nextLevel.numberOfLines = 0;
    [pointScrollView addSubview:nextLevel];
    
    UIView *progressBarOutline = [[UIView alloc] initWithFrame:CGRectMake(70 * self.scale, 140 * self.scale, self.frame.size.width - 140 * self.scale, 5 * self.scale)];
    progressBarOutline.layer.cornerRadius = progressBarOutline.frame.size.height / 2;
    progressBarOutline.layer.borderWidth = 0.8f;
    progressBarOutline.layer.borderColor = ThemeRed.CGColor;
    [pointScrollView addSubview:progressBarOutline];
    /*
     UIBezierPath *progressPath = [UIBezierPath bezierPath];
     [progressPath moveToPoint:CGPointMake(70 * self.scale, 142.5 * self.scale)];
     
     CGFloat onlineTP = (CGFloat)[_memberEntity.onlineTotalPoint floatValue];
     [progressPath addLineToPoint:CGPointMake( onlineTP / 100000 * 165  * self.scale + 70 * self.scale , 142.5 * self.scale)];
     CAShapeLayer *lineLayer    = [CAShapeLayer layer];
     lineLayer.path             = progressPath.CGPath;
     lineLayer.strokeColor      = ThemeRed.CGColor;
     lineLayer.lineWidth        = 5 * self.scale;
     lineLayer.frame            = self.frame;
     [pointScrollView.layer addSublayer:lineLayer];
     [self drawLineAnimation:lineLayer];
     
     
     
     UIView *progressBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.frame.size.width - 140 * self.scale) * 0.4, 5 * self.scale)];
     progressBar.layer.cornerRadius = progressBar.frame.size.height / 2;
     progressBar.backgroundColor = ThemeRed;
     [progressBarOutline addSubview:progressBar];
     */
    //累计积分情况
    
    NSMutableAttributedString *currentPointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"累计积分\n%@", _memberEntity.onlineTotalPoint]];
    [currentPointString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0 * self.scale] range:NSMakeRange(0, 4)];
    [currentPointString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0 * self.scale] range:NSMakeRange(4, currentPointString.length - 4)];
    
    currentPoint = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 65 * self.scale, 155 * self.scale, 60 * self.scale, 40 * self.scale)];
    currentPoint.attributedText = currentPointString;
    currentPoint.textColor = ThemeRed;
    currentPoint.textAlignment = NSTextAlignmentCenter;
    currentPoint.numberOfLines = 0;
    [pointScrollView addSubview:currentPoint];
    
    NSMutableAttributedString *nextPointString = [[NSMutableAttributedString alloc] initWithString:@"升级积分\n∞"];
    [nextPointString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0 * self.scale] range:NSMakeRange(0, 4)];
    [nextPointString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0 * self.scale] range:NSMakeRange(4, nextPointString.length - 4)];
    
    UILabel *nextPoint = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 + 5 * self.scale, 155 * self.scale, 60 * self.scale, 40 * self.scale)];
    nextPoint.attributedText = nextPointString;
    nextPoint.textColor = ThemeRed;
    nextPoint.textAlignment = NSTextAlignmentCenter;
    nextPoint.numberOfLines = 0;
    [pointScrollView addSubview:nextPoint];
    
    UILabel *slashLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x - 5, 155 * self.scale, 10 * self.scale, 40 * self.scale)];
    slashLabel.text = @"/";
    slashLabel.textColor = ThemeRed;
    slashLabel.textAlignment = NSTextAlignmentCenter;
    slashLabel.font = [UIFont systemFontOfSize:15 * self.scale];
    [pointScrollView addSubview:slashLabel];
    
    UIButton *levelInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(230 * self.scale, 195 * self.scale, self.frame.size.width - 230 * self.scale, 40 * self.scale)];
    [pointScrollView addSubview:levelInfoButton];
    
    UILabel *levelInfoLabel = [[UILabel alloc] initWithFrame:levelInfoButton.bounds];
    levelInfoLabel.text = @"什么是积分和等级？";
    levelInfoLabel.textColor = ThemeRed;
    levelInfoLabel.font = [UIFont systemFontOfSize:15 * self.scale];
    [levelInfoButton addSubview:levelInfoLabel];
    
    UIImageView *levelInfoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MemberView_Tri_Red"]];
    [levelInfoImage setFrame:CGRectMake(levelInfoButton.frame.size.width - 15 * self.scale, 14 * self.scale, 9 * self.scale, 12 * self.scale)];
    [levelInfoButton addSubview:levelInfoImage];
    
#pragma mark - Sign in
    
    
    UIImageView *signinDayView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250 * self.scale , pointScrollView.frame.size.width, 15 * self.scale)];
    [signinDayView setImage:[UIImage imageNamed:@"signin_Day"]];
    [pointScrollView addSubview:signinDayView];

    signinScoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 265 * self.scale , pointScrollView.frame.size.width, 54 * self.scale)];
    [pointScrollView addSubview:signinScoreView];
    UIImage *signinScoreImage = [UIImage imageNamed:@"signin_Score"];
    
    _p = self.frame.size.width / 414.f;
    
    _p = floorf(_p * 100)/100;
    colorizedProgressView = [[CSColorizedProgressView alloc] initWithImage:signinScoreImage];
    [colorizedProgressView setScale:_p];
    [colorizedProgressView setDirection:CSColorizedProgressViewDirectionLeftToRight];
    [colorizedProgressView sizeToFit];
    [colorizedProgressView setTotalAnimationDuration:3.0f];
    [signinScoreView addSubview:colorizedProgressView];
    
    UIButton *signinButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 75 * self.scale, 345 * self.scale, 150 * self.scale, 62 * self.scale)];
    [signinButton setTag:0];
    [signinButton addTarget:self action:@selector(tappedSigninButton) forControlEvents:UIControlEventTouchUpInside];
    [pointScrollView addSubview:signinButton];
    
    UIImageView *signinButtonImage = [[UIImageView alloc] initWithFrame:signinButton.bounds];
    [signinButtonImage setImage:[UIImage imageNamed:@"signin_Button"]];
    [signinButton addSubview:signinButtonImage];
    
    UILabel *signinInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(265 * self.scale, 380 * self.scale, self.frame.size.width - 265 * self.scale , 40 * self.scale)];
    signinInfoLabel.text = @"签到规则说明";
    signinInfoLabel.textColor = ThemeRed;
    signinInfoLabel.font = [UIFont systemFontOfSize:15 * self.scale];
    [pointScrollView addSubview:signinInfoLabel];
    
    UIButton *signinRulerButton = [[UIButton alloc] initWithFrame:CGRectMake(280 * self.scale, 380 * self.scale, self.frame.size.width - 280 * self.scale , 40 * self.scale)];
    [signinRulerButton addTarget:self action:@selector(tappedSigninRulerButton) forControlEvents:UIControlEventTouchUpInside];
    [pointScrollView addSubview:signinRulerButton];
    
    UIImageView *signinInfoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MemberView_Tri_Red"]];
    [signinInfoImage setFrame:CGRectMake(signinInfoLabel.frame.size.width - 15 * self.scale, 14 * self.scale, 9 * self.scale, 12 * self.scale)];
    [signinInfoLabel addSubview:signinInfoImage];
    
    
    
    
    //特权
    
    UILabel *privilegeLabel = [[UILabel alloc] initWithFrame:CGRectMake(- 15 * self.scale, 420 * self.scale, 130 * self.scale, 25 * self.scale)];
    privilegeLabel.layer.cornerRadius = privilegeLabel.frame.size.height / 2;
    privilegeLabel.layer.backgroundColor = ThemeRed.CGColor;
    privilegeLabel.text = @"我的特权";
    privilegeLabel.textColor = AbsoluteWhite;
    privilegeLabel.textAlignment = NSTextAlignmentCenter;
    privilegeLabel.font = [UIFont systemFontOfSize:20 * self.scale];
    [pointScrollView addSubview:privilegeLabel];
    
    UIScrollView *privilegeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 450 * self.scale, self.frame.size.width, 130 * self.scale)];
    privilegeScrollView.backgroundColor = AbsoluteWhite;
    [pointScrollView addSubview:privilegeScrollView];
    
    UIButton *privilegeButton = [[UIButton alloc] initWithFrame:CGRectMake(250 * self.scale, 590 * self.scale, self.frame.size.width - 230 * self.scale, 25 * self.scale)];
    privilegeButton.layer.cornerRadius = privilegeButton.frame.size.height / 2;
    privilegeButton.layer.borderWidth = 1.f;
    privilegeButton.layer.borderColor = Color(177, 177, 177, 1).CGColor;
    [pointScrollView addSubview:privilegeButton];
    
    UILabel *privilegeButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * self.scale, 0 * self.scale, self.frame.size.width - 280 * self.scale, 25 * self.scale)];
    privilegeButtonLabel.text = @"下一级解锁特权";
    privilegeButtonLabel.textColor = Color(109, 87, 87, 1);
    privilegeButtonLabel.textAlignment = NSTextAlignmentLeft;
    privilegeButtonLabel.font = [UIFont systemFontOfSize:13 * self.scale];
    [privilegeButton addSubview:privilegeButtonLabel];
    
    UIImageView *privilegeButtonImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MemberView_Tri_Gray"]];
    [privilegeButtonImage setFrame:CGRectMake(privilegeButton.frame.size.width - 35 * self.scale, 6 * self.scale, 9 * self.scale, 12 * self.scale)];
    [privilegeButton addSubview:privilegeButtonImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOnlinePoint) name:@"updateonlinePoint" object:nil];
    
}

- (void)refreshOnlinePoint{
    _memberEntity = [MemberCoreDataHelper getMemberEntity];
    
    [pointLabel removeFromSuperview];
    pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * self.scale, 25 * self.scale, 145 * self.scale, 20 * self.scale)];
    pointLabel.text = [NSString stringWithFormat:@"剩余积分：%@",_memberEntity.onlinePoint];
    pointLabel.textColor = AbsoluteWhite;
    pointLabel.textAlignment = NSTextAlignmentRight;
    pointLabel.font = [UIFont systemFontOfSize:14.f * self.scale];
    [numberView addSubview:pointLabel];
    
    if (_memberEntity.onlinePoint) {
        [pointLabel removeFromSuperview];
        pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * self.scale, 25 * self.scale, 145 * self.scale, 20 * self.scale)];
        pointLabel.text = [NSString stringWithFormat:@"剩余积分：%@",_memberEntity.onlinePoint];
        pointLabel.textColor = AbsoluteWhite;
        pointLabel.textAlignment = NSTextAlignmentRight;
        pointLabel.font = [UIFont systemFontOfSize:14.f * self.scale];
        [numberView addSubview:pointLabel];
    }
     
    if (_memberEntity.onlineTotalPoint) {
        [currentPoint removeFromSuperview];
        NSMutableAttributedString *currentPointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"累计积分\n%@", _memberEntity.onlineTotalPoint]];
        [currentPointString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0 * self.scale] range:NSMakeRange(0, 4)];
        [currentPointString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0 * self.scale] range:NSMakeRange(4, currentPointString.length - 4)];
        
        currentPoint = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 65 * self.scale, 155 * self.scale, 60 * self.scale, 40 * self.scale)];
        currentPoint.attributedText = currentPointString;
        currentPoint.textColor = ThemeRed;
        currentPoint.textAlignment = NSTextAlignmentCenter;
        currentPoint.numberOfLines = 0;
        [pointScrollView addSubview:currentPoint];
    }
    
    if (_memberEntity.signinDay) {
        /*        [colorizedProgressView removeFromSuperview];
         signinScoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 225, pointScrollView.frame.size.width, 54 * self.scale)];
         [pointScrollView addSubview:signinScoreView];
         UIImage *signinScoreImage = [UIImage imageNamed:@"signin_Score"];
         colorizedProgressView = [[CSColorizedProgressView alloc] initWithImage:signinScoreImage];
         [colorizedProgressView setDirection:CSColorizedProgressViewDirectionLeftToRight];
         [colorizedProgressView sizeToFit];
         [colorizedProgressView setTotalAnimationDuration:3.0f];*/
        int a = [_memberEntity.signinDay intValue];
        NSLog(@"签到天数：%i",a);
        switch (a) {
            case 0:
                [colorizedProgressView setProgress:0.1f * _p animated:YES];
                break;
            case 1:
                [colorizedProgressView setProgress:0.24f * _p animated:YES];
                break;
            case 2:
                [colorizedProgressView setProgress:0.38f * _p animated:YES];
                break;
            case 3:
                [colorizedProgressView setProgress:0.525f * _p animated:YES];
                break;
            case 4:
                [colorizedProgressView setProgress:0.666f * _p animated:YES];
                break;
            case 5:
                [colorizedProgressView setProgress:0.81f * _p animated:YES];
                break;
            case 6:
                [colorizedProgressView setProgress:1.0f  animated:YES];
                break;
                
                
            default:
                [colorizedProgressView setProgress:0.f animated:YES];
                break;
        }
        [signinScoreView addSubview:colorizedProgressView];
    }
    
}

- (void)reloadProgressViewandProgress:(int)progress {
    
    switch (progress) {
        case 0:
        {
            [colorizedProgressView removeFromSuperview];
            UIImage *signinScoreImage = [UIImage imageNamed:@"signin_Score"];
            colorizedProgressView = [[CSColorizedProgressView alloc] initWithImage:signinScoreImage];
            [colorizedProgressView setDirection:CSColorizedProgressViewDirectionLeftToRight];
            [colorizedProgressView sizeToFit];
            [colorizedProgressView setTotalAnimationDuration:3.0f];
            [colorizedProgressView setProgress:0.1f * self.scale animated:YES];
            break;
        }
        case 1:
            [colorizedProgressView setProgress:0.24f * _p animated:YES];
            break;
        case 2:
            [colorizedProgressView setProgress:0.38f * _p animated:YES];
            break;
        case 3:
            [colorizedProgressView setProgress:0.52f * _p animated:YES];
            break;
        case 4:
            [colorizedProgressView setProgress:0.666f * _p animated:YES];
            break;
        case 5:
            [colorizedProgressView setProgress:0.81f * _p animated:YES];
            break;
        case 6:
            [colorizedProgressView setProgress:1.0f  animated:YES];
            break;
            
            
        default:
            [colorizedProgressView setProgress:0.f animated:YES];
            break;
    }
    [signinScoreView addSubview:colorizedProgressView];
}
//累积积分动画
- (void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = 1;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

#pragma mark - Button Tapping Events

- (void)tappedDetailButton {
    if (_delegate && [_delegate respondsToSelector:@selector(onlinePointViewDidTapDetailButton)]) {
        [_delegate onlinePointViewDidTapDetailButton];
    }
}

- (void)tappedSigninButton {
    if (_delegate && [_delegate respondsToSelector:@selector(onlinePointViewDidTapSigninButton)]) {
        [_delegate onlinePointViewDidTapSigninButton];
    }
}

- (void)tappedSigninRulerButton {
    if (_delegate && [_delegate respondsToSelector:@selector(onlinPointViewDidTapSigninRulerButton)]) {
        [_delegate onlinPointViewDidTapSigninRulerButton];
    }
}

#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewDidScroll)]) {
        [_delegate scrollViewDidScroll];
    }
}

@end
