//
//  ExchangeInfoView.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/20/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "ExchangeInfoView.h"

@implementation ExchangeInfoView

- (void)getInfo:(MemberEntity *)memberEntity{
    _memberEntity = memberEntity;
    
    CarouselScrollView *imageView = [[CarouselScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.width * 270 / 750) andImages:_exchangeEntity.carouselArray andTheme:@"Red" andRotate:NO andScale:270.f / 750.f];
    [self addSubview:imageView];
    /*
     MDIncrementalImageView *imageView = [[MDIncrementalImageView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.width * 270 / 750)];
     [imageView setImageUrl:[NSURL URLWithString:_eventEntity.imageUrl]];
     [imageView setShowLoadingIndicatorWhileLoading:YES];
     //[imageView setDelegate:self];
     [self addSubview:imageView];*/
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.05, self.titleHeight + imageView.frame.size.height , self.frame.size.width * 0.9, 30 * self.scale)];
    titleView.backgroundColor = ThemeYellow;
    titleView.layer.cornerRadius = 15.f * self.scale;
    [self addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4 * self.scale, titleView.frame.size.width, 20 * self.scale)];
    titleLabel.text = _exchangeEntity.title;
    [titleLabel setTextColor:AbsoluteWhite];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20 * self.scale]];
    [titleView addSubview:titleLabel];
    
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(55 * self.scale, 260 * self.scale, self.frame.size.width - 100 * self.scale, 30 * self.scale)];
    pointView.layer.cornerRadius = 25.f / 2 * self.scale;
    pointView.userInteractionEnabled = NO;
    pointView.backgroundColor = ThemeYellow_255_235_216;
    [self addSubview:pointView];
    
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(25 * self.scale, 1 * self.scale, pointView.frame.size.width - 25 * self.scale, 30 * self.scale)];
    [pointLabel setText:[NSString stringWithFormat:@"线上积分%@",_exchangeEntity.needOnlinePoint]];
    [pointLabel setTextColor:ThemeRed_103_014_014];
    [pointLabel setFont:[UIFont systemFontOfSize:12 * self.scale]];
    [pointView addSubview:pointLabel];
    
    UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 * self.scale, 2 * self.scale , 25 * self.scale, 25 * self.scale)];
    [orLabel setText:[NSString stringWithFormat:@"或"]];
    [orLabel setTextColor:ThemeYellow_170_104_24];
    [orLabel setFont:[UIFont systemFontOfSize:13 * self.scale]];
    [pointLabel addSubview:orLabel];
    
    UILabel *pointLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(160 * self.scale, 1 * self.scale, pointView.frame.size.width - 25 * self.scale, 30 * self.scale)];
    [pointLabel2 setText:[NSString stringWithFormat:@"线下积分%@",_exchangeEntity.needOfflinePoint]];
    [pointLabel2 setTextColor:ThemeRed_103_014_014];
    [pointLabel2 setFont:[UIFont systemFontOfSize:12 * self.scale]];
    [pointView addSubview:pointLabel2];

    
    UIImageView *needImage = [[UIImageView alloc] initWithFrame:CGRectMake( 30 * self.scale, 255 * self.scale, 40 * self.scale, 40 * self.scale)];
    [needImage setImage:[UIImage imageNamed:@"Required-small"]];
    [needImage setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:needImage];
    
    exchangeInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300 * self.scale, self.frame.size.width, 250 * self.scale)];
    [exchangeInfoScrollView setDelegate:self];
    [self addSubview:exchangeInfoScrollView];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_exchangeEntity.content ];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft ;
    paragraphStyle.lineSpacing = 3.f * self.scale;
    [paragraphStyle setFirstLineHeadIndent:32 * self.scale];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange (0 ,[_exchangeEntity.content length])];
        
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5 * self.scale, 20 * self.scale, self.frame.size.width - 25 * self.scale, 0)];
    [contentLabel setAttributedText:attributedString];
    [contentLabel setBackgroundColor:AbsoluteClear];
    [contentLabel setTextColor:ThemeYellow_170_104_24];
    [contentLabel setNumberOfLines:0];
    [contentLabel setFont:[UIFont systemFontOfSize:18 * self.scale]];
    [contentLabel sizeToFit];
    [contentLabel setFrame:(CGRect){contentLabel.frame.origin, CGSizeMake(self.frame.size.width - 25 * self.scale, contentLabel.frame.size.height)}];
    [exchangeInfoScrollView addSubview:contentLabel];
    
    /*
    if ([_exchangeEntity.amount intValue] > 0) {
    UIButton *exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(119.5f * self.scale, 580 * self.scale, 136 * self.scale, 42 * self.scale)];
    [exchangeButton addTarget:self action:@selector(exchangeMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exchangeButton];
    
    UIImageView *exchangeImage = [[UIImageView alloc] initWithFrame:CGRectMake( 119.5f * self.scale, 580 * self.scale, 136 * self.scale, 42 * self.scale)];
    [exchangeImage setImage:[UIImage imageNamed:@"Exchange"]];
    [exchangeImage setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:exchangeImage];
    } else {
        UIImageView *finishImage = [[UIImageView alloc] initWithFrame:CGRectMake( 52.75f * self.scale, 580 * self.scale, 269.5f * self.scale, 39.5f * self.scale)];
        [finishImage setImage:[UIImage imageNamed:@"Exchange_finish"]];
        [finishImage setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:finishImage];
    }*/
    
    UIButton *onlineExchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(105.75 * self.scale, 560 * self.scale, 347/2 * self.scale, 35.5 * self.scale)];
    [onlineExchangeButton addTarget:self action:@selector(onlineExchange) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:onlineExchangeButton];
    
    UIImageView *onlineExchangeImage = [[UIImageView alloc] initWithFrame:onlineExchangeButton.bounds];
    [onlineExchangeImage setImage:[UIImage imageNamed:@"OnlineExchange"]];
    [onlineExchangeImage setContentMode:UIViewContentModeScaleAspectFill];
    [onlineExchangeButton addSubview:onlineExchangeImage];
    
    UIButton *offlineExchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(105.75 * self.scale, 610 * self.scale, 347/2 * self.scale, 35.5 * self.scale)];
    [offlineExchangeButton addTarget:self action:@selector(offlineExchange) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:offlineExchangeButton];
    
    UIImageView *offlineExchangeImage = [[UIImageView alloc] initWithFrame:offlineExchangeButton.bounds];
    [offlineExchangeImage setImage:[UIImage imageNamed:@"OfflineExchange"]];
    [offlineExchangeImage setContentMode:UIViewContentModeScaleAspectFill];
    [offlineExchangeButton addSubview:offlineExchangeImage];
    
    [exchangeInfoScrollView setContentSize:CGSizeMake(exchangeInfoScrollView.frame.size.width, 230 * self.scale + contentLabel.frame.size.height)];

}

- (void)onlineExchange
{
    if (!_memberEntity.onlinePoint) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"请登录"];
    } else {
        if ([_memberEntity.onlinePoint intValue] < [_exchangeEntity.needOnlinePoint intValue]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"您的线上积分不足！"];
        } else {
            NSString *msg = [NSString stringWithFormat:@"此次兑换将使用%@积分，确定兑换吗？\n取消查看其它礼品",_exchangeEntity.needOnlinePoint];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
            alert.tag = 1;
            [alert show];
        }
    }
}

- (void)confirmExchange
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:@"恭喜，兑换成功"
                                                   delegate:self
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            if (_delegate && [_delegate respondsToSelector:@selector(exchangeInfoView:didTapExchangeButtonWithEventEntity:)]) {
                [_delegate exchangeInfoView:self didTapExchangeButtonWithEventEntity:_exchangeEntity];
            }
            //[self confirmExchange];
        }
    }
}


- (void)offlineExchange
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:@"欢迎前往百联南京奥莱 客户服务中心B9-101 兑换礼品"
                                                   delegate:self
                                          cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil, nil];
    [alert show];
}




@end
