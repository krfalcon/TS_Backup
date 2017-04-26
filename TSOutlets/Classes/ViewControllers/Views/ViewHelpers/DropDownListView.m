//
//  DropDownListView.m
//  TSOutlets
//
//  Created by 奚潇川 on 15/3/25.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "DropDownListView.h"

@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame andSelections:(int)type andColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        //[self setBackgroundColor:[UIColor whiteColor]];
        [self setClipsToBounds:YES];
        [self setIsShow:NO];
        frameHeight = frame.size.height;
        
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(- frame.size.height / 4, frame.size.height * 0.25, frame.size.width + frame.size.height * 0.2, frame.size.height * 0.5)];
        mainView.layer.cornerRadius = frame.size.height * 0.25;
        mainView.layer.borderWidth  = 1.5f;
        mainView.layer.borderColor  = color.CGColor;
        [self addSubview:mainView];
        
        sortLabel = [[UILabel alloc] initWithFrame:mainView.frame];
        [sortLabel setBackgroundColor:[UIColor clearColor]];
        [sortLabel setText:@"选择排序"];
        [sortLabel setTextAlignment:NSTextAlignmentCenter];
        [sortLabel setTextColor:color];
        [sortLabel setFont:[UIFont systemFontOfSize:18.f]];
        [self addSubview:sortLabel];
        
        UIImageView *sortImage = [[UIImageView alloc] initWithFrame:CGRectMake(mainView.frame.size.width - 15, (mainView.frame.size.height - 8) / 2, 9, 8)];
        if ([color isEqual:ThemeRed]) {
            [sortImage setImage:[UIImage imageNamed:@"DropDownListIcon_Red"]];
        } else if ([color isEqual:ThemeYellow]){
            [sortImage setImage:[UIImage imageNamed:@"DropDownListIcon_Yellow"]];
        } else {
            [sortImage setImage:[UIImage imageNamed:@"DropDownListIcon_Blue"]];
        }
        [mainView addSubview:sortImage];
        
        UIButton *sortButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 0.75)];
        //[sortButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [sortButton setExclusiveTouch:YES];
        [sortButton addTarget:self action:@selector(tappedSortButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sortButton];
        
        UIButton *chNameAscButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 - 1, frame.size.width + 1, frameHeight)];
        [chNameAscButton setTag:1];
        [chNameAscButton setExclusiveTouch:YES];
        [chNameAscButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:chNameAscButton];
        
        if (type != 3) {
        UILabel *chNameAscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chNameAscButton.frame.size.width - chNameAscButton.frame.size.height / 4, chNameAscButton.frame.size.height)];
        chNameAscLabel.layer.borderColor = color.CGColor;
        chNameAscLabel.layer.borderWidth = 1.f;
        chNameAscLabel.backgroundColor = [UIColor whiteColor];
        chNameAscLabel.text = @"中文顺序";
        chNameAscLabel.textAlignment = NSTextAlignmentCenter;
        chNameAscLabel.textColor = color;
        chNameAscLabel.font = [UIFont systemFontOfSize:18.f];
        [chNameAscButton addSubview:chNameAscLabel];
        
        UIButton *chNameDescButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight -2, frame.size.width + 1, frameHeight)];
        [chNameDescButton setTag:2];
        [chNameDescButton setExclusiveTouch:YES];
        [chNameDescButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:chNameDescButton];
        
        UILabel *chNameDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chNameDescButton.frame.size.width - chNameDescButton.frame.size.height / 4, chNameDescButton.frame.size.height)];
        chNameDescLabel.layer.borderColor = color.CGColor;
        chNameDescLabel.layer.borderWidth = 1.f;
        chNameDescLabel.backgroundColor = [UIColor whiteColor];
        chNameDescLabel.text = @"中文倒序";
        chNameDescLabel.textAlignment = NSTextAlignmentCenter;
        chNameDescLabel.textColor = color;
        chNameDescLabel.font = [UIFont systemFontOfSize:18.f];
        [chNameDescButton addSubview:chNameDescLabel];
        
        UIButton *enNameAscButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 2 -3, frame.size.width + 1, frameHeight)];
        [enNameAscButton setTag:3];
        [enNameAscButton setExclusiveTouch:YES];
        [enNameAscButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enNameAscButton];
        
        UILabel *enNameAscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, enNameAscButton.frame.size.width - enNameAscButton.frame.size.height / 4, enNameAscButton.frame.size.height)];
        enNameAscLabel.layer.borderColor = color.CGColor;
        enNameAscLabel.layer.borderWidth = 1.f;
        enNameAscLabel.backgroundColor = [UIColor whiteColor];
        enNameAscLabel.text = @"英文顺序";
        enNameAscLabel.textAlignment = NSTextAlignmentCenter;
        enNameAscLabel.textColor = color;
        enNameAscLabel.font = [UIFont systemFontOfSize:18.f];
        [enNameAscButton addSubview:enNameAscLabel];
        
        UIButton *enNameDescButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 3 -4, frame.size.width + 1, frameHeight)];
        [enNameDescButton setTag:4];
        [enNameDescButton setExclusiveTouch:YES];
        [enNameDescButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enNameDescButton];
        
        UILabel *enNameDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, enNameDescButton.frame.size.width - enNameDescButton.frame.size.height / 4, enNameDescButton.frame.size.height)];
        enNameDescLabel.layer.borderColor = color.CGColor;
        enNameDescLabel.layer.borderWidth = 1.f;
        enNameDescLabel.backgroundColor = [UIColor whiteColor];
        enNameDescLabel.text = @"英文倒序";
        enNameDescLabel.textAlignment = NSTextAlignmentCenter;
        enNameDescLabel.textColor = color;
        enNameDescLabel.font = [UIFont systemFontOfSize:18.f];
        [enNameDescButton addSubview:enNameDescLabel];
        
        switch (type) {
            case 0:
            {
                scrollHeight = frameHeight * 6 - 6;
                
                UIButton *locationAscButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 4 -5, frame.size.width + 1, frameHeight)];
                [locationAscButton setTag:5];
                [locationAscButton setExclusiveTouch:YES];
                [locationAscButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:locationAscButton];
                
                UILabel *locationAscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, locationAscButton.frame.size.width - locationAscButton.frame.size.height / 4, locationAscButton.frame.size.height)];
                locationAscLabel.layer.borderColor = color.CGColor;
                locationAscLabel.layer.borderWidth = 1.f;
                locationAscLabel.backgroundColor = [UIColor whiteColor];
                locationAscLabel.text = @"商号顺序";
                locationAscLabel.textAlignment = NSTextAlignmentCenter;
                locationAscLabel.textColor = color;
                locationAscLabel.font = [UIFont systemFontOfSize:18.f];
                [locationAscButton addSubview:locationAscLabel];
                
                UIButton *locationDescButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 5 -6, frame.size.width + 1, frameHeight)];
                [locationDescButton setTag:6];
                [locationDescButton setExclusiveTouch:YES];
                [locationDescButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:locationDescButton];
                
                UILabel *locationDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, locationDescButton.frame.size.width - locationDescButton.frame.size.height / 4, locationDescButton.frame.size.height)];
                locationDescLabel.layer.borderColor = color.CGColor;
                locationDescLabel.layer.borderWidth = 1.f;
                locationDescLabel.backgroundColor = [UIColor whiteColor];
                locationDescLabel.text = @"商号倒序";
                locationDescLabel.textAlignment = NSTextAlignmentCenter;
                locationDescLabel.textColor = color;
                locationDescLabel.font = [UIFont systemFontOfSize:18.f];
                [locationDescButton addSubview:locationDescLabel];
                break;
            }
            case 1:
            {
                scrollHeight = frameHeight * 6 - 6;
                
                UIButton *endTimeAscButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 4 -5, frame.size.width + 1, frameHeight)];
                [endTimeAscButton setTag:7];
                [endTimeAscButton setExclusiveTouch:YES];
                [endTimeAscButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:endTimeAscButton];
                
                UILabel *endTimeAscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, endTimeAscButton.frame.size.width - endTimeAscButton.frame.size.height / 4, endTimeAscButton.frame.size.height)];
                endTimeAscLabel.layer.borderColor = color.CGColor;
                endTimeAscLabel.layer.borderWidth = 1.f;
                endTimeAscLabel.backgroundColor = [UIColor whiteColor];
                endTimeAscLabel.text = @"结束时间顺序";
                endTimeAscLabel.textAlignment = NSTextAlignmentCenter;
                endTimeAscLabel.textColor = color;
                endTimeAscLabel.font = [UIFont systemFontOfSize:18.f];
                [endTimeAscButton addSubview:endTimeAscLabel];
                
                UIButton *endTimeDescButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 5 -6, frame.size.width + 1, frameHeight)];
                [endTimeDescButton setTag:8];
                [endTimeDescButton setExclusiveTouch:YES];
                [endTimeDescButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:endTimeDescButton];
                
                UILabel *endTimeDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, endTimeDescButton.frame.size.width - endTimeDescButton.frame.size.height / 4, endTimeDescButton.frame.size.height)];
                endTimeDescLabel.layer.borderColor = color.CGColor;
                endTimeDescLabel.layer.borderWidth = 1.f;
                endTimeDescLabel.backgroundColor = [UIColor whiteColor];
                endTimeDescLabel.text = @"结束时间倒序";
                endTimeDescLabel.textAlignment = NSTextAlignmentCenter;
                endTimeDescLabel.textColor = color;
                endTimeDescLabel.font = [UIFont systemFontOfSize:18.f];
                [endTimeDescButton addSubview:endTimeDescLabel];
                
                
                break;
            }
            case 2:
            {
                scrollHeight = frameHeight * 6 - 6;
                
                UIButton *uploadAscButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 4 - 5, frame.size.width + 1, frameHeight)];
                [uploadAscButton setTag:9];
                [uploadAscButton setExclusiveTouch:YES];
                [uploadAscButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:uploadAscButton];
                
                UILabel *uploadAscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, uploadAscButton.frame.size.width - uploadAscButton.frame.size.height / 4, uploadAscButton.frame.size.height)];
                uploadAscLabel.layer.borderColor = color.CGColor;
                uploadAscLabel.layer.borderWidth = 1.f;
                uploadAscLabel.backgroundColor = [UIColor whiteColor];
                uploadAscLabel.text = @"上传顺序";
                uploadAscLabel.textAlignment = NSTextAlignmentCenter;
                uploadAscLabel.textColor = color;
                uploadAscLabel.font = [UIFont systemFontOfSize:18.f];
                [uploadAscButton addSubview:uploadAscLabel];
                
                UIButton *uploadDescButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 5 - 6, frame.size.width + 1, frameHeight)];
                [uploadDescButton setTag:10];
                [uploadDescButton setExclusiveTouch:YES];
                [uploadDescButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:uploadDescButton];
                
                UILabel *uploadDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, uploadDescButton.frame.size.width - uploadDescButton.frame.size.height / 4, uploadDescButton.frame.size.height)];
                uploadDescLabel.layer.borderColor = color.CGColor;
                uploadDescLabel.layer.borderWidth = 1.f;
                uploadDescLabel.backgroundColor = [UIColor whiteColor];
                uploadDescLabel.text = @"上传倒序";
                uploadDescLabel.textAlignment = NSTextAlignmentCenter;
                uploadDescLabel.textColor = color;
                uploadDescLabel.font = [UIFont systemFontOfSize:18.f];
                [uploadDescButton addSubview:uploadDescLabel];
                
                
                break;
            }
            case 3:
            {
                scrollHeight = frameHeight * 8 - 8;
                
                UIButton *priceAscButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 4 -5, frame.size.width + 1, frameHeight)];
                [priceAscButton setTag:11];
                [priceAscButton setExclusiveTouch:YES];
                [priceAscButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:priceAscButton];
                
                UILabel *priceAscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, priceAscButton.frame.size.width - priceAscButton.frame.size.height / 4, priceAscButton.frame.size.height)];
                priceAscLabel.layer.borderColor = color.CGColor;
                priceAscLabel.layer.borderWidth = 1.f;
                priceAscLabel.backgroundColor = [UIColor whiteColor];
                priceAscLabel.text = @"价格顺序";
                priceAscLabel.textAlignment = NSTextAlignmentCenter;
                priceAscLabel.textColor = color;
                priceAscLabel.font = [UIFont systemFontOfSize:18.f];
                [priceAscButton addSubview:priceAscLabel];
                
                UIButton *priceDescButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 5 -6, frame.size.width + 1, frameHeight)];
                [priceDescButton setTag:12];
                [priceDescButton setExclusiveTouch:YES];
                [priceDescButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:priceDescButton];
                
                UILabel *priceDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, priceDescButton.frame.size.width - priceDescButton.frame.size.height / 4, priceDescButton.frame.size.height)];
                priceDescLabel.layer.borderColor = color.CGColor;
                priceDescLabel.layer.borderWidth = 1.f;
                priceDescLabel.backgroundColor = [UIColor whiteColor];
                priceDescLabel.text = @"价格倒序";
                priceDescLabel.textAlignment = NSTextAlignmentCenter;
                priceDescLabel.textColor = color;
                priceDescLabel.font = [UIFont systemFontOfSize:18.f];
                [priceDescButton addSubview:priceDescLabel];
                
                
                UIButton *descountAscButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 6 -7, frame.size.width + 1, frameHeight)];
                [descountAscButton setTag:13];
                [descountAscButton setExclusiveTouch:YES];
                [descountAscButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:descountAscButton];
                
                UILabel *descountAscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, descountAscButton.frame.size.width - descountAscButton.frame.size.height / 4, descountAscButton.frame.size.height)];
                descountAscLabel.layer.borderColor = color.CGColor;
                descountAscLabel.layer.borderWidth = 1.f;
                descountAscLabel.backgroundColor = [UIColor whiteColor];
                descountAscLabel.text = @"折扣顺序";
                descountAscLabel.textAlignment = NSTextAlignmentCenter;
                descountAscLabel.textColor = color;
                descountAscLabel.font = [UIFont systemFontOfSize:18.f];
                [descountAscButton addSubview:descountAscLabel];
                
                UIButton *descountDescButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 7 -8, frame.size.width + 1, frameHeight)];
                [descountDescButton setTag:14];
                [descountDescButton setExclusiveTouch:YES];
                [descountDescButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:descountDescButton];
                
                UILabel *descountDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, descountDescButton.frame.size.width - descountDescButton.frame.size.height / 4, descountDescButton.frame.size.height)];
                descountDescLabel.layer.borderColor = color.CGColor;
                descountDescLabel.layer.borderWidth = 1.f;
                descountDescLabel.backgroundColor = [UIColor whiteColor];
                descountDescLabel.text = @"折扣倒序";
                descountDescLabel.textAlignment = NSTextAlignmentCenter;
                descountDescLabel.textColor = color;
                descountDescLabel.font = [UIFont systemFontOfSize:18.f];
                [descountDescButton addSubview:descountDescLabel];
                break;
            }
            default:
                break;
        }
        } else {
            UILabel *chNameAscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chNameAscButton.frame.size.width - chNameAscButton.frame.size.height / 4, chNameAscButton.frame.size.height)];
            chNameAscLabel.layer.borderColor = color.CGColor;
            chNameAscLabel.layer.borderWidth = 1.f;
            chNameAscLabel.backgroundColor = [UIColor whiteColor];
            chNameAscLabel.text = @"中文顺序";
            chNameAscLabel.textAlignment = NSTextAlignmentCenter;
            chNameAscLabel.textColor = color;
            chNameAscLabel.font = [UIFont systemFontOfSize:18.f];
            [chNameAscButton addSubview:chNameAscLabel];
            
            UIButton *chNameDescButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight -2, frame.size.width + 1, frameHeight)];
            [chNameDescButton setTag:2];
            [chNameDescButton setExclusiveTouch:YES];
            [chNameDescButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:chNameDescButton];
            
            UILabel *chNameDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chNameDescButton.frame.size.width - chNameDescButton.frame.size.height / 4, chNameDescButton.frame.size.height)];
            chNameDescLabel.layer.borderColor = color.CGColor;
            chNameDescLabel.layer.borderWidth = 1.f;
            chNameDescLabel.backgroundColor = [UIColor whiteColor];
            chNameDescLabel.text = @"中文倒序";
            chNameDescLabel.textAlignment = NSTextAlignmentCenter;
            chNameDescLabel.textColor = color;
            chNameDescLabel.font = [UIFont systemFontOfSize:18.f];
            [chNameDescButton addSubview:chNameDescLabel];
            
            UIButton *enNameAscButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 2 -3, frame.size.width + 1, frameHeight)];
            [enNameAscButton setTag:15];
            [enNameAscButton setExclusiveTouch:YES];
            [enNameAscButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:enNameAscButton];
            
            UILabel *enNameAscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, enNameAscButton.frame.size.width - enNameAscButton.frame.size.height / 4, enNameAscButton.frame.size.height)];
            enNameAscLabel.layer.borderColor = color.CGColor;
            enNameAscLabel.layer.borderWidth = 1.f;
            enNameAscLabel.backgroundColor = [UIColor whiteColor];
            enNameAscLabel.text = @"线上积分顺序";
            enNameAscLabel.textAlignment = NSTextAlignmentCenter;
            enNameAscLabel.textColor = color;
            enNameAscLabel.font = [UIFont systemFontOfSize:18.f];
            [enNameAscButton addSubview:enNameAscLabel];
            
            UIButton *enNameDescButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 3 -4, frame.size.width + 1, frameHeight)];
            [enNameDescButton setTag:16];
            [enNameDescButton setExclusiveTouch:YES];
            [enNameDescButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:enNameDescButton];
            
            UILabel *enNameDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, enNameDescButton.frame.size.width - enNameDescButton.frame.size.height / 4, enNameDescButton.frame.size.height)];
            enNameDescLabel.layer.borderColor = color.CGColor;
            enNameDescLabel.layer.borderWidth = 1.f;
            enNameDescLabel.backgroundColor = [UIColor whiteColor];
            enNameDescLabel.text = @"线上积分倒序";
            enNameDescLabel.textAlignment = NSTextAlignmentCenter;
            enNameDescLabel.textColor = color;
            enNameDescLabel.font = [UIFont systemFontOfSize:18.f];
            [enNameDescButton addSubview:enNameDescLabel];
            
            scrollHeight = frameHeight * 6 - 6;
            
            UIButton *locationAscButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 4 -5, frame.size.width + 1, frameHeight)];
            [locationAscButton setTag:17];
            [locationAscButton setExclusiveTouch:YES];
            [locationAscButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:locationAscButton];
            
            UILabel *locationAscLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, locationAscButton.frame.size.width - locationAscButton.frame.size.height / 4, locationAscButton.frame.size.height)];
            locationAscLabel.layer.borderColor = color.CGColor;
            locationAscLabel.layer.borderWidth = 1.f;
            locationAscLabel.backgroundColor = [UIColor whiteColor];
            locationAscLabel.text = @"线下积分顺序";
            locationAscLabel.textAlignment = NSTextAlignmentCenter;
            locationAscLabel.textColor = color;
            locationAscLabel.font = [UIFont systemFontOfSize:18.f];
            [locationAscButton addSubview:locationAscLabel];
            
            UIButton *locationDescButton = [[UIButton alloc] initWithFrame:CGRectMake(-1, frame.size.height * 0.75 + frameHeight * 5 -6, frame.size.width + 1, frameHeight)];
            [locationDescButton setTag:18];
            [locationDescButton setExclusiveTouch:YES];
            [locationDescButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:locationDescButton];
            
            UILabel *locationDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, locationDescButton.frame.size.width - locationDescButton.frame.size.height / 4, locationDescButton.frame.size.height)];
            locationDescLabel.layer.borderColor = color.CGColor;
            locationDescLabel.layer.borderWidth = 1.f;
            locationDescLabel.backgroundColor = [UIColor whiteColor];
            locationDescLabel.text = @"线下积分倒序";
            locationDescLabel.textAlignment = NSTextAlignmentCenter;
            locationDescLabel.textColor = color;
            locationDescLabel.font = [UIFont systemFontOfSize:18.f];
            [locationDescButton addSubview:locationDescLabel];
            
        }
        

        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height * 0.75)];
    }
    return self;
}

