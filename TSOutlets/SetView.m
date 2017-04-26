//
//  SetView.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/5/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "SetView.h"

@implementation SetView

- (void)initView {
    setScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    [setScrollView setShowsVerticalScrollIndicator:NO];
    [self addSubview:setScrollView];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 * self.scale, selfWidth, 30 * self.scale)];
    [versionLabel setText:[NSString stringWithFormat:@"当前版本：%@",appVersion]];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setTextColor:ThemeRed];
    [versionLabel setFont:[UIFont systemFontOfSize:16 * self.scale]];
    [setScrollView addSubview:versionLabel];
    
    UIButton *aboutUsButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * self.scale, 80 * self.scale, selfWidth - 20 * self.scale, 50 * self.scale)];
    aboutUsButton.layer.cornerRadius = 25.f * self.scale;
    aboutUsButton.layer.borderColor = ThemeRed.CGColor;
    aboutUsButton.layer.borderWidth = 1.5f;
    [aboutUsButton setExclusiveTouch:YES];
    [aboutUsButton setClipsToBounds:YES];
    [aboutUsButton addTarget:self action:@selector(tappedaboutUsButton) forControlEvents:UIControlEventTouchUpInside];
    [setScrollView addSubview:aboutUsButton];
    
    UILabel *aboutUsLabel = [[UILabel alloc] initWithFrame:CGRectMake(14 * self.scale, 0 * self.scale, selfWidth - 100 * self.scale, 50 * self.scale)];
    [aboutUsLabel setText:@"关于我们"];
    [aboutUsLabel setTextColor:ThemeRed];
    [aboutUsLabel setFont:[UIFont systemFontOfSize:22 * self.scale]];
    [aboutUsButton addSubview:aboutUsLabel];
    
    UIImageView *triImage = [[UIImageView alloc] initWithFrame:CGRectMake(aboutUsButton.frame.size.width - 25 * self.scale, 16 * self.scale, 7 * self.scale, 17 * self.scale)];
    [triImage setImage:[UIImage imageNamed:@"MessageTri"]];
    [aboutUsButton addSubview:triImage];
    
    UIButton *feedbackButton = [[UIButton alloc] initWithFrame:CGRectMake(10 * self.scale, 150 * self.scale, selfWidth - 20 * self.scale, 50 * self.scale)];
    feedbackButton.layer.cornerRadius = 25.f * self.scale;
    feedbackButton.layer.borderColor = ThemeRed.CGColor;
    feedbackButton.layer.borderWidth = 1.5f;
    [feedbackButton setExclusiveTouch:YES];
    [feedbackButton setClipsToBounds:YES];
    [feedbackButton addTarget:self action:@selector(tappedfeedbackButton) forControlEvents:UIControlEventTouchUpInside];
    [setScrollView addSubview:feedbackButton];
    
    UILabel *feedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(14 * self.scale, 0 * self.scale, selfWidth - 100 * self.scale, 50 * self.scale)];
    [feedbackLabel setText:@"意见反馈"];
    [feedbackLabel setTextColor:ThemeRed];
    [feedbackLabel setFont:[UIFont systemFontOfSize:22 * self.scale]];
    [feedbackButton addSubview:feedbackLabel];
    
    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 * self.scale, 5 * self.scale, selfWidth - 100 * self.scale, 50 * self.scale)];
    [defaultLabel setText:@"APP使用上遇到的问题可以在这里提交"];
    [defaultLabel setTextColor:Grey];
    [defaultLabel setFont:[UIFont systemFontOfSize:12 * self.scale]];
    [feedbackButton addSubview:defaultLabel];
    
    UIImageView *feedbacktriImage = [[UIImageView alloc] initWithFrame:CGRectMake(aboutUsButton.frame.size.width - 25 * self.scale, 16 * self.scale, 7 * self.scale, 17 * self.scale)];
    [feedbacktriImage setImage:[UIImage imageNamed:@"MessageTri"]];
    [feedbackButton addSubview:feedbacktriImage];

    
}

- (void)tappedfeedbackButton
{
    if (_delegate && [_delegate respondsToSelector:@selector(setViewDidTapFeedbackButton)]) {
        [_delegate setViewDidTapFeedbackButton];
    }
}

- (void)tappedaboutUsButton
{
    if (_delegate && [_delegate respondsToSelector:@selector(setViewDidTapaboutUsButton)]) {
        [_delegate setViewDidTapaboutUsButton];
    }
}

@end
