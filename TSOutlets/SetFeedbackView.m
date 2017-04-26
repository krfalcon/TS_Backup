//
//  SetFeedbackView.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/5/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "SetFeedbackView.h"

@implementation SetFeedbackView

- (void)initView {
    setFeedbackView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    [setFeedbackView setContentSize:CGSizeMake(selfWidth, selfHeight + 200 * self.scale)];
    [self addSubview:setFeedbackView];

    endTextingButton = [[UIButton alloc] initWithFrame:self.bounds];
    [endTextingButton setEnabled:NO];
    [endTextingButton setExclusiveTouch:YES];
    [endTextingButton addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    [setFeedbackView addSubview:endTextingButton];
    
    textfield = [[UITextView alloc] initWithFrame:CGRectMake(30 * self.scale, 30 * self.scale, self.frame.size.width - 60 * self.scale, 200 * self.scale)];
    textfield.layer.borderColor = ThemeRed.CGColor;
    textfield.layer.borderWidth = 1.5f * self.scale;
    [textfield setFont:[UIFont systemFontOfSize:18 * self.scale]];
    [textfield setBackgroundColor:AbsoluteWhite];
    //[textfield setDelegate:self];
    [textfield setReturnKeyType:UIReturnKeyDone];
    [setFeedbackView addSubview:textfield];
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(132.5 * self.scale, 250 * self.scale, 110 * self.scale, 41 * self.scale)];
    [commitButton setExclusiveTouch:YES];
    [commitButton addTarget:self action:@selector(tappedSendFeedbackButton) forControlEvents:UIControlEventTouchUpInside];
    [setFeedbackView addSubview:commitButton];
    
    UIImageView *commitView = [[UIImageView alloc] initWithFrame:commitButton.bounds];
    [commitView setImage:[UIImage imageNamed:@"sendmessageButton"]];
    [commitButton addSubview:commitView];
    
    UILabel *upperLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * self.scale, 320 * self.scale, selfWidth - 60 * self.scale, 100 * self.scale)];
    [upperLabel setText:@"          如遇到APP使用上的问题、意见、建议以及遇到BUG，请在此写下详细的信息及情况发送给我们，以帮助我们改善问题，谢谢。"];
    [upperLabel setTextColor:ThemeRed];
    [upperLabel setFont:[UIFont systemFontOfSize:16 * self.scale]];
    [upperLabel setNumberOfLines:0];
    [setFeedbackView addSubview: upperLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(113.5 * self.scale, 420 * self.scale, 148 * self.scale, 114 * self.scale)];
    [imageView setImage:[UIImage imageNamed:@"sendmessage"]];
    [setFeedbackView addSubview:imageView];

}

- (void)tappedSendFeedbackButton{
    if (textfield.text.length > 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(setFeedbackViewDidTapCommitButton:)]) {
            [_delegate setFeedbackViewDidTapCommitButton:textfield.text];
            textfield.text = @"";
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textfield resignFirstResponder];
    
    return YES;
}


@end