- (void)tappedSortButton {
    if (self.isShow) {
        [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - scrollHeight)];
        }completion:^(BOOL finished){
            self.isShow = NO;
        }];
    } else {
        [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + scrollHeight)];
        }completion:^(BOOL finished){
            self.isShow = YES;
        }];
    }
}

- (void)tappedOptionButton:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            sortLabel.text = @"中文顺序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeCHNameAsc];
            }
            break;
        case 2:
            sortLabel.text = @"中文倒序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeCHNameDesc];
            }
            break;
        case 3:
            sortLabel.text = @"英文顺序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeENNameAsc];
            }
            break;
        case 4:
            sortLabel.text = @"英文倒序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeENNameDesc];
            }
            break;
        case 5:
            sortLabel.text = @"商号顺序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeLocation];
            }
            break;
        case 6:
            sortLabel.text = @"商号倒序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeDescLocation];
            }
            break;
        case 7:
            sortLabel.text = @"结束时间顺序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeEndDateAsc];
            }
            break;
        case 8:
            sortLabel.text = @"结束时间倒序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeEndDateDesc];
            }
            break;
        case 9:
            sortLabel.text = @"上传顺序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeUploadDateDesc];
            }
            break;
        case 10:
            sortLabel.text = @"上传倒序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeUploadDateAsc];
            }
            break;
        case 11:
            sortLabel.text = @"价格顺序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeDiscountAsc];
            }
            break;
        case 12:
            sortLabel.text = @"价格倒序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeDiscountDesc];
            }
            break;
        case 13:
            sortLabel.text = @"折扣顺序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeDiscountRateAsc];
            }
            break;
        case 14:
            sortLabel.text = @"折扣倒序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeDiscountRateDesc];
            }
            break;
        case 15:
            sortLabel.text = @"线上积分顺序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeOnlinePointAsc];
            }
            break;
        case 16:
            sortLabel.text = @"线上积分倒序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeOnlinePointDesc];
            }
            break;
        case 17:
            sortLabel.text = @"线下积分顺序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeOfflinePointAsc];
            }
            break;
        case 18:
            sortLabel.text = @"线下积分倒序";
            if (_delegate && [_delegate respondsToSelector:@selector(dropDownListView:didTapOption:)]) {
                [_delegate dropDownListView:self didTapOption:SortTypeOfflinePointDesc];
            }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height - scrollHeight)];
    }completion:^(BOOL finished){
        self.isShow = NO;
    }];
}

@end
