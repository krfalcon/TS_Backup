//
//  SetFeedbackView.h
//  TSOutlets
//
//  Created by ZhuYiqun on 11/5/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempletView.h"

@protocol SetFeedbackViewDelegate;

@interface SetFeedbackView : TempletView <UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    UIScrollView*             setFeedbackView;
    UITextView*               textfield;
    
    UIButton*                 endTextingButton;
}

@property (weak, nonatomic)   id<SetFeedbackViewDelegate>           delegate;

@end

@protocol SetFeedbackViewDelegate <NSObject>

- (void)setFeedbackViewDidTapCommitButton:(NSString *)text;

@end