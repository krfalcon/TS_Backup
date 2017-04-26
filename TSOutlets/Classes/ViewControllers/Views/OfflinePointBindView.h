//
//  OfflinePointBindView.h
//  TSOutlets
//
//  Created by 奚潇川 on 15/5/20.
//  Copyright (c) 2015年 奚潇川. All rights reserved.
//

#import "TempletView.h"

#import "InputView.h"

@protocol OfflinePointBindViewDelegate;

@interface OfflinePointBindView : TempletView <UIScrollViewDelegate,UITextFieldDelegate>
{
    NSTimer*                                                            timer;
    int                                                                 timeLeft;
    InputView*                                                          cardField;
    InputView*                                                          nameField;
    
    UIButton*                                                           endTextingButton;
}

@property (weak, nonatomic) id<OfflinePointBindViewDelegate>            delegate;

@end

@protocol OfflinePointBindViewDelegate <NSObject>

- (void)scrollViewDidScroll;
- (void)offlinePointBindViewDidTapBindButtonWithCardNumber:(NSString *)cardNumber andPassword:(NSString *)password;

@end
