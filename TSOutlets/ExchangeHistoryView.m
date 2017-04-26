//
//  ExchangeHistoryView.m
//  TSOutlets
//
//  Created by KDC on 15/11/25.
//  Copyright © 2015年 奚潇川. All rights reserved.
//

#import "ExchangeHistoryView.h"
#import "MJRefresh.h"

#define buttonHeight 130.0f

@implementation ExchangeHistoryView

- (void) initView {
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    
    df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    ehScrollView = [[UIScrollView alloc ] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    [ehScrollView setDelegate:self];
    [self addSubview:ehScrollView];
    
}

- (void)refreshSelf {
    //[exScrollView headerEndRefreshing];
    
    [self createExchangeHistoryWithExchangeHistoryArray];
}

- (void)createExchangeHistoryWithExchangeHistoryArray {
    for (id d in ehScrollView.subviews) {
        if (![d isMemberOfClass:[MJRefreshHeaderView class]]) [d removeFromSuperview];
    }
    
    for (int i = 0; i<_exchangeHistoryListArray.count; i++) {
        ExchangeHistoryEntity *ety = (ExchangeHistoryEntity *)[_exchangeHistoryListArray objectAtIndex:i];
        [ehScrollView addSubview:[self createListButtonWithFrame:CGRectMake(0, i * buttonHeight * self.scale, self.frame.size.width, buttonHeight * self.scale) andEntity:ety andTag:i]];
        [ehScrollView setContentSize:CGSizeMake(ehScrollView.frame.size.width, _exchangeHistoryListArray.count * 140 * self.scale + 130 * self.scale > ehScrollView.frame.size.height ? _exchangeHistoryListArray.count * 140 * self.scale + 130 * self.scale: ehScrollView.frame.size.height + 1 )];
        }
    }

- (UIButton *)createListButtonWithFrame:(CGRect)frame andEntity:(ExchangeHistoryEntity *)ety andTag:(int)tag {
    
    UIButton *historyView = [[UIButton alloc] initWithFrame:frame];
    historyView.clipsToBounds = YES;
    [historyView setTag:tag];
    [ehScrollView addSubview:historyView];
    
    UILabel *exchangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(145 * self.scale, 20.5 * self.scale, self.frame.size.width - 150 * self.scale, 20 * self.scale)];
    [exchangeLabel setBackgroundColor:AbsoluteClear];
    if ([ety.exchangeType isEqualToString:@"0"]) {
        [exchangeLabel setText:[NSString stringWithFormat:@"使用%@线上积分兑换",ety.point]];
    } else {
        [exchangeLabel setText:[NSString stringWithFormat:@"使用%@线下积分兑换",ety.point]];
    }
    [exchangeLabel setFont:[UIFont systemFontOfSize:17 * self.scale]];
    [historyView addSubview:exchangeLabel];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(145 * self.scale, 55 * self.scale, self.frame.size.width - 190 * self.scale, 20 * self.scale)];
    [titleLabel setBackgroundColor:AbsoluteClear];
    [titleLabel setText:ety.title];
    [titleLabel setTextColor:[UIColor colorWithRed:255.f/255.f green:180.f/255.f blue: 92.f/255.f alpha:1]];
    [titleLabel setFont:[UIFont systemFontOfSize:20 * self.scale]];
    [historyView addSubview:titleLabel];
    
    UIColor *borderColor = [UIColor colorWithRed:219.f/255.f green:219.f/255.f blue:219.f/255.f alpha:1];
    
    if (ety.listPicUrl) {
            MDIncrementalImageView *imageView = [[MDIncrementalImageView alloc] initWithFrame:CGRectMake( 25 * self.scale, 12.5 * self.scale, 80 * self.scale, 80 * self.scale)];
            [imageView setImageUrl:[NSURL URLWithString:ety.listPicUrl]];
            [imageView setShowLoadingIndicatorWhileLoading:YES];
        
            [imageView.layer setBorderColor:borderColor.CGColor];
            [imageView.layer setBorderWidth:2];
        
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [historyView addSubview:imageView];
        } else {
            UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake( 25 * self.scale, 12.5 * self.scale, 80 * self.scale, 80 * self.scale)];
            [logoImage.layer setBorderColor:borderColor.CGColor];
            [logoImage.layer setBorderWidth:2];
            [logoImage setImage:[UIImage imageNamed:@"Gift"]];
            [logoImage setContentMode:UIViewContentModeScaleAspectFill];
            [historyView addSubview:logoImage];
        }
    
    if ([ety.isDeal intValue] == 1) {
        UIImageView *dealImage = [[UIImageView alloc] initWithFrame:CGRectMake( 25 * self.scale, 12.5 * self.scale, 92/2 * self.scale, 91/2 * self.scale)];
        [dealImage setImage:[UIImage imageNamed:@"IsDeal"]];
        [historyView addSubview:dealImage];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(200 * self.scale, 90 * self.scale, self.frame.size.width - 200 * self.scale, 15 * self.scale)];
        [timeLabel setBackgroundColor:AbsoluteClear];
        NSDate *date = [df dateFromString:ety.exchangeTime];
        [timeLabel setText:[NSString stringWithFormat:@"兑换时间：%@",[df2 stringFromDate:date]]];
        [timeLabel setFont:[UIFont systemFontOfSize:10 * self.scale]];
        [historyView addSubview:timeLabel];
    } else {
        NSDate *now = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSUInteger interval = [zone secondsFromGMTForDate:now];
        NSDate *localDate = [now dateByAddingTimeInterval:interval];
        NSDate *outDate = [df dateFromString:ety.outDate];
        
        if ([ety.outType intValue] == 3) {
            UILabel *restDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(270 * self.scale, 84 * self.scale, 70 * self.scale, 26 * self.scale)];
            [restDayLabel setText:@"   已过期"];
            restDayLabel.layer.cornerRadius = 13.f * self.scale;
            restDayLabel.layer.borderColor = ThemeYellow.CGColor;
            restDayLabel.layer.borderWidth = 1.5f;
            [restDayLabel setTextColor:ThemeYellow];
            [restDayLabel setFont:[UIFont systemFontOfSize:13 * self.scale]];
            [historyView addSubview:restDayLabel];
        } else {
            UILabel *restDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(200 * self.scale, 84 * self.scale, 160 * self.scale, 26 * self.scale)];
            
            if ([self daysBetweenDate:localDate andDate:outDate] >= 0) {
                [restDayLabel setText:[NSString stringWithFormat:@"    还剩%ld天，赶紧去兑换",(long)[self daysBetweenDate:localDate andDate:outDate]]];
            } else {
                [restDayLabel setText:@"    还剩0天，赶紧去兑换"];
            }
            restDayLabel.layer.cornerRadius = 13.f * self.scale;
            restDayLabel.layer.borderColor = ThemeYellow.CGColor;
            restDayLabel.layer.borderWidth = 1.5f;
            [restDayLabel setTextColor:ThemeYellow];
            [restDayLabel setFont:[UIFont systemFontOfSize:13 * self.scale]];
            [historyView addSubview:restDayLabel];
        }
        
        
        UIImageView *notdealImage = [[UIImageView alloc] initWithFrame:CGRectMake( self.frame.size.width - 40 * self.scale, 60 * self.scale, 15 * self.scale, 12 * self.scale)];
        [notdealImage setImage:[UIImage imageNamed:@"Exchange_click"]];
        [historyView addSubview:notdealImage];
    }
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(25 * self.scale, 120 * self.scale, self.frame.size.width - 25 * self.scale , 1)];
    [topLine setBackgroundColor:borderColor];
    [historyView addSubview:topLine];
    
    [historyView addTarget:self action:@selector(tappedExchangeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return historyView;
}

- (void)createNoExchange {
    UIImageView *noExchange = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    [noExchange setImage:[UIImage imageNamed:@"noExchange"]];
    [self addSubview:noExchange];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(80 * self.scale, 350 * self.scale, self.frame.size.width - 160 * self.scale, 100 * self.scale)];
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(tappedNoExchange) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)tappedExchangeButton:(UIButton *)button {
    ExchangeHistoryEntity *ety = (ExchangeHistoryEntity *)[_exchangeHistoryListArray objectAtIndex:button.tag];
    
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSUInteger interval = [zone secondsFromGMTForDate:now];
    NSDate *localDate = [now dateByAddingTimeInterval:interval];
    
    NSString *localDateStr = [NSString stringWithFormat:@"%@", localDate];
    
    
    if ([ety.isDeal intValue] == 1) {
        if ([localDateStr compare:ety.exchangeEntity.endTime] == 1 || [ety.exchangeEntity.display intValue] ==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"该礼品已下架！"];
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(exchangeHistoryView:didTapEventButtonWithExchangeEntity:)]) {
                [_delegate exchangeHistoryView:self didTapEventButtonWithExchangeEntity:ety.exchangeEntity];
            }
        }
    } else {
        if ([ety.outType intValue] == 3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shouldShowTip" object:@"兑换时间已过期！"];
        } else {
            if (_delegate && [_delegate respondsToSelector:@selector(exchangeHistoryView:didTapisDealButtonWithExchangeHistoryEntity:)]) {
            [_delegate exchangeHistoryView:self didTapisDealButtonWithExchangeHistoryEntity:ety];
            }
        }
    }
}

- (void)tappedNoExchange {
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeHistoryViewDidTappedButton:withType:andParameter:)]) {
        [_delegate exchangeHistoryViewDidTappedButton:self withType:ViewControllerTypeExchange andParameter:nil];
    }
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_delegate && [_delegate respondsToSelector:@selector(exchangeHistoryView:didStartDragScrollView:)]) {
        [_delegate exchangeHistoryView:self didStartDragScrollView:scrollView ];
    }
}

@end
