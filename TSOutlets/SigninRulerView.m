//
//  SigninRulerView.m
//  TSOutlets
//
//  Created by ZhuYiqun on 9/1/15.
//  Copyright (c) 2015 奚潇川. All rights reserved.
//

#import "SigninRulerView.h"

@implementation SigninRulerView

- (void)initView
{
    signinRulerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * self.scale, self.titleHeight, self.frame.size.width -5, self.frame.size.height - self.titleHeight)];
    signinRulerLabel.text = @"签到规则与积分说明：\n\n1、以7天为一周期，签到第一天得10积分，连续签到次日比前一日多加10积分，以此类推，连续签至第7日得70分。\n\n2、连续签到7天，即一周期结束，次日从第一天重新开始计算。\n\n3、如7天中，某天中断签到，则重新从第1天开始计。\n\n4、每个账号每天只可签到一次。\n \n \n \n \n \n \n \n \n \n ";
    signinRulerLabel.numberOfLines = 0;
    signinRulerLabel.textAlignment = NSTextAlignmentLeft;
    signinRulerLabel.textColor = ThemeRed;
    //    signinRulerLabel.font = [UIFont systemFontOfSize:20 * self.scale];
    [self addSubview:signinRulerLabel];
    
}

@end
