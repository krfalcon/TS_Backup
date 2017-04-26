//
//  SetFeedbackViewController.m
//  TSOutlets
//
//  Created by ZhuYiqun on 11/5/15.
//  Copyright © 2015 奚潇川. All rights reserved.
//

#import "SetFeedbackViewController.h"

@interface SetFeedbackViewController ()

@end

@implementation SetFeedbackViewController

- (void)initFirstViewWithParameter:(NSDictionary *)parameter
{
    if (!setFeedbackView) {
        setFeedbackView = [[SetFeedbackView alloc] initWithFrame:self.view.bounds];
        [setFeedbackView setDelegate:self];
        [self.view addSubview:setFeedbackView];
    }
    
}

- (void)setFeedbackViewDidTapCommitButton:(NSString *)text
{
    ServiceAPITool *sat = [[ServiceAPITool alloc] init];
    [sat sendfeedback:text];
}

@end
